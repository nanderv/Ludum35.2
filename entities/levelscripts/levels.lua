local error = false
function get_level(filename)
	if filename == "assets/maps/bestmap.lua" then
		return require "entity.levelscripts.1"
	end
	return function()
	if not error then
		print("This level has no levelscript, help!!!")
	end
	error = true
end
end