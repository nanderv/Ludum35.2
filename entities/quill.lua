
local function ignore_col(self,other)
	return "cross"
end
local function get_col(self, other)
	if other == game.player then
		return
	end
	print("HOI") 
	game.world:remove(other)
	 game.enemies[other.id] = nil
	self.delete = true
end
local function update(quill,dt)
		quill.timeout = quill.timeout - dt

		
		quill.x, quill.y, a, b = game.world:move(quill, quill.x+quill.dx*dt*300, quill.y+quill.dy*dt*300, get_col)
		if quill.delete then
				game.projectiles[quill.id] = nil
				game.world:remove(quill)

		end	

	end
local function draw(quill)
	love.graphics.print("*",quill.x,quill.y)
end
function new_quill(xx,yy,dx, dy)
	local quill={isQuill=true,x=xx,y=yy,width=1,height=1}
	quill =game.world:add(quill, xx,yy,1,1)

	quill.timeout = 0.5
	quill.dx = dx
	quill.dy = dy
	quill.draw = draw
	quill.update = update
	game.projectiles[#game.projectiles+1] = quill
	quill.id = #game.projectiles
	
end