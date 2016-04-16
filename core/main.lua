
local core = {}

core.events = require 'core.events'
core.states = {}
core.states.main = GS.new()

core.music = require 'core.music.music'
core.synth = require 'core.music.synth'


return core