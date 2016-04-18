-- remove the next line to disable console
-- require("lib.debug.debug")
game = {}
starting_health = 4

GS  = require "lib.hump.gamestate"
sti = require 'lib.sti'
-- load main core library
core = require 'core.main'
core.anim8 = require 'lib.anim8.anim8'
core.bump = require 'lib.bump.bump'
core.camera = require 'lib.hump.camera'
require 'lib.new_debug'
core.states = require 'scripts.gamestates'
require 'entities.status_effects.events'
require 'entities.tiles'

core.gamepad = nil

function love.load()
    GS.registerEvents()
    print(     #love.joystick.getJoysticks())
    for k,v in pairs(love.joystick.getJoysticks()) do
        love.graphics.print(joystick:getName(), 10, i * 20)
    end
    GS.switch(core.states.menu)
end

-- This one will only be used for debugging purposes, love.keyDown is used in most other cases
function love.keypressed(key)
    core.gamepad = nil
    if GS.current() ~= core.states.menu  and key == CONTROLS.PAUSE then
    	if  GS.current() ~= core.states.pause then
        	GS.push(core.states.pause)
        else
        	GS.pop()
        end
    end
    --if DEBUG and DEBUG.print then
     --   print(key)
    --end
    if key == CONTROLS.RESET  then
                GS.push(core.states.loading)
    end
    if key == "q" then
     local s = core.status_effects.knockback(1,game.player,100,100)
     game.player.locked_update = s.update
     game.player.locked_draw = s.draw
    end
    if key == "1" then
        print(game.player.x,game.player.y)
    end

end
function love.gamepadpressed( joystick, button )
    print("HOI")
    core.gamepad = joystick

end
