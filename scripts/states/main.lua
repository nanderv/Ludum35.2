local ctx = GS.new()
function ctx:enter(dt)
    GS.push(core.states.loading)

    print("LOADING")
end
function ctx:update(dt)

    core.events.exec(dt)
    core.music.script.update(dt)
    for _,enemy in pairs(game.enemies) do
        enemy.update(dt)
    end
    for _,obj in pairs(game.projectiles) do
        obj:update(dt)
    end
    game.player.update(dt)
end
function ctx:draw()
    local W, H = love.graphics.getWidth(), love.graphics.getHeight()
    -- draw previous screen
    game.camera:attach()
    local x,y = game.camera:position()
    game.map:draw(x,y,love.graphics.getWidth()/2, love.graphics.getHeight()/2)
      if DEBUG.hax then
        DEBUG.bump_debug.draw(game.world)
      end
    for _,enemy in pairs(game.enemies) do
        enemy.draw()
    end
    game.player.draw()
    game.camera:detach()
for _,obj in pairs(game.projectiles) do
        obj:draw()
    end
      love.graphics.print(love.timer.getFPS(), 400, 20 )

end
return ctx