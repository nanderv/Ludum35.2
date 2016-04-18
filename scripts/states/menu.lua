local menu = GS.new()

menu.OPTIONS = {'PLAY', 'SETTINGS'}

menu.selected = 1

menu._OPTIONS = {
    PLAY={'main', GS.switch},
    SETTINGS={'settingsmenu', GS.push}
}

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
    love.graphics.printf('MENU', 0, H/2+80, W, 'center')
    
    for i, name in ipairs(self.OPTIONS) do
         if i == self.selected then
              love.graphics.setColor(255,255,0)
         end
         love.graphics.printf(name, 0, H/2 + 100 + 20*i, W, 'center')
         love.graphics.setColor(255,255,255)
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
