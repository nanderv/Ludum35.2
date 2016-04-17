local ctx = GS.new()
function ctx:enter(dt)
    GS.push(core.states.loading)

    print("LOADING")
end
function ctx:update(dt)

    core.events.exec(dt)
    core.music.script.update(dt)
    for z,enemy in pairs(game.enemies) do
        if not enemy.update(dt) then
               

        end
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
for _,obj in pairs(game.projectiles) do
        obj:draw()
    end
    local x,y = game.camera:worldCoords(love.mouse.getPosition())
    love.graphics.line(game.player.x+16,game.player.y+16,x,y)
    game.camera:detach()

      love.graphics.print(love.timer.getFPS(), 400, 20 )

end
return ctx