tile_width =32
tile_height=32
game.n_blocks = 0
game.blocks = {}
local function addBlock(x,y,w,h,game)
  local block = {x=x,y=y,w=w,h=h,ctype="aa"}
  game.n_blocks =game.n_blocks +1
  block.isWall = true
  game.blocks["a"..game.n_blocks] = block
  game.world:add(block, x,y,w,h)
  return block
end


game.abstractmap={}
game.loadMap=function(filename)
	game.map = sti.new(filename)


    local map = game.map
    local collidable_tiles = {}
    local layer = map.layers["collision"]
    for y = 1, map.height do
    	game.abstractmap[y] = {}
    	for x = 1, map.width do

        if layer.data[y][x] then
           collidable_tiles[#collidable_tiles] = addBlock((x-1)*tile_width,(y-1)*tile_height,tile_width,tile_height,game)


           game.abstractmap[y][x] = 1
     	else
			game.abstractmap[y][x] = 0
        end
      end
  end

end
