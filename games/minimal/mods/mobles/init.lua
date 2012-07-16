mobles = {}


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
      {-0.5, -0.15, 0.3, 0.5, 0.15, 0.5},
      {-0.15, -0.5, -0.3, 0.15, 0.5, 0.5},
      {-0.15, -0.15, -0.5, 0.15, 0.15, 0.5},
      {-0.25, -0.45, 0.1, 0.25, 0.45, 0.5},
      {-0.45, -0.25, 0.1, 0.45, 0.25, 0.5},
      {-0.25, -0.25,-0.4, 0.25, 0.25, 0.5},
      {-0.35, -0.4, -0.1, 0.35, 0.4, 0.5},
      {-0.4, -0.35, -0.1, 0.4, 0.35, 0.5},
      {-0.35, -0.35, -0.3, 0.35, 0.35, 0.5},
    },
  },
  groups = {snappy=2,choppy=2,oddly_breakable_by_hand=2}
})

minetest.register_craft( {
	output = 'mobles:snake_segment 50',
	recipe = {
		{ 'default:wood' }
	},
})

function mobles.on_step(dtime)
end
minetest.register_globalstep(mobles.on_step)

function mobles.on_placenode(p, node)
  if node.name ~= "mobles:snake_segment" then return end
	nodeupdate(p)
end
minetest.register_on_placenode(mobles.on_placenode)

minetest.log("MOBLES LOADED!!!")

