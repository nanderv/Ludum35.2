require 'entities.quill'
local armadillo = {}

armadillo.images = {}
armadillo.images.down =love.graphics.newImage('entities/armadillo/armadillo_walking_0_Sheet.png')
armadillo.images.downright =love.graphics.newImage('entities/armadillo/armadillo_walking_1_Sheet.png')
armadillo.images.right =love.graphics.newImage('entities/armadillo/armadillo_walking_2_Sheet.png')
armadillo.images.upright =love.graphics.newImage('entities/armadillo/armadillo_walking_3_Sheet.png')
armadillo.images.up =love.graphics.newImage('entities/armadillo/armadillo_walking_3_Sheet.png')
armadillo.images.upleft =love.graphics.newImage('entities/armadillo/armadillo_walking_5_Sheet.png')
armadillo.images.left =love.graphics.newImage('entities/armadillo/armadillo_walking_6_Sheet.png')
armadillo.images.downleft =love.graphics.newImage('entities/armadillo/armadillo_walking_7_Sheet.png')
armadillo.images.current = armadillo.images.right
armadillo.animations = {}
armadillo.grids = {}
armadillo.speed = 100
armadillo.grids.walk = core.anim8.newGrid(armadillo.images.current:getWidth()/8, 96, armadillo.images.current:getWidth(), armadillo.images.current:getHeight())
armadillo.animations.walk = core.anim8.newAnimation(armadillo.grids.walk('1-8',1), 0.06)
armadillo.animations.current = armadillo.animations.walk

armadillo.images_B = {}
armadillo.images_B.down =love.graphics.newImage('entities/porcupine/porcupine_attack_b_0_Sheet.png')
armadillo.images_B.downright =love.graphics.newImage('entities/porcupine/porcupine_attack_b_0_Sheet.png')
armadillo.images_B.right =love.graphics.newImage('entities/porcupine/porcupine_attack_b_2_Sheet.png')
armadillo.images_B.upright =love.graphics.newImage('entities/porcupine/porcupine_attack_b_2_Sheet.png')
armadillo.images_B.up =love.graphics.newImage('entities/porcupine/porcupine_attack_b_4.png')
armadillo.images_B.upleft =love.graphics.newImage('entities/porcupine/porcupine_attack_b_4.png')
armadillo.images_B.left =love.graphics.newImage('entities/porcupine/porcupine_attack_b_6_Sheet.png')
armadillo.images_B.downleft =love.graphics.newImage('entities/porcupine/porcupine_attack_b_6_Sheet.png')


armadillo.images_idle = {}
armadillo.images_idle.down =love.graphics.newImage('entities/porcupine/porcupine_idle_0_Sheet.png')
armadillo.images_idle.downright =love.graphics.newImage('entities/porcupine/porcupine_idle_1_Sheet.png')
armadillo.images_idle.right =love.graphics.newImage('entities/porcupine/porcupine_idle_2_Sheet.png')
armadillo.images_idle.upright =love.graphics.newImage('entities/porcupine/porcupine_idle_3_Sheet.png')
armadillo.images_idle.up =love.graphics.newImage('entities/porcupine/porcupine_idle_4_Sheet.png')
armadillo.images_idle.upleft =love.graphics.newImage('entities/porcupine/porcupine_idle_5_Sheet.png')
armadillo.images_idle.left =love.graphics.newImage('entities/porcupine/porcupine_idle_6_Sheet.png')
armadillo.images_idle.downleft =love.graphics.newImage('entities/porcupine/porcupine_idle_7_Sheet.png')


armadillo.grids.B = core.anim8.newGrid(armadillo.images.current:getWidth()/8, 96, armadillo.images.current:getWidth(), armadillo.images.current:getHeight())
armadillo.animations.B = core.anim8.newAnimation(armadillo.grids.B('1-8',1), 0.02,  'pauseAtEnd')

armadillo.A = function(dx,dy)
		game.player.locked_update = armadillo.updateA
		game.player.locked_draw = armadillo.drawA
		armadillo.timeout = 1

		new_quill(game.player.x,game.player.y,dx,dy)
end
armadillo.B = function()
		game.player.locked_update = armadillo.updateB
		game.player.locked_draw = armadillo.drawB
		armadillo.timeout = 0.5
		armadillo.animations.current = armadillo.animations.B:clone()
		armadillo.images.current = armadillo.images_B[game.player.orientation]
end
function armadillo.update(dt)
  armadillo.animations.current:update(dt)
end
function armadillo.draw()
	armadillo.animations.current:draw(armadillo.images.current,game.player.col.x-34,game.player.col.y-37)

end
function armadillo.updateA(dt)
	armadillo.timeout = armadillo.timeout-dt
	if armadillo.timeout < 0 then
		game.player.locked_update = nil
		game.player.locked_draw = nil
	end
end
function armadillo.drawA()
	armadillo.animations.current:draw(armadillo.images.current,game.player.col.x-37,game.player.col.y-37)

end
function armadillo.updateB(dt)
	armadillo.timeout = armadillo.timeout-dt
	if love.mouse.isDown(2) then
		armadillo.animations.current:update(dt)
	else
	if armadillo.timeout < 0 then
		game.player.locked_update = nil
		game.player.locked_draw = nil
		armadillo.animations.current = armadillo.animations.walk

	end
	end

end
function armadillo.drawB()
	armadillo.animations.current:draw(armadillo.images.current,game.player.col.x-37,game.player.col.y-37)
	

end
return armadillo