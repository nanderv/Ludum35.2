		local function armadillo_move(item, other)

		if other.isExit then
			
			
			if not to_load then
				current_level = current_level + 1
				GS.push(core.states.loading)
				to_load = true
				return
			end
			
			
		end
		 if other.isPorcupine or other.isCatWater or (other.isGate and not game.hasKey) then

		 	return "slide"
		 end
			return "cross"
		
	end

	local function regularmove(item, other)
		if other.isHeart then
			game.player.max_health = game.player.max_health + 1
			game.player.health = game.player.max_health
			game.objects_to_del[#game.objects_to_del+1] = other
			return "slide"
		end
		if other.isHealth then
			game.player.health = game.player.health+1
			game.player.max_health = math.max(game.player.health,game.player.max_health )
			game.objects_to_del[#game.objects_to_del+1] = other

		end

		if other.isTarget then
			return "slide"
		end
		if other.isExit then
			
			
			if not to_load then
				current_level = current_level + 1
				GS.push(core.states.loading)
				to_load = true
				return
			end
			
			
		end
		 if other.isEnemy then
		 	return "slide"
		 end
		 if other.isWall or other.isCatWater or (other.isGate and not game.hasKey) or other.isEnemy then
		 	
		 	return "slide"
		 end
		 return "cross"
	end
return function ()

local player = {}
player.image = love.graphics.newImage( "assets/ugly_sprite.png")
player.x = game.startX
player.y = game.startY
player.offx = 4
player.offy = 0
player.width = 20
player.height = 20
player.health = 40000
player.offcx = 4
player.offcy = 4

player.max_health = 4
player.invisible = false
player.invincibility = 0.5
	function player.update_player(dt,handle_mouse,is_armadillo_move)
		local sto_arma =false
		local dx = 0
		local dy = 0
		 if core.gamepad == nil then
			if  love.keyboard.isDown(CONTROLS.UP) then
			 	dy = dy  - dt*player.shape.speed
			end
			if  love.keyboard.isDown(CONTROLS.DOWN) then
				dy = dy + dt*player.shape.speed
			end
			if  love.keyboard.isDown(CONTROLS.RIGHT) then
				dx = dx + dt*player.shape.speed
			end
			if  love.keyboard.isDown(CONTROLS.LEFT) then
				dx = dx  - dt*player.shape.speed
			end
			game.player.dx = dx
			game.player.dy = dy
			if handle_mouse then
				if love.mouse.isDown(1) then
				    local x,y = game.camera:worldCoords(love.mouse.getPosition())
				    local hyp = math.sqrt((x-game.player.x)*(x-game.player.x)+ (y-game.player.y)*(y-game.player.y))

					player.shape.A((x-game.player.x)/hyp,(y-game.player.y)/hyp)
					return

				end
				if love.mouse.isDown(2) and not game.player.lockoutB then

					if not  player.shape.B() then
						return
					end
				end
			-- porcupine
			if love.keyboard.isDown(CONTROLS.ONE) then
				player.shape =  player.shapes[1]
				game.player.offx = 4
				game.player.offy = 0
				game.player.width = 20

				love.window.setIcon(core.images[1])
				game.player.height = 20
				game.world:update(player,game.player.x,game.player.y,game.player.width,game.player.height)
			end
			-- armadillo 
		if love.keyboard.isDown(CONTROLS.TWO) and game.shape_count  >= 2 then
				player.shape =  player.shapes[2]
				game.player.offx = -6
				game.player.offy = -2
				game.player.width = 16
				game.player.height = 16
				love.window.setIcon(core.images[2])
				game.world:update(player,game.player.x,game.player.y,game.player.width,game.player.height)
				
			end	
			-- cat
			if love.keyboard.isDown(CONTROLS.FOUR)  and game.shape_count  >= 4 then

				game.player.offx = -8
				game.player.offy = -10
				game.player.width = 12
				game.player.height = 12
				love.window.setIcon(core.images[3])
				player.shape =  player.shapes[3]
				game.world:update(player,game.player.x,game.player.y,game.player.width,game.player.height)
				
			end
			-- turtle
			if love.keyboard.isDown(CONTROLS.THREE)  and game.shape_count  >= 3 then
				game.player.offx = -3
				game.player.offy = -6
				game.player.width = 22
				game.player.height = 22
				love.window.setIcon(core.images[4])
				player.shape = player.shapes[4]
				game.world:update(player,game.player.x,game.player.y,game.player.width,game.player.height)

			end
			end
			if is_armadillo_move and ( not love.mouse.isDown(2) or  game.player.lockoutB ) then
					sto_arma = true
			else
					sto_arma = false
			end


		else
		end


		if dx > 0 then
			-- right
				player.orientation="right"

			if dy > 0 then
				-- top right
				player.orientation="downright"

			elseif dy < 0 then
				-- bottom right
				player.orientation="upright"
			end
		elseif dx < 0 then
			-- left
				player.orientation="left"
			if dy > 0 then
				-- top left
				player.orientation="downleft"
			end
			if dy < 0 then
				player.orientation="upleft"
				-- bottom left
			end
		else
			if dy > 0 then
				-- down	
				player.orientation="down"
			end
			if dy < 0 then
				-- up
				player.orientation="up"
			end
		end
		if dx ==  0 and dy == 0 then
				game.player.shape.images.current = game.player.shape.images_idle[player.orientation]
				game.player.idle = true
		else
				game.player.shape.images.current = game.player.shape.images[player.orientation]
				game.player.idle = false
	
		end


	--porcupine.images.down =love.graphics.newImage('entities/porcupine/porcupine_walk_0-Sheet.png')
	--porcupine.images.downright =love.graphics.newImage('entities/porcupine/porcupine_walk_1-Sheet.png')
	--porcupine.images.right =love.graphics.newImage('entities/porcupine/porcupine_walk_2-Sheet.png')
	--porcupine.images.upright =love.graphics.newImage('entities/porcupine/porcupine_walk_3-Sheet.png')
	--porcupine.images.up =love.
		if not is_armadillo_move then
			game.player.col.x , game.player.col.y, cols, len =game.world:move(game.player,game.player.col.x+dx,game.player.col.y+dy,regularmove)

			player.invisible=false
		else
			player.invisible=true
			 if sto_arma then
				local  cols, len =game.world:queryRect(game.player.col.x,game.player.col.y,game.player.col.width,game.player.col.height)
				 	if len == 1 then
					player.locked_draw = nil
		 			player.locked_update = nil
				 	end 
			end

			game.player.col.x , game.player.col.y, cols, len =game.world:move(game.player,game.player.col.x+dx,game.player.col.y+dy,armadillo_move)
			
		end
		player.shape.update(dt)
	end

player.shapes = {}
player.shapes[1]  = require 'entities.shapes.porcupine'
player.shapes[2]  = require 'entities.shapes.armadillo'
player.shapes[3]  = require 'entities.shapes.cat'
player.shapes[4]  = require 'entities.shapes.turtle'
player.isPlayer = true
player.shape =  player.shapes[1]
player.locked_update = nil
player.locked_draw = nil
player.orientation= "left"
player.hitbox = {}
player.speed = 80
function player.load()
	

	game.player.col = game.world:add(game.player, game.player.x+player.offcx, game.player.y+player.offcy, game.player.width, game.player.height) 
end
function player.draw(a )
	
	if player.locked_draw  and not a then
		player.locked_draw()
		return
	end

	
	player.shape.draw()

end
function player.update(dt)
	player.invincibility = player.invincibility - dt

	player.x = player.col.x
	player.y = player.col.y
		 game.camera:lookAt(math.floor(game.player.col.x),math.floor(game.player.col.y))

	if player.locked_update then
		player.locked_update(dt)
		return
	end
	player.update_player(dt,true)
end
return player

end
