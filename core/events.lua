local events ={}
events.list={}
events.simple = require 'core.events.simple'
function events.add(func)
	core.events.list[#core.events.list+1] = func
end

function events.exec(dt)
	for a, ev in ipairs(core.events.list) do
		to_del = ev(dt)
		if to_del then
			core.events.list[a] = nil
		end
	end
end
return events