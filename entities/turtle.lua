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

turtle.images.current = turtle.images.right
turtle.animations = {}
turtle.grids = {}
turtle.speed = 50
turtle.grids.walk = core.anim8.newGrid(turtle.images.current:getWidth()/8, 96, turtle.images.current:getWidth(), turtle.images.current:getHeight())
turtle.animations.walk = core.anim8.newAnimation(turtle.grids.walk('1-8',1), 0.06)
turtle.grids.walk = core.anim8.newGrid(turtle.images_A.down:getWidth()/8, 96, turtle.images_A.down:getWidth(), turtle.images_A.down:getHeight())
turtle.animations.A = core.anim8.newAnimation(turtle.grids.A('1-8',1), 0.06)
turtle.animations.current = turtle.animations.walk


turtle.A = function(dx,dy) --niet echt gecheckt, is volgens mij wel goed, maar weet niet zeker

		game.player.locked_update = turtle.updateA
		game.player.locked_draw = turtle.drawA
		turtle.timeout = 0.3
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

end

turtle.B = function() --niet helemaal gecheckt, wel wat spul aangepast. de pause moet er in blijven voor de lunge(zelfde principe, anders teveel movement)
	if 	game.player.shape.attack_B_pause and game.player.shape.attack_B_pause > 0 then
		return true
	end
	
		game.player.locked_update = turtle.updateB
		game.player.locked_draw = turtle.drawB
		turtle.timeout = 0.3
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

	 		game.player.invincibility = 2 --waarom dit?
		
end	