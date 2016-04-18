require 'entities.objects'
tile_width =32
tile_height=32
local function addBlock(x,y,w,h,game,type)
  local block = {x=x,y=y,w=w,h=h,ctype=type}
  game.n_blocks =game.n_blocks +1
  block[type] = true
  

  game.blocks["a"..game.n_blocks] = block
  game.world:add(block, x,y,w,h)
  return block
end

local function addObject(x,y,type)
  local w,h = 16,16
  local block = {x=x,y=y,ctype=type}
  game.n_blocks =game.n_blocks +1
  block[type] = type
  game.blocks["a"..game.n_blocks] = block
  game.world:add(block, x,y,w,h)
  block.af = love.math.random(1,#core.objects[type])

  game.objects[#game.objects+1] = block
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
          game.enemies[#game.enemies + 1]= getNewWatcher(v.x,v.y,{{x=v.x, y=v.y},{x=v.x, y=v.y+10}},200)
          game.enemies[#game.enemies].id =   #game.enemies
      end
      if v.type == "enemy" then
        game.enemies[#game.enemies + 1]= getNewEnemy(v.x,v.y,{{x=v.x, y=v.y},{x=v.x, y=v.y+10}})
        game.enemies[#game.enemies].id =   #game.enemies
        print(game.enemies[#game.enemies])
        print("ENEMY")
      end
        if v.type == "archer" then
        game.enemies[#game.enemies + 1]= getNewArcher(v.x,v.y,{{x=v.x, y=v.y},{x=v.x, y=v.y+10}})
        game.enemies[#game.enemies].id =   #game.enemies
        print("ENEMY")
      end
      if v.type == "boss" then
        require "entities.mrt"
        game.enemies[#game.enemies + 1]= getNewMrT(v.x,v.y)
        game.enemies[#game.enemies].id =   #game.enemies
        
      end
      if v.type == "heart" then
        addObject(v.x,v.y,"isHeart")
      end
      if v.type == "health" then
        addObject(v.x,v.y,"isHealth")
      end
      if v.type == "key" then
        addObject(v.x,v.y,"isKey")
      end
      if v.type == "target" then
        addObject(v.x,v.y,"isTarget")
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
              addBlock((x-1)*tile_width,(y-1)*tile_height,tile_width,tile_height,game,"isCatWater")


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
            
             addBlock((x-1)*tile_width,(y-1)*tile_height,tile_width,tile_height,game,"isPorcupine")


        
          end
        end
end
end
  


local function load_exit_walls(map)
  local layer = map.layers["exit"]  
        if layer == nil then
        return
      end
        for y = 1, map.height do

        for x = 1, map.width do

          if layer.data[y][x] then
            
             addBlock((x-1)*tile_width,(y-1)*tile_height,tile_width,tile_height,game,"isExit")


        
          end
        end
end
end
  

local function       load_gate_closed(map)
  local layer = map.layers["gate_closed"]  
        if layer == nil then
        return
      end
        for y = 1, map.height do

        for x = 1, map.width do

          if layer.data[y][x] then
            
             addBlock((x-1)*tile_width,(y-1)*tile_height,tile_width,tile_height,game,"isGate")


        
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
            addBlock((x-1)*tile_width,(y-1)*tile_height,tile_width,tile_height,game, "isWall")
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
             addBlock((x-1)*tile_width,(y-1)*tile_height,tile_width,tile_height,game,"isWall")


             game.abstractmap[y][x] = 1
        else
          end
        end
    end
  end
    load_armadillo_walls(map)
    load_cat_water(map)
    load_exit_walls(map)
      load_gate_closed(map)


end