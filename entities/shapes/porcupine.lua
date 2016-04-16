local porcupine = {}
porcupine.images = {}
porcupine.images.down =love.graphics.newImage('entities/porcupine/porcupine_walk_0_Sheet.png')
porcupine.images.downright =love.graphics.newImage('entities/porcupine/porcupine_walk_1_Sheet.png')
porcupine.images.right =love.graphics.newImage('entities/porcupine/porcupine_walk_2_Sheet.png')
porcupine.images.upright =love.graphics.newImage('entities/porcupine/porcupine_walk_3_Sheet.png')
porcupine.images.up =love.graphics.newImage('entities/porcupine/porcupine_walk_4_Sheet.png')
porcupine.images.upleft =love.graphics.newImage('entities/porcupine/porcupine_walk_5_Sheet.png')
porcupine.images.left =love.graphics.newImage('entities/porcupine/porcupine_walk_6_Sheet.png')
porcupine.images.downleft =love.graphics.newImage('entities/porcupine/porcupine_walk_7_Sheet.png')
porcupine.images.current = porcupine.images.right
porcupine.animations = {}
porcupine.grids = {}
porcupine.speed = 100
porcupine.grids.walk = core.anim8.newGrid(porcupine.images.current:getWidth()/8, 96, porcupine.images.current:getWidth(), porcupine.images.current:getHeight())
porcupine.animations.walk = core.anim8.newAnimation(porcupine.grids.walk('1-8',1), 0.1)
porcupine.animations.current = porcupine.animations.walk
porcupine.images_B = {}
porcupine.A = function()
		game.player.locked_update = porcupine.updateA
		game.player.locked_draw = porcupine.drawA
		porcupine.timeout = 1
end
porcupine.B = function()
		game.player.locked_update = porcupine.updateB
		game.player.locked_draw = porcupine.drawB
		porcupine.timeout = 0.5
end
function porcupine.update(dt)
  porcupine.animations.current:update(dt)
end
function porcupine.draw()
	porcupine.animations.current:draw(porcupine.images.current,game.player.col.x-32,game.player.col.y-32)
end
function porcupine.updateA(dt)
	porcupine.timeout = porcupine.timeout-dt
	if porcupine.timeout < 0 then
		game.player.locked_update = nil
		game.player.locked_draw = nil
	end
end
function porcupine.drawA()
	porcupine.animations.current:draw(porcupine.images.current,game.player.col.x-32,game.player.col.y-32)

end
function porcupine.updateB(dt)
	porcupine.timeout = porcupine.timeout-dt
	if love.mouse.isDown(2) then
		porcupine.animations.current:update(dt)
	else
	if porcupine.timeout < 0 then
		game.player.locked_update = nil
		game.player.locked_draw = nil
	end
	end

end
function porcupine.drawB()

end
return porcupine