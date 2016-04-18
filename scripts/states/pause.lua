local pause = GS.new()

-- Enter pause screen
function pause:enter(from)
    self.from = from -- record previous state
    core.music.pause()
    if self.from == core.states.main then love.mouse.setGrabbed(false) end
    print("Game Paused")
end
-- Leave pause screen
function pause:leave(from)
    core.music.resume()
    if self.from == core.states.main then love.mouse.setGrabbed(true) end
    print("Game Resuming")
end

-- Draw pause screen
function pause:draw()
    local W, H = love.graphics.getWidth(), love.graphics.getHeight()
    -- draw previous screen
    self.from:draw()
    -- overlay with pause message
    love.graphics.setColor(0,0,0, 100)
    love.graphics.rectangle('fill', 0,0, W,H)
    love.graphics.setColor(255,255,255)

    love.graphics.printf('GAME PAUSED', 0, H/2, W, 'center')
end

return pause
