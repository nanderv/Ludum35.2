laserbolt = love.graphics.newImage("entities/archer/laser_ball_4.png")
quill_image = love.graphics.newImage("entities/porcupine/quill.png")
local function ignore_col(self,other)
	return "cross"
end

local function update(quill,dt)
		quill.timeout = quill.timeout - dt
		if not  game.world:hasItem(quill) then

			game.projectiles[quill.id] = nil
			return
		end
		if quill.timeout < -10 then
			quill.timeout = 0
				game.projectiles[quill.id] = nil
				game.world:remove(quill)

				return
		end
		if quill.delete then
			game.projectiles[quill.id] = nil
			game.world:remove(quill)
			return
		end
		
		local objs = game.world:querySegment(quill.x,quill.y,quill.x+quill.dx*dt*250, quill.y+quill.dy*dt*250)
		local self = quill
		for k,other in pairs(objs) do
				
		if other.isCatWater then

				break
		end
		if other.isTarget then

			game.hasKey = true
			game.map.layers['gate_closed'].visible = false
			game.map.layers['gate_open'].visible  = true
				game.projectiles[quill.id] = nil
				game.world:remove(quill)
				return
		end
	if other.isQuill then
		game.projectiles[quill.id] = nil
		game.world:remove(quill)
		other.delete = true
		return 
			end
	if other.isWall then
		game.projectiles[quill.id] = nil
		game.world:remove(quill)

		return
	end
	
	
	if self.deadly then
		print("HOI")
		if other == game.player then
	     local s = core.status_effects.knockback(0.5,game.player,self.dx*100, self.dy*100)

			game.player.shape.damage(1,s)
				self.delete = true
		end
	else
		print("IA")
		if other.isEnemy then

			if other.health then
				other.health = other.health - 1
				other.aggro = 5
				print("A>")
				print(other.health)
					if other.health <= 0 then
						game.enemy_ids_to_delete[#game.enemy_ids_to_delete+1] = other
					end	
				else
					game.enemy_ids_to_delete[#game.enemy_ids_to_delete+1] = other
				end
						self.delete = true

		end


		end
	end
		

		game.world:update(quill, quill.x+quill.dx*dt*250, quill.y+quill.dy*dt*250)
		quill.x,quill.y =  quill.x+quill.dx*dt*250, quill.y+quill.dy*dt*250



	end
local function draw(quill)
	love.graphics.rectangle("fill",quill.x,quill.y,4,4)
	if(quill.deadly)then
		love.graphics.draw(laserbolt,quill.x,quill.y)
	else
	
		if quill.rotation == nil then
			local x,y = 0,0
			if core.gamepad == nil then
				x,y = game.camera:worldCoords(love.mouse.getPosition())
			    x,y = x-game.player.x,y-game.player.y
			end
			local tanfix = 0
			if x < 0 then
				tanfix = math.pi
			end
			quill.rotation = math.atan(y/x)-0.5*math.pi+tanfix
		end
		love.graphics.draw(quill_image, quill.x, quill.y, quill.rotation)
		--love.graphics.rectangle("fill",quill.x,quill.y,4,4)
	
		love.graphics.rectangle("fill",quill.x,quill.y,1,1)
	end
end
function new_quill(xx,yy,dx, dy,deadly)
	local quill={isQuill=true, x=xx,y=yy, timeout = 0,qz = #game.projectiles+1}
	
	quill = game.world:add(quill, xx,yy,4,4)
	
	quill.deadly = deadly

	quill.dx = dx
	quill.dy = dy
	quill.isWall=false
	quill.draw = draw
	quill.update = update
	game.projectiles[#game.projectiles+1] = quill
	for k,v in pairs(quill) do
		print(k,v)
	end
	quill.id = #game.projectiles
	
end