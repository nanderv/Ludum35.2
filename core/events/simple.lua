local simple = {}
function simple.interval(funky, per)
	local ddt = 0
	return function(dt)
		ddt = ddt + dt
		if ddt > per then
			ddt = ddt - per
			print(funky())
		end
	end
end

return simple