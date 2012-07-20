
mobles = {
  deleting = false
}

minetest.register_node("mobles:deleter", {
  description = 'Snake deleter',
  tile_images = { "default_stone.png" },
  is_ground_content = true,
  groups = {fleshy=3},
  sounds = default.node_sound_stone_defaults(),
  drop = 'craft "mobles:deleter" 1',
  on_place = function(item, place, pointed)
    mobles.deleting = not mobles.deleting
    print("Deleting:" .. tostring(mobles.deleting))

    pos = minetest.get_pointed_thing_position(pointed, true)
		if pos ~= nil then
      minetest.env:add_node(pos, {name='mobles:deleter'})
			item:take_item()
			return item
    end
  end
})

minetest.register_node("mobles:snake_head", {
  description = 'Snake head',
  tile_images = { "default_stone.png^mobles_snake_head.png" },
  is_ground_content = true,
  groups = {fleshy=3},
  sounds = default.node_sound_stone_defaults(),
  drop = 'craft "mobles:snake_head" 1',
  on_place = function(item, place, pointed)
    print "AWESOME SNAKE HEAD PLACEMENT!"

    pos = minetest.get_pointed_thing_position(pointed, true)
    mobles.head_pos = pos

		if pos ~= nil then
      minetest.env:add_node(pos, {name='mobles:snake_head'})

      local meta = minetest.env:get_meta(pos)
      meta:set_int("favourite_direction", math.random(0, 3))
      meta:set_int("length_remaining", 50)

			item:take_item()
			return item
    end
  end
})

minetest.register_node("mobles:snake_segment", {
  description = 'Snake segment',
  tile_images = { "default_stone.png^mobles_snake_segment.png" },
  is_ground_content = true,
  groups = {fleshy=3},
  sounds = default.node_sound_stone_defaults(),
  drop = 'craft "mobles:snake_segment" 1',
})


minetest.register_craft( {
	output = 'mobles:snake_segment 50',
	recipe = {
		{ 'default:cobble' }
	},
})

minetest.register_craft( {
	output = 'mobles:snake_head 50',
	recipe = {
		{ 'default:cobble' },
		{ 'default:cobble' }
	},
})

minetest.register_craft( {
	output = 'mobles:deleter 1',
	recipe = {
		{ 'default:cobble' },
		{ 'default:cobble' },
		{ 'default:cobble' }
	},
})

-- delete snake segments
minetest.register_abm({
		nodenames = { "mobles:snake_segment" },
		interval = 1,
		chance = 1,
		action = function(pos, node, active_object_count, active_object_count_wider)
      if mobles.deleting then
        minetest.env:remove_node(pos)
      end
    end
})

minetest.register_abm({
		nodenames = { "mobles:snake_head" },
		interval = 1,
		chance = 1,
		action = function(pos, node, active_object_count, active_object_count_wider)
      if mobles.deleting then
        minetest.env:remove_node(pos)
      end
    end
})

minetest.register_abm({
		nodenames = { "mobles:snake_head" },
		interval = 5,
		chance = 1,
		action = function(pos, node, active_object_count, active_object_count_wider)

      local meta = minetest.env:get_meta(pos)
      local fav_dir = meta:get_int("favourite_direction")
      local length_remaining = meta:get_int("length_remaining")

      if length_remaining > 0 then
        print("Growing, length: " .. tostring(length_remaining))
        length_remaining = length_remaining - 1

        new_head_pos = mobles.grow_snake_from_pos(pos, fav_dir)

        meta = minetest.env:get_meta(new_head_pos)
        meta:set_int("favourite_direction", fav_dir)
        meta:set_int("length_remaining", length_remaining)
      end
    end
})


mobles.grow_snake_from_pos = function(pos, fav_dir)
  a = 0
  b = 0
  c = 0

  if math.random(0, 4) == 0 then
    -- unlikely, but pick a totally random direction
    r = math.random(0, 5)

    if r == 0 then
      a = -1
    elseif r == 1 then
      a = 1
    elseif r == 2 then
      b = -1
    elseif r == 3 then
      b = 1
    elseif r == 4 then
      c = -1
    elseif r == 5 then
      c = 1
    end
  else
    -- much more likely: go in the favourite direction
    if fav_dir == 0 then
      a = -1
    elseif fav_dir == 1 then
      a = 1
    elseif fav_dir == 2 then
      c = -1
    elseif fav_dir == 3 then
      c = 1
    end
  end

  local adjacent = {x = pos.x + a, y = pos.y + b, z = pos.z + c}
  local node_adjacent = minetest.env:get_node(adjacent)

  if node_adjacent.name == "air" then
    minetest.env:add_node(adjacent,{type=node, name="mobles:snake_head"})
    minetest.env:add_node(pos,{type=node, name="mobles:snake_segment"})
  end

  return adjacent
end


print("MOBLES LOADED!!!")

