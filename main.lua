-- remove the next line to disable console
require("lib.debug.debug")
game = {}


GS  = require "lib.hump.gamestate"
sti = require 'lib.sti'
-- load main core library
require 'entities.tiles'
core = require 'core.main'
core.anim8 = require 'lib.anim8.anim8'
core.bump = require 'lib.bump.bump'
core.camera = require 'lib.hump.camera'
core.states = require 'scripts.gamestates'
function love.load()
    GS.registerEvents()
    GS.switch(core.states.menu)
end

-- This one will only be used for debugging purposes, love.keyDown is used in most other cases
function love.keypressed(key)
    if GS.current() ~= core.states.menu  and key == 'p' then
    	if  GS.current() ~= core.states.pause then
        	GS.push(core.states.pause)
        else
        	GS.pop()
        end
    end
    if DEBUG and DEBUG.print then
        print(key)
    end
end