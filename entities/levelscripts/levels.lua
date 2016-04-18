function get_level(filename)
	if filename == "assets/maps/bestmap.lua" then
		return require "entity.levelscripts.1"
	end
	return function()
end
end