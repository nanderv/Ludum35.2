function draw_object(obj)
    love.graphics.draw(core.objects[obj["ctype"]][obj.af],obj.x,obj.y)
    
end

local ctx = GS.new()
function ctx:enter(dt)
    GS.push(core.states.loading)
    print('entering')
    love.mouse.setGrabbed(true)
end
function ctx:update(dt)

    core.events.exec(dt)
    core.music.script.update(dt)
    local no_enemies = true
    for z,enemy in pairs(game.enemies) do
        no_enemies = false
        if not enemy.update(dt) then
        end
    end
    if no_enemies and level_gates_open_when_no_enemies[current_level] then
        current_level = current_level + 1
        GS.push(core.states.loading)
        return
    end

    for _,obj in pairs(game.projectiles) do
        obj:update(dt)
    end
    for zz, obj in pairs(game.enemy_ids_to_delete)do
        game.world:remove(obj)

        game.enemies[obj.id] = nil
        game.enemy_ids_to_delete[zz] = nil
    end

    game.player.update(dt)
end
function ctx:draw()
    local W, H = love.graphics.getWidth(), love.graphics.getHeight()
    -- draw previous screen
    game.camera:attach()
    local x,y = game.camera:position()
    game.map:draw(x,y,love.graphics.getWidth()/2, love.graphics.getHeight()/2)
    --  if DEBUG.hax then
        --DEBUG.bump_debug.draw(game.world)
      --end



    for _,enemy in pairs(game.enemies) do
        enemy.draw()
    end
    game.player.draw()
for _,obj in pairs(game.projectiles) do
        obj:draw()
    end
    for v, obj in pairs(game.objects) do
        draw_object(obj)
    end
    local x,y = game.camera:worldCoords(love.mouse.getPosition())
    love.graphics.line(game.player.x+game.player.height/2,game.player.y+game.player.height/2,x,y)
          drawBlocks()

    game.camera:detach()

      love.graphics.print(love.timer.getFPS(), 400, 20 )
      love.graphics.print(game.player.health, 400, 30 )

end
function ctx:leave()
    love.mouse.setGrabbed(false)
    print('leaving')
end
return ctx
