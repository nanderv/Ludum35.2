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
    self.from:draw(true)

    love.graphics.printf('Congratulations, you have won!!!!', 0, H/2, W, 'center')

        love.graphics.printf('Press enter to restart', 0, H/2+40, W, 'center')

end


function ctx:keypressed(key)

	if key =="return" then
        current_level = 1
		GS.switch(core.states.main)
        GS.push(core.states.loading)
	end
end

return ctx