local states = {}
states.menu = require 'scripts.states.menu'
states.main = require 'scripts.states.main'
states.pause = require 'scripts.states.pause'
states.loading = require 'scripts.states.loading'
states.death = require 'scripts.states.death'
states.victory = require 'scripts.states.victory'
states.settingsmenu = require 'scripts.states.settings'
return states
