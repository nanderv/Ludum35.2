levels  = {"assets/maps/bestmap.lua","assets/maps/testmap.lua","assets/maps/bestmap.lua"}
current_level = 1
to_load = false
true_mode = false
local loading = {}
loading.loaded = 1
loading.first = true

-- Loading screen phases, split up loading code among these phases
loading.phases = {
    function()
        if game and game.player and game.player.health then
            loading.health = game.player.health
            loading.max_health = game.player.max_health
        end

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
    if current_level > #levels then
        print(current_level)
        GS.switch(core.states.victory)
        return
    end
    game.loadMap(levels[current_level])

    end,
    function()
          game.startX = 100
          game.startY = 100
        require ("entities.watcher")
        require ("entities.archer")
        require ("entities.enemy")
        load_objects(map)

   game.player = require 'entities.player'()

    game.player.load()
    print(game.player)
    game.camera = core.camera(0,0,2)
    end,
    function()

        if loading.health then
               game.player.health  =       loading.health 
           game.player.max_health =  loading.max_health
       end
       
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
    to_load = false
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


