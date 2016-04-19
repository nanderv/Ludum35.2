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
require 'entities.levelscripts.levels'
core.states = require 'scripts.gamestates'
require 'entities.status_effects.events'
require 'entities.tiles'
require 'cutscene.cutscene'
core.sounds = require 'sounds'

core.gamepad = nil

function love.load()
    GS.registerEvents()
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
  

end
function love.gamepadpressed( joystick, button )
    core.gamepad = joystick

end
