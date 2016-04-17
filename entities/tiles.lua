require 'entities.objects'
tile_width =32
tile_height=32
local function addBlock(x,y,w,h,game,isPorcupine, isCatWater)
  local block = {x=x,y=y,w=w,h=h,ctype="aa"}
  game.n_blocks =game.n_blocks +1
  if not isCatWater  then
    block.isWall = true
  else
      block.isCatWater = true
    end
  block.isPorcupine = isPorcupine
  game.blocks["a"..game.n_blocks] = block
  game.world:add(block, x,y,w,h)
  return block
end
function load_objects()
  local layer = game.map.layers["objects"]  
        if layer == nil then

        return
      end
  local map = game.map

  local o = layer.objects
  for _, v in pairs(o) do
    if  v then
    --  if v.properties.type =="line" then
      
      if v.type == "start" then
          game.startX = v.x
          game.startY = v.y
      end
      if v.type == "watcher" then
          game.enemies[#game.enemies + 1]= getNewWatcher(v.x,v.y,{{x=59, y=127},{x=59, y=400}})
      end
      if v.type == "enemy" then
        game.enemies[#game.enemies + 1]= getNewEnemy(v.x,v.y,{{x=59, y=127},{x=59, y=400}},200)
      end
      if v.type == "boss" then
        game.enemies[#game.enemies + 1]= getNewMrT(v.x,v.y,{{x=59, y=127},{x=59, y=400}})
      end
      if v.type == "heart" then
        print(v.x, v.y)
      end
      if v.type == "health" then
          print(v.x, v.y)
      end
      if v.type == "key" then
        print(v.x, v.y)
      end
      if v.type == "target" then
        print(v.x, v.y)
      end

    end
  end
  return enemies


end

local function load_cat_water(map)
  local layer = map.layers["cat_water"]  
        if layer == nil then
        return

      end
        for y = 1, map.height do

        for x = 1, map.width do

          if layer.data[y][x] then
              addBlock((x-1)*tile_width,(y-1)*tile_height,tile_width,tile_height,game,false,true)


          end
        end
end
end


local function load_armadillo_gates(map)
  local layer = map.layers["armadillo_gates"]  
        if layer == nil then
        return
      end
        for y = 1, map.height do

        for x = 1, map.width do

          if layer.data[y][x] then
      addBlock((x-1)*tile_width,(y-1)*tile_height,tile_width,tile_height,game,false)


        
          end
        end
end
end
local function load_armadillo_walls(map)
  local layer = map.layers["armadillo_burrow"]  
        if layer == nil then
        return
      end
        for y = 1, map.height do

        for x = 1, map.width do

          if layer.data[y][x] then
            
             addBlock((x-1)*tile_width,(y-1)*tile_height,tile_width,tile_height,game,true)


        
          end
        end
end
end
  

core.loadMap=function(filename)
  game.map = sti.new(filename)


    local map = game.map
    local collidable_tiles = {}
    local layer = map.layers["collision"]

    for y = 1, map.height do
      game.abstractmap[y] = {}
      for x = 1, map.width do

        if layer.data[y][x] then
            addBlock((x-1)*tile_width,(y-1)*tile_height,tile_width,tile_height,game, false)
            game.abstractmap[y][x] = 1


      else
        game.abstractmap[y][x] = 0
        end
      end
  end
  local i = 0
  while true do
      i=i+1
       local layer = map.layers["collision"..i]  
      if layer == nil then
        break
      end
      for y = 1, map.height do
   
    
        for x = 1, map.width do

          if layer.data[y][x] then
             addBlock((x-1)*tile_width,(y-1)*tile_height,tile_width,tile_height,game,false)


             game.abstractmap[y][x] = 1
        else
          end
        end
    end
  end
    load_armadillo_walls(map)
    load_armadillo_gates(map)
    load_cat_water(map)

end