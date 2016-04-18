local menu = GS.new()

function menu:enter(from)
    self.from = from -- record previous state
end

function menu:draw()
    local W, H = love.graphics.getWidth(), love.graphics.getHeight()
    -- draw previous screen
    -- overlay with pause message
    love.graphics.setColor(0,0,0, 100)
    love.graphics.rectangle('fill', 0,0, W,H)
    love.graphics.setColor(255,255,255)
    love.graphics.printf('MENU', 0, H/2+100, W, 'center')
end

function menu:keypressed(key)
	if key =="return" then
		GS.switch(core.states.main)
	elseif key == 'escape' then
                GS.push(core.states.settingsmenu)
        end
end
return menu
