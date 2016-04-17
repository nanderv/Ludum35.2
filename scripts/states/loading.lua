local loading = {}
loading.loaded = 1
-- Loading screen phases, split up loading code among these phases
loading.phases = {
    function()
        game.world = core.bump.newWorld()
    end,
    function()
    require 'assets.music.script1'.load()
        end,
        function()
    game.loadMap("assets/maps/bestmap.lua")

    end,
    function()
    game.player = require 'entities.player'
    game.player.load()
    game.camera = core.camera(0,0,2)
    print(game.camera)
    end,
    function()
        core.enemy = require ("entities.watcher")
        game.enemies={}
        game.enemies[1]= getNewWatcher({{x=59, y=127},{x=59, y=400}},200)
    end

}
function loading:enter(from)
     print("LOADING")
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


