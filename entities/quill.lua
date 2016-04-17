laserbolt = love.graphics.newImage("entities/archer/laser_ball_4.png")

local function ignore_col(self,other)
	return "cross"
end
local function get_col(self, other)
	if other.isQuill then
		self.delete = true
		other.delete = true
		return "touch"

	end
	if self.delete then
		return "touch"
	end
	if self.timeout > 0 then
		return "cross"
	end
	if self.deadly then

		if other == game.player then
	     local s = core.status_effects.knockback(1,game.player,self.dx*100, self.dy*100)

			game.player.shape.damage(1,s)
				self.delete = true
		end
	else
		if other == game.player then
			return "cross"
		end
		if other.isEnemy then
			game.enemy_ids_to_delete[#game.enemy_ids_to_delete+1] = other
		end
		self.delete = true
		return "touch"

	end
	return "cross"
end
local function update(quill,dt)
		quill.timeout = quill.timeout - dt
		if not game.world:hasItem(quill) then
			return
		end
		quill.x, quill.y, a, b = game.world:move(quill, quill.x+quill.dx*dt*250, quill.y+quill.dy*dt*250, get_col)

		if quill.delete then

				game.projectiles[quill.id] = nil
				game.world:remove(quill)

		end	
		if quill.timeout < -10 then
				game.projectiles[quill.id] = nil
				game.world:remove(quill)
		end

	end
local function draw(quill)
	if(quill.deadly)then
		love.graphics.draw(laserbolt,quill.x,quill.y)
	else
		love.graphics.print("*",quill.x,quill.y)
		love.graphics.rectangle("fill",quill.x,quill.y,10,10)
	end
end
function new_quill(xx,yy,dx, dy,deadly)
	local quill={isQuill=true,x=xx,y=yy,width=1,height=1}

	quill =game.world:add(quill, xx,yy,1,1)
	quill.deadly = deadly
	quill.timeout = 0.1

	quill.dx = dx
	quill.dy = dy
	quill.isWall=false
	quill.draw = draw
	quill.update = update
	game.projectiles[#game.projectiles+1] = quill
	quill.id = #game.projectiles
	
end