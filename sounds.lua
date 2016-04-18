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
        sounds.sources[name] = love.audio.newSource('assets/sfx/'..name..'.ogg')
        sounds.playing[name] = {}
    end
end

local mt = {}

function mt:__index(name)
    print('start')
    if rawget(self, 'sources') == nil then self.load() end
    if self.sources[name] == nil then return end
    
    local i = 1
    local started = false
    while not started do
        if self.playing[name][i] == nil then
            self.playing[name][i] = self.sources[name]:clone()
            self.playing[name][i]:play()
            started = true
        elseif not self.playing[name][i]:isPlaying() then
            self.playing[name][i]:play()
            started = true
        end
    end
    print('end')
    return function() end
end

setmetatable(sounds, mt)

return sounds
