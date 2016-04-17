local script = {}
function script.load()
	core.music.create_layer("assets/music/Track_1_V0-1.mp3", {"test1","music"} )
	script.running=false
	core.music.script = script
	script.t = 0
end
function script.update(dt)
	if not core.music.script.running then
		core.music.script.running=true
		core.music.play()
	end
	core.music.script.t = (core.music.script.t + dt )% 2
end
return script