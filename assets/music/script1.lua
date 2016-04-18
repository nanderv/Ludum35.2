local script = {}

script.source = love.audio.newSource('assets/music/main1_2.ogg')

function script.load()
     script.source:setLooping(true)
     script.source:play()
end

function script.pause()
     if script.source:isPaused() then script.source:play() else script.source:pause() end
end

core.music.script = script

return script
