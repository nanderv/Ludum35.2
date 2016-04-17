
local function ignore_col(self,other)
	return "cross"
end
local function get_col(self, other)
	self.delete = true
end
local function update(quill,dt)
		quill.timeout = quill.timeout - dt

		
		quill.x, quill.y = game.world:move(item, quill.x+quill.dx*dt, quill.y+quill.dy*dt, get_col)
		if quill.delete then
				print("AA")
				game.projectiles[quill.id] = nil
				game.world:remove(quill)

		end	

	end
local function draw(quill)
	love.graphics.print("*",quill.x,quill.y)
end
function new_quill(xx,yy,dx, dy)
	local quill={isQuill=true,x=xx,y=yy,width=1,height=1}
	print("AA")
	quill =game.world:add(quill, xx,yy,1,1)
	print(quill.x)
	print(quill)
	quill.timeout = 1
	quill.dx = dx
	quill.dy = dy
	quill.draw = draw
	quill.update = update
	game.projectiles[#game.projectiles+1] = quill
		quill.id = #game.projectiles
	
end