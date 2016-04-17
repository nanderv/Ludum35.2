local music = {}
music.layers = {}
function music.create_layer(filename, tags)
	if core.music.layers[#core.music.layers+1] ~=  nil then
	local dat = love.sound.newSoundData(filename)
	core.music.sampleCount = dat:getSampleCount()
	core.music.sampleRate = dat:getSampleRate()
	print(core.music.sampleRate, core.music.sampleCount)
	
	lay:setLooping(true)
	core.music.layers[#core.music.layers+1]=lay
	

	end
	return lay
end
function music.add_layer(filename, tags)
	local dat = love.sound.newSoundData(filename)

	local lay = love.audio.newSource( dat )
	lay:setLooping(true)
	lay:play()
	lay:pause()

	core.music.layers[#core.music.layers+1]=lay
	if #core.music.layers >= 1 then
		lay:seek(core.music.layers[1]:tell("samples"),"samples")
		print(core.music.layers[1]:tell("samples"), lay:tell("samples"))
	end
	for _,lay in pairs(core.music.layers) do
		print (lay:tell())
	end
	lay:pause()
	return lay
end
-- load new music script by crossfading
function music.crossfade(script)
	local old_layers = core.music.layers
	core.music.layers={}
	require (script).load()

	local start = 1
	local t = start
	local function event(_, dt)
		t = t - dt 
		for _,lay in pairs(old_layers) do
			if (t/start) < 0 then
				lay:stop()
			else
				lay:setVolume(t/start)
			end
		end
		for _,lay in pairs(core.music.layers) do

			lay:setVolume((start-t)/start)
		end
		if t < 0 then
			return true
		else
			return false
		end
	end
		event(nil,0)
	core.events.add(event, nil)
end
-- load new music script by fading out this one and fading in another
function music.fadeoutin(script)
	local old_layers = core.music.layers
	core.music.layers={}
	require (script).load()
	core.music.script.running=true
	local start = 1
	local t = start
	local out = true
	local function event(dt)
		t = t - dt 
		if out then
		for _,lay in pairs(old_layers) do
			if (t/start) < 0 then
				lay:stop()
				out = false
				t = start
				core.music.script.running=false
			else
				lay:setVolume(t/start)
			end
		end
		else

		for _,lay in pairs(core.music.layers) do

			lay:setVolume((start-t)/start)
		end
		if t < 0 then
			return true
		else
			return false
		end
	end
end
		for _,lay in pairs(core.music.layers) do
			lay:setVolume(0)
		end
	core.events.add(event, nil)
end
function music.play()
	for _,lay in pairs(core.music.layers) do
		lay:play()
	end
end

function music.pause()
	for _,lay in pairs(core.music.layers) do
		lay:pause()
	end
end
function music.resume()
	for _,lay in pairs(core.music.layers) do
		lay:resume()
	end
end
return music