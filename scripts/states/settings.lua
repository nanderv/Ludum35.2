local controls = GS.new()

function controls:enter(from)
    self.from = from
    self.selected = 1
    self.selecting = ''

    if love.filesystem.isFile('settings.conf') then
         local res = {}
         for s in love.filesystem.lines('settings.conf') do 
             res[#res + 1] = s
         end
         local settings = dictify(res)
         for i, name in ipairs(CONTROLS.ALL) do
             if settings[name] ~= nil then CONTROLS[name] = settings[name] end
         end
    end
end

function dictify(list)
     local val = {}
     for i, v in ipairs(list) do print(v) end
     while #list > 0 do
          val[list[#list - 1]] = list[#list]
          list[#list] = nil
          list[#list] = nil
     end
     return val
end

function controls:draw()
    local W, H = love.graphics.getWidth(), love.graphics.getHeight()
    
    love.graphics.setColor(0,0,0, 100)
    love.graphics.rectangle('fill', 0,0, W,H)
    love.graphics.setColor(255,255,255)
    love.graphics.printf('Controls', 0, H/2+60, W, 'center')
    love.graphics.printf('press ESC to exit', 0, H/2+80, W, 'center')
    
    for i, name in ipairs(CONTROLS.ALL) do
        love.graphics.printf(name .. " : ", 0, H/2 + 100 + i*20, W / 2, 'right')
        if name == self.selecting then
            love.graphics.setColor(128, 128, 128)
        elseif i == self.selected then
            love.graphics.setColor(255, 128, 255)
        end
        love.graphics.printf(CONTROLS[name], W / 2, H/2 + 100 + i*20, W, 'left')
        love.graphics.setColor(255,255,255)
    end
end

function controls:keypressed(key)
    if key == "escape" then
        GS.pop()
    elseif self.selecting then
        local passes = true
        for i, name in ipairs(CONTROLS.ALL) do
            if CONTROLS[name] ~= nil and CONTROLS[name] == key and not name == self.selecting then
                passes = false
            end
        end
        if passes then
            CONTROLS[self.selecting] = key
        end
        self.selecting = nil
        local file = ""
        for i, name in ipairs(CONTROLS.ALL) do
            file = file .. name .. "\n"
            file = file .. CONTROLS[name] .. "\n"
        end
        love.filesystem.write('settings.conf', file)
    elseif key == "return" then
        self.selecting = CONTROLS.ALL[self.selected]
    elseif key == "up" then
        if self.selected > 1 then
            self.selected = self.selected - 1
        end
    elseif key == "down" then
        if self.selected < #CONTROLS.ALL then
            self.selected = self.selected + 1
        end
    end
end

return controls

