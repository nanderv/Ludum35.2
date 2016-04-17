return function ()
	local function regularmove(item, other)
	 if other.isPorcupine then
	 	return "cross"
	 end
	 if other.isWall then
	 	return "slide"
	 end
	 return "slide"
end
local player = {}
player.image = love.graphics.newImage( "assets/ugly_sprite.png")
player.x = 100
player.y = 200
player.width = 28
player.height = 28
player.shape = require 'entities.shapes.armadillo'
player.locked_update = nil
player.locked_draw = nil
player.orientation= "left"
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

	
	love.graphics.rectangle("fill",player.col.x,player.col.y,player.col.width,player.col.height)
	player.shape.draw()

end
function player.update(dt)
	player.x = player.col.x
	player.y = player.col.y
	if player.locked_update then
		player.locked_update(dt)
		return
	end
	local dx = 0
	local dy = 0
	 game.camera:lookAt(math.floor(game.player.col.x),math.floor(game.player.col.y))
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
		if love.mouse.isDown(1) then
		    local x,y = game.camera:worldCoords(love.mouse.getPosition())
		    local hyp = math.sqrt((x-game.player.x)*(x-game.player.x)+ (y-game.player.y)*(y-game.player.y))

			player.shape.A((x-game.player.x)/hyp,(y-game.player.y)/hyp)
			return
		end

	else
		print(core.gamepad)
	end
	if love.mouse.isDown(2) then
		player.shape.B()
		return
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
	else
			game.player.shape.images.current = game.player.shape.images[player.orientation]
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

end