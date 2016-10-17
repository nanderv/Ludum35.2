
function connected_components(map, zero)
	local 	result = {}
	local counter = 1
	local has_tile = false
	function DFS(x,y)
		if result[x] and result[x][y] then
			return
		end
		if not result[x] then
			result[x] = {}
		end
		if not map[x] or not map[x][y] then
			return
		end
		if map[x][y] ~= zero then

			result[x][y] = -1
			print(x,y,"WALL")
		else
			has_tile = true
			result[x][y] = counter
			print(x, y, counter)
			DFS(x+1,y)
			DFS(x-1,y)
			DFS(x,y+1)
			DFS(x,y-1)
		end
	end


	print(map)
	for x,v in pairs(map) do
		for y,_ in pairs(v) do
			if not result[x] or not result[x][y] then
				has_tile = false
				DFS(x,y)
				if has_tile then
					counter = counter + 1
				end
			end
		end 
	end
	print(counter)
	return result

end