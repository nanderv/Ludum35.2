local menu = GS.new()

menu.OPTIONS = {'PLAY', 'SETTINGS', 'HELP', 'EXIT'}

menu.selected = 1

menu._OPTIONS = {
    PLAY={'main', GS.switch},
    SETTINGS={'settingsmenu', GS.push},
    HELP={'helpmenu', GS.push},
    EXIT={0, love.event.quit}
}

function menu:enter(from)
    self.from = from -- record previous state
end

function menu:update(dt)
    
end
function menu:draw()
    local W, H = love.graphics.getWidth(), love.graphics.getHeight()
    -- draw previous screen
    -- overlay with pause message
    love.graphics.setColor(0,0,0, 100)
    love.graphics.rectangle('fill', 0,0, W,H)
    love.graphics.setColor(255,255,255)
    love.graphics.printf('MENU', 0, H/2-80, W, 'center')
    
    for i, name in ipairs(self.OPTIONS) do
         if i == self.selected then
             love.graphics.setColor(44,44,44, 100)
             love.graphics.rectangle('fill',W/4 - 20, H/2 - 65 + 20*i, W/2 + 40, 20)
             love.graphics.setColor(255,255,255)
         end
         love.graphics.printf(name, 0, H/2 - 60 + 20*i, W, 'center')
    end
end

function menu:keypressed(key)
	if key =="return" and menu._OPTIONS[menu.OPTIONS[self.selected]] ~= nil then
		local selected = menu._OPTIONS[menu.OPTIONS[self.selected]]
		selected[2](core.states[selected[1]])
	elseif (key == CONTROLS.UP or key == 'up') and self.selected > 1 then
		self.selected = self.selected - 1
	elseif (key == CONTROLS.DOWN or key == 'down') and self.selected < #menu.OPTIONS then
		self.selected = self.selected + 1
	end
        
end
return menu
