local sounds = {}

sounds.options = {
    'enemy_hit', 
    'explosion', 
    'gate_open', 
    'jump', 
    'laser', 
    'pickup', 
    'player_death',
    'player_hit',
    'quill'
}

function sounds.playSound(name)
    local v = sounds[name]
end

function sounds.load()
    sounds.sources = {}
    
    sounds.playing = {}
    for i, name in ipairs(sounds.options) do
        sounds.sources[name] = love.audio.newSource('assets/sfx/'..name..'.ogg', 'static')
    end
end

local mt = {}

function mt:__index(name)
    if rawget(self, 'sources') == nil then self.load() end
    if self.sources[name] == nil then return end
    sounds.sources[name]:clone():play()
    return function() end
end

setmetatable(sounds, mt)

return sounds
