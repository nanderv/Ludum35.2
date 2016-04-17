local ctx = GS.new()
function ctx:enter(from)
   self.from = from -- record previous state
    true_mode = true
end
function ctx:update(dt)

end
function ctx:draw()
     local W, H = love.graphics.getWidth(), love.graphics.getHeight()
    -- draw previous screen
    -- overlay with pause message
    love.graphics.setColor(0,0,0, 100)
    love.graphics.rectangle('fill', 0,0, 1200,800)
    love.graphics.setColor(255,255,255)

    love.graphics.printf('LOL U WON', 0, H/2, W, 'center')
end


function ctx:keypressed(key)

	if key =="return" then
        current_level = 2
		GS.switch(core.states.main)
        GS.push(core.states.loading)
	end
end

return ctx