local ctx = GS.new()
local options = {
"LOL U DIED",
"You have perished",
"You're dead. Again.",
"Nope.",
"The maidens question your virality...",
"Squik",
"Mr. T. the Famous Muricalligator did not give a shit. \n He lend it.",
"Goodnight"
}

function ctx:enter(from)
   self.choice = love.math.random(1, #options)    
   self.from = from -- record previous state
   if true_mode then
            current_level = 1
        end
end
function ctx:update(dt)

end
function ctx:draw()
     local W, H = love.graphics.getWidth(), love.graphics.getHeight()
    -- draw previous screen
    self.from:draw()
    -- overlay with pause message
    love.graphics.setColor(0,0,0, 100)
    love.graphics.rectangle('fill', 0,0, W,H)
    love.graphics.setColor(255,255,255)

    love.graphics.printf(options[self.choice], 0, H/2, W, 'center')
end


function ctx:keypressed(key)
	if key =="return" then
		GS.pop()
        GS.push(core.states.loading)
	end
end

return ctx
