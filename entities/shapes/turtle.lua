local function turtle_col_handler(self, other)
	if other.isEnemy and self.shape.lungecooldown == false then
		other.health = other.health - 3
		other.aggro = 5
		if other.health <= 0 then
			game.enemy_ids_to_delete[#game.enemy_ids_to_delete+1] = other
		end	
		self.shape.lungecooldown = true
	end
	return "slide"
end

require 'entities.quill'
local turtle = {}

turtle.images = {}
turtle.images.down =love.graphics.newImage('entities/turtle/turtle_walking_0_Sheet.png')
turtle.images.downright =love.graphics.newImage('entities/turtle/turtle_walking_0_Sheet.png')
turtle.images.right =love.graphics.newImage('entities/turtle/turtle_walking_0_Sheet.png')
turtle.images.upright =love.graphics.newImage('entities/turtle/turtle_walking_0_Sheet.png')
turtle.images.up =love.graphics.newImage('entities/turtle/turtle_walking_0_Sheet.png')
turtle.images.upleft =love.graphics.newImage('entities/turtle/turtle_walking_0_Sheet.png')
turtle.images.left =love.graphics.newImage('entities/turtle/turtle_walking_0_Sheet.png')
turtle.images.downleft =love.graphics.newImage('entities/turtle/turtle_walking_0_Sheet.png')

turtle.images_A = {}
turtle.images_A.down =love.graphics.newImage('entities/turtle/turtle_biting_0_Sheet.png')
turtle.images_A.downright =love.graphics.newImage('entities/turtle/turtle_biting_0_Sheet.png')
turtle.images_A.right =love.graphics.newImage('entities/turtle/turtle_biting_0_Sheet.png')
turtle.images_A.upright =love.graphics.newImage('entities/turtle/turtle_biting_0_Sheet.png')
turtle.images_A.up =love.graphics.newImage('entities/turtle/turtle_biting_0_Sheet.png')
turtle.images_A.upleft =love.graphics.newImage('entities/turtle/turtle_biting_0_Sheet.png')
turtle.images_A.left =love.graphics.newImage('entities/turtle/turtle_biting_0_Sheet.png')
turtle.images_A.downleft =love.graphics.newImage('entities/turtle/turtle_biting_0_Sheet.png')

turtle.images_B = turtle.images_A

turtle.images.current = turtle.images.right
turtle.animations = {}
turtle.grids = {}
turtle.speed = 50
turtle.grids.walk = core.anim8.newGrid(turtle.images.current:getWidth()/8, 96, turtle.images.current:getWidth(), turtle.images.current:getHeight())
turtle.animations.walk = core.anim8.newAnimation(turtle.grids.walk('1-8',1), 0.06)
turtle.grids.A = core.anim8.newGrid(turtle.images_A.down:getWidth()/8, 96, turtle.images_A.down:getWidth(), turtle.images_A.down:getHeight())
turtle.animations.A = core.anim8.newAnimation(turtle.grids.A('1-8',1), 0.06)
turtle.animations.B = turtle.animations.A
turtle.animations.current = turtle.animations.walk

turtle.images_idle = {}
turtle.images_idle.down =love.graphics.newImage('entities/turtle/turtle_walking_0_Sheet.png')

turtle.A = function(dx,dy)

		game.player.locked_update = turtle.updateA
		game.player.locked_draw = turtle.drawA
		turtle.timeout = 0.5
		local ddx = 0
		local ddy = 0
		if game.player.orientation == "up" then
			ddy = 1
		end
		if game.player.orientation == "down" then
			ddy = -1
		end
		if game.player.orientation == "right" then
			ddx = 1
		end
		if game.player.orientation == "left" then
			ddx = -1
		end
		local a = 1/math.sqrt(2)
		if game.player.orientation == "upleft" then
			ddx = -a
			ddy = -a
		end
		if game.player.orientation == "upright" then
			ddx = a
			ddy = -a
		end
		if game.player.orientation == "downleft" then
			ddx = -a
			ddy = a
		end
		if game.player.orientation == "downright" then
			ddx = a
			ddy = a
		end
		game.player.ddx = ddx
		game.player.ddy = ddy

		local others, others_len = game.world:queryPoint(game.player.x+ddx*32,game.player.y+ddy*32,function (obj) return obj.isEnemy end)
		print(others)
		if others_len > 0 then
			others[1].health = others[1].health - 2
			others[1].aggro = 5
			if others[1].health <= 0 then
				game.enemy_ids_to_delete[#game.enemy_ids_to_delete+1] = others[1]
			end	
		end


end

turtle.B = function()
	if 	game.player.shape.attack_B_pause and game.player.shape.attack_B_pause > 0 then
		return true
	end
		turtle.lungecooldown = false
		game.player.locked_update = turtle.updateB
		game.player.locked_draw = turtle.drawB
		turtle.timeout = 0.15
		local ddx = 0
		local ddy = 0
		if game.player.orientation == "up" then
			ddy = -1
		end
		if game.player.orientation == "down" then
			ddy = 1
		end
		if game.player.orientation == "right" then
			ddx = 1
		end
		if game.player.orientation == "left" then
			ddx = -1
		end
		local a = 1/math.sqrt(2)
		if game.player.orientation == "upleft" then
			ddx = -a
			ddy = -a
		end
		if game.player.orientation == "upright" then
			ddx = a
			ddy = -a
		end
		if game.player.orientation == "downleft" then
			ddx = -a
			ddy = a
		end
		if game.player.orientation == "downright" then
			ddx = a
			ddy = a
		end
		game.player.shape.attack_B_pause=2
		game.player.ddx = ddx
		game.player.ddy = ddy
		turtle.animations.current = turtle.animations.A:clone()
		turtle.images.current = turtle.images_A
end

function turtle.damage(hit, status) -- zou goed moeten zijn, zie comment in functie !
			if game.player.invincibility > 0 then
				return
			end

			-- Modifier
			hit = hit * 0.5
			hit = math.floor(hit)
			if hit <1 then
				hit = 1
			end

			-- Apply condition
			if status and status.draw then
				game.player.locked_draw = status.draw
				game.player.locked_update = status.update
			end

			-- Apply damage
			game.player.health = game.player.health - hit

			-- Check death
			if game.player.health <= 0 then
				print("DEAD")
				GS.push(core.states.death )
				return
			end

	 		game.player.invincibility = 2
end	

function turtle.update(dt)
  turtle.animations.current:update(dt)
  if game.player.shape.attack_B_pause ~= nil then
  	game.player.shape.attack_B_pause = game.player.shape.attack_B_pause - dt
  end
end

function turtle.draw()
	turtle.images.current=turtle.images.left
	local angle = 0
	if game.player.orientation == "up" then
		angle=180*math.pi/180
	end
	if game.player.orientation == "left" then
		angle=90*math.pi/180
	end
	if game.player.orientation == "right" then
		angle=-90*math.pi/180
	end

	if game.player.orientation == "upright" then
		angle=-135*math.pi/180
	end
	if game.player.orientation == "downright" then
		angle=-45*math.pi/180
	end
	if game.player.orientation == "upleft" then
		angle=135*math.pi/180
	end
	if game.player.orientation == "downleft" then
		angle=45*math.pi/180
	end

	turtle.animations.current:draw(turtle.images.current,game.player.col.x+14,game.player.col.y+17,angle,1,1,48,48)
end

function turtle.updateA(dt)
	turtle.timeout = turtle.timeout-dt
	if turtle.timeout < 0 then
		game.player.locked_update = nil
		game.player.locked_draw = nil
	end
	turtle.animations.current:update(dt)
end

function turtle.drawA()
	turtle.images.current=turtle.images_A.left
	local angle = 0
	if game.player.orientation == "up" then
		angle=180*math.pi/180
	end
	if game.player.orientation == "left" then
		angle=90*math.pi/180
	end
	if game.player.orientation == "right" then
		angle=-90*math.pi/180
	end

	if game.player.orientation == "upright" then
		angle=-135*math.pi/180
	end
	if game.player.orientation == "downright" then
		angle=-45*math.pi/180
	end
	if game.player.orientation == "upleft" then
		angle=135*math.pi/180
	end
	if game.player.orientation == "downleft" then
		angle=45*math.pi/180
	end

	turtle.animations.current:draw(turtle.images.current,game.player.col.x+14,game.player.col.y+17,angle,1,1,48,48)
end

function turtle.updateB(dt)
	turtle.timeout = turtle.timeout-dt
	game.player.col.x , game.player.col.y, cols, len = game.world:move(game.player,game.player.col.x+game.player.ddx*dt*450,game.player.y+game.player.ddy*dt*450,turtle_col_handler)

	if love.mouse.isDown(2) then
		turtle.animations.current:update(dt)
	end
	if turtle.timeout < 0 then
		game.player.locked_update = nil
		game.player.locked_draw = nil
		turtle.animations.current = turtle.animations.walk
		game.player.shape.attack_B_pause=1
	
	end
end

function turtle.drawB()
	turtle.images.current=turtle.images.left
	local angle = 0
	if game.player.orientation == "up" then
		angle=180*math.pi/180
	end
	if game.player.orientation == "left" then
		angle=90*math.pi/180
	end
	if game.player.orientation == "right" then
		angle=-90*math.pi/180
	end

	if game.player.orientation == "upright" then
		angle=-135*math.pi/180
	end
	if game.player.orientation == "downright" then
		angle=-45*math.pi/180
	end
	if game.player.orientation == "upleft" then
		angle=135*math.pi/180
	end
	if game.player.orientation == "downleft" then
		angle=45*math.pi/180
	end

	turtle.images.current = turtle.images_B.left
	turtle.animations.current:draw(turtle.images.current,game.player.col.x+14,game.player.col.y+17,angle,1,1,48,48)	

end
return turtle