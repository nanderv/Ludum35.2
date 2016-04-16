local player = {}
player.image = love.graphics.newImage( "assets/ugly_sprite.png")
player.x = 100
player.y = 100
player.width = 32
player.height = 32
function player.load()
	game.player.col = game.world:add(game.player, game.player.x, game.player.x, game.player.width, game.player.height) 
end
function player.draw()
	love.graphics.draw(player.image,game.player.col.x, game.player.col.y)
end
function player.update(dt)
	local dx = 0
	local dy = 0
	 game.camera:lookAt(game.player.col.x,game.player.col.y)
	if  love.keyboard.isDown('w') then
	 dy = dy  - dt*60
end
	if  love.keyboard.isDown('s') then
		dy = dy + dt*60
	end
	if  love.keyboard.isDown('d') then
		dx = dx + dt*60
	end
	if  love.keyboard.isDown('a') then
		dx = dx  - dt*60
	end

	game.player.col.x , game.player.col.y, cols, len =game.world:move(game.player,game.player.col.x+dx,game.player.col.y+dy)

end
return player
