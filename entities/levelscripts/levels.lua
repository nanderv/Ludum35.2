local error = false
function get_level(filename)
	if filename == "assets/maps/bestmap.lua" then
		return require 'entities.levelscripts.1'
	end
	return {func=function()
	if not error then
		print("This level has no levelscript, help!!!" .. filename)
	end
	error = true
end}
end