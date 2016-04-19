local error = false
function get_level(filename)
	if filename == "assets/maps/1.lua" then
		return require 'entities.levelscripts.1'
	end
	if filename == "assets/maps/2.lua" then
		return require 'entities.levelscripts.2'
	end
	if filename == "assets/maps/4.lua" then
		return require 'entities.levelscripts.4'
	end

	if filename == "assets/maps/Map_Boss_1.lua" then
		return require 'entities.levelscripts.boss'
	end

	return {func=function()
	if not error then
		print("This level has no levelscript, help!!!" .. filename)
	end
	error = true
end}
end