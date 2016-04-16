local function regularmove(item, other)
	 if other.isPorcupine then
	 	return "cross"
	 end
	 if other.isWall then
	 	return "slide"
	 end
end
local player = {}
player.image = love.graphics.newImage( "assets/ugly_sprite.png")
player.x = 100
player.y = 200
player.width = 32
player.height = 32
player.shape = require 'entities.shapes.porcupine'
player.locked_update = nil
player.locked_draw = nil
player.hitbox = {}
player.speed = 80
function player.load()
	game.player.col = game.world:add(game.player, game.player.x, game.player.x, game.player.width, game.player.height) 
end
function player.draw()
	if player.locked_draw then
		player.locked_draw()
		return
	end
	love.graphics.draw(player.image,game.player.col.x+2, game.player.col.y+2, 0,28/32)
	player.shape.draw()
end
function player.update(dt)
	if player.locked_update then
		player.locked_update(dt)
		return
	end
	local dx = 0
	local dy = 0
	 game.camera:lookAt(math.floor(game.player.col.x),math.floor(game.player.col.y))
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
	if love.mouse.isDown(1) then
		player.shape.A()
	end
	if love.mouse.isDown(2) then
		player.shape.B()
	end

	if dx > 0 then
		-- right
			game.player.shape.images.current = game.player.shape.images.right

		if dy > 0 then
			-- top right
			game.player.shape.images.current = game.player.shape.images.downright

		elseif dy < 0 then
			-- bottom right
			game.player.shape.images.current = game.player.shape.images.upright
		end
	elseif dx < 0 then
		-- left
			game.player.shape.images.current = game.player.shape.images.left
		if dy > 0 then
			-- top left
			game.player.shape.images.current = game.player.shape.images.downleft
		end
		if dy < 0 then
			game.player.shape.images.current = game.player.shape.images.upleft
			-- bottom left
		end
	else
		if dy > 0 then
			-- down	
			game.player.shape.images.current = game.player.shape.images.down

		end
		if dy < 0 then
			-- up
			game.player.shape.images.current = game.player.shape.images.up
		end
	end
--porcupine.images.down =love.graphics.newImage('entities/porcupine/porcupine_walk_0-Sheet.png')
--porcupine.images.downright =love.graphics.newImage('entities/porcupine/porcupine_walk_1-Sheet.png')
--porcupine.images.right =love.graphics.newImage('entities/porcupine/porcupine_walk_2-Sheet.png')
--porcupine.images.upright =love.graphics.newImage('entities/porcupine/porcupine_walk_3-Sheet.png')
--porcupine.images.up =love.

	game.player.col.x , game.player.col.y, cols, len =game.world:move(game.player,game.player.col.x+dx,game.player.col.y+dy,regularmove)
	player.shape.update(dt)
end
return player
