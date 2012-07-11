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
#include "main.h" // For g_profiler and g_settings
#include "profiler.h"
#include "settings.h"

Mob::Mob(
		scene::ISceneNode* parent,
		scene::ISceneManager* mgr,
		s32 id,
		u32 seed
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

  // draw arb mesh
  //

    m_mesh = mgr->getMesh("/home/leslie/dev/git/minetest/minetest-les/models/pteranodon.md2");
    m_node = mgr->addMeshSceneNode(m_mesh, NULL);
  //m_node = mgr->addAnimatedMeshSceneNode(m_mesh);

    m_mesh->drop();

/*
  m_node->setScale(v3f((m_prop.visual_size.X*BS)/2,
    (m_prop.visual_size.Y*BS)/2,
    (m_prop.visual_size.X*BS)/2));
  u8 li = m_last_light;
  setMeshColor(m_node->getMesh(), video::SColor(255,li,li,li));
*/
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
    //m_node->setMaterialTexture( 0, driver->getTexture("mapeado.png") );
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

