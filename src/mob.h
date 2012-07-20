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

#ifndef MOB_HEADER
#define MOB_HEADER

#include "irrlichttypes_extrabloated.h"
#include <iostream>

class Mob : public scene::ISceneNode
{
public:
	Mob(
			scene::ISceneNode* parent,
			scene::ISceneManager* mgr,
			s32 id,
			u32 seed,
      v3f player_position
	);

	~Mob();

	/*
		ISceneNode methods
	*/

	virtual void OnRegisterSceneNode();

	virtual void render();

	virtual const core::aabbox3d<f32>& getBoundingBox() const
	{
		return m_box;
	}

	virtual u32 getMaterialCount() const
	{
		return 1;
	}

	virtual video::SMaterial& getMaterial(u32 i)
	{
		return m_material;
	}

	/*
		Other stuff
	*/

	void step(float dtime);

	void update(v2f camera_p, video::SColorf color);

private:
  scene::IAnimatedMesh* m_mesh;
  scene::IMeshSceneNode *m_node;

	video::SMaterial m_material;
	core::aabbox3d<f32> m_box;
	float m_y;
	float m_brightness;
	video::SColorf m_color;
	u32 m_seed;
	v2f m_camera_pos;
	float m_time;
};

#endif
