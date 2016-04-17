starting_level_name = "assets/maps/bestmap.lua"
current_level_name = "assets/maps/bestmap.lua"
local loading = {}
loading.loaded = 1
loading.first = true

-- Loading screen phases, split up loading code among these phases
loading.phases = {
    function()

    require 'assets.music.script1'.load()

    end,
    function()
        end,
        function()
            game.enemies = {}
            game.enemy_ids_to_delete = {}
                    game.world = core.bump.newWorld()
        game.objects = {}
        game.blocks = {}
    game.n_blocks = 0
    game.projectiles = {}
    game.loadMap("assets/maps/bestmap.lua")

    end,
    function()

        require ("entities.watcher")
        require ("entities.archer")
        require ("entities.enemy")
        load_objects(map)

   game.player = require 'entities.player'()
    game.player.load()
    print("LP")
    game.camera = core.camera(0,0,2)
    end,
    function()


       
    end
}

function loading:enter(from)
     print("LOADING")
     game = nil

     game = {}
     game.abstractmap={}
     game.loadMap = core.loadMap
   collectgarbage("collect") 
    if loading.first then
     loading.loaded = 1
    else
    loading.loaded=2
    end

end
-- Leave loading screen
function loading:leave(from)
    print("GAME LOADED")
end
function loading:update()
    if self.loaded <= #self.phases then
        self.phases[self.loaded]()
        self.loaded = self.loaded + 1
    else
        GS:pop()
    end

end
-- Draw loading screen
function loading:draw()
    local W, H = love.graphics.getWidth(), love.graphics.getHeight()
    print(game.map)
    -- draw previous screen
    -- overlay with pause message
    love.graphics.setColor(0,0,0, 100)
    love.graphics.rectangle('fill', 0,0, W,H)
    love.graphics.setColor(255,255,255)
  love.graphics.print("Loading", 400, 20 )
  love.graphics.rectangle( "fill", 50, 50, (loading.loaded/#loading.phases)*100, 50 )
end
function loading:keypressed(key)

end
return loading


