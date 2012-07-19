
mobles = {
  head_pos = nil,
  tick_max = 20,
  tick = 60
}

minetest.register_node("mobles:snake_segment", {
  description = 'Snake segment',
  tiles = {
    "forniture_wood.png",
    "forniture_wood.png",
    "forniture_wood_s1.png",
    "forniture_wood_s1.png",
    "forniture_wood_s2.png",
    "forniture_wood_s2.png",
  },
  drawtype = "nodebox",
  sunlight_propagates = true,
  paramtype = 'light',
  paramtype2 = "facedir",
  node_box = {
    type = "fixed",
    fixed = {
      { 0.48003008, -0.16000000, 0.50000000, 0.45503008, 0.16000000, -0.50000000 }, -- cube2_sep28
      { 0.45253008, -0.24100000, 0.50000000, 0.40253008, 0.24100000, -0.50000000 }, -- cube2_sep27
      { 0.40253008, -0.31500000, 0.50000000, 0.35253008, 0.31500000, -0.50000000 }, -- cube2_sep26
      { 0.35253008, -0.38300000, 0.50000000, 0.30253008, 0.38300000, -0.50000000 }, -- cube2_sep25
      { 0.30029927, -0.40400000, 0.50000000, 0.25029927, 0.40400000, -0.50000000 }, -- cube2_sep24
      { 0.24753008, -0.45200000, 0.50000000, 0.14753008, 0.45200000, -0.50000000 }, -- cube2_copy16
      { -0.48250000, -0.16000000, -0.50000000, -0.45750000, 0.16000000, 0.50000000 }, -- cube2_copy14
      { -0.45500000, -0.24100000, -0.50000000, -0.40500000, 0.24100000, 0.50000000 }, -- cube2_copy13
      { -0.40500000, -0.31500000, -0.50000000, -0.35500000, 0.31500000, 0.50000000 }, -- cube2_copy12
      { -0.35500000, -0.38300000, -0.50000000, -0.30500000, 0.38300000, 0.50000000 }, -- cube2_copy11
      { -0.30276919, -0.40400000, -0.50000000, -0.25276919, 0.40400000, 0.50000000 }, -- cube2_copy10
      { -0.25000000, -0.45200000, -0.50000000, -0.15000000, 0.45200000, 0.50000000 }, -- cube2_copy9
    },
  },
  groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2},
  on_place = function(item, place, pointed)
    print "AWESOME SNAKE PLACEMENT!"

    pos = minetest.get_pointed_thing_position(pointed, true)
    mobles.head_pos = pos

		if pos ~= nil then
      minetest.env:add_node(pos, {name='mobles:snake_segment'})
			item:take_item()
			return item
		end

  end
})

minetest.register_craft( {
	output = 'mobles:snake_segment 50',
	recipe = {
		{ 'default:cobble' }
	},
})

-- delete snake segments
--minetest.register_abm({
--		nodenames = { "mobles:snake_segment" },
--		interval = 0.3,
--		chance = 1,
--		action = function(pos, node, active_object_count, active_object_count_wider)

--      minetest.env:remove_node(pos)
--    end
--})

function on_step(dtime)
  if mobles.tick < 0 then
    mobles.tick = mobles.tick_max
    print "Growing from head!"
    if mobles.head_pos then
      print "HEAD:"
      print(dump(mobles.head_pos))

      --mobles.head_pos = mobles.grow_snake_from_pos(mobles.head_pos)
    end
  else
    mobles.tick = mobles.tick - 1
  end
end
minetest.register_globalstep(on_step)


mobles.grow_snake_from_pos = function(pos)

  a = 0
  b = 0
  c = 0

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

  local adjacent = {x = pos.x + a, y = pos.y + b, z = pos.z + c}
  local node_adjacent = minetest.env:get_node(adjacent)

  if node_adjacent.name == "air" then
    minetest.env:add_node(adjacent,{type=node, name="mobles:snake_segment"})
  end

  return adjacent
end


print("MOBLES LOADED!!!")

