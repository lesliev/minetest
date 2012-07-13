/*
Minetest-c55
Copyright (C) 2010-2011 celeron55, Perttu Ahola <celeron55@gmail.com>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation; either version 2.1 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along
with this program; if not, write to the Free Software Foundation, Inc.,
51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*/

#include "mob.h"
#include "noise.h"
#include "constants.h"
#include "debug.h"
#include "main.h"       // For g_profiler and g_settings
#include "profiler.h"
#include "settings.h"
#include "tile.h"       // For getTexturePath and getModelPath

Mob::Mob(
		scene::ISceneNode* parent,
		scene::ISceneManager* mgr,
		s32 id,
		u32 seed,
    v3f player_position
):
	scene::ISceneNode(parent, mgr, id),
	m_seed(seed),
	m_camera_pos(0,0),
	m_time(0)
{
	m_material.setFlag(video::EMF_LIGHTING, false);
	m_material.setFlag(video::EMF_BACK_FACE_CULLING, true);
	m_material.setFlag(video::EMF_BILINEAR_FILTER, false);
	m_material.setFlag(video::EMF_FOG_ENABLE, true);
	m_material.setFlag(video::EMF_ANTI_ALIASING, true);
	m_material.MaterialType = video::EMT_TRANSPARENT_VERTEX_ALPHA;

	m_y = BS*20;

	m_box = core::aabbox3d<f32>(-BS*1000000,m_y-BS,-BS*1000000,
			BS*1000000,m_y+BS,BS*1000000);


  // load a mesh
  m_mesh = mgr->getMesh(getModelPath("pteranodon").c_str());

  m_node = mgr->addMeshSceneNode(m_mesh, NULL);

  // put it at the player's feet
  m_node->setPosition(player_position);

  m_mesh->drop();
}

Mob::~Mob()
{
}

void Mob::OnRegisterSceneNode()
{
	if(IsVisible)
	{
		SceneManager->registerNodeForRendering(this, scene::ESNRP_SOLID);
	}

	ISceneNode::OnRegisterSceneNode();
}

void Mob::render()
{
	video::IVideoDriver* driver = SceneManager->getVideoDriver();

	if(SceneManager->getSceneNodeRenderPass() != scene::ESNRP_SOLID)
		return;

	ScopeProfiler sp(g_profiler, "Rendering of mob, avg", SPT_AVG);

	m_material.setFlag(video::EMF_BACK_FACE_CULLING, true);

	driver->setTransform(video::ETS_WORLD, AbsoluteTransformation);
	driver->setMaterial(m_material);

	if (m_node)
	{
		m_node->setMaterialFlag(video::EMF_LIGHTING, false);
    m_node->setMaterialTexture(0, driver->getTexture(getTexturePath("pteranodon_map.png").c_str()));
	}
}

void Mob::step(float dtime)
{
	m_time += dtime;
}

void Mob::update(v2f camera_p, video::SColorf color)
{
	m_camera_pos = camera_p;
	m_color = color;
}

