local controls = GS.new()

function controls:enter(from)
    self.from = from
    self.selected = 1
    self.selecting = nil

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
     while #list > 0 do
          val[list[#list - 1]] = list[#list]
          list[#list] = nil
          list[#list] = nil
     end
     return val
end

function controls:draw()
    local W, H = love.graphics.getWidth(), love.graphics.getHeight()
        self.from:draw(true)
    love.graphics.printf('Controls', 0, H/2 - 80, W, 'center')
    love.graphics.printf('press ESC to return', 0, H/2 - 60, W, 'center')
    
    for i, name in ipairs(CONTROLS.ALL) do
        if i == self.selected then
            if self.selecting ~= nil then
                love.graphics.setColor(44,88,44, 100)
            else
                love.graphics.setColor(44,44,44, 100)
            end

            love.graphics.rectangle('fill', (W/4 - 20), H/2 - 45 + i*20, W/2 + 40, 20)
            love.graphics.setColor(255,255,255)
        end
        love.graphics.printf(name .. " : ", 0, H/2 -40 + i*20, W / 2, 'right')
        love.graphics.printf(CONTROLS[name], W / 2, H/2 - 40 + i*20, W, 'left')
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

