local pause = GS.new()

pause.options = {'CONTROLS', 'RETURN'}
pause.selections = {
    CONTROLS={'settingsmenu', GS.push},
    RETURN={'', GS.pop}
}
pause.selected = 1

-- Enter pause screen
function pause:enter(from)
    self.from = from -- record previous state
    core.music.script.pause()
    if self.from == core.states.main then love.mouse.setGrabbed(false) end
    print("Game Paused")
end
-- Leave pause screen
function pause:leave(from)
    core.music.script.pause()
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

    love.graphics.printf('GAME PAUSED', 0, H/2 - 60, W, 'center')
    for i, text in ipairs(pause.options) do
         if i == self.selected then
              love.graphics.setColor(44,44,44, 50)
              love.graphics.rectangle('fill', W/4 - 20, H/2 - 45 + i*20, W/2 + 40, 20)
              love.graphics.setColor(255,255,255)
         end
         love.graphics.printf(text, 0, H/2 - 40 + i*20, W, 'center')
    end
end

function pause:keypressed(key)
    if key == 'up' and self.selected > 1 then
        self.selected = self.selected - 1
    elseif key == 'down' and self.selected < #self.options then
        self.selected = self.selected + 1
    elseif key == 'return' then
        local sel = self.selections[self.options[self.selected]]
        sel[2](core.states[sel[1]])
    end
end

return pause
