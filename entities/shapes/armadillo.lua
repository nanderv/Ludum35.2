require 'entities.quill'
local armadillo = {}

armadillo.images = {}
armadillo.images.down =love.graphics.newImage('entities/armadillo/armadillo_walking_0_Sheet.png')
armadillo.images.downright =love.graphics.newImage('entities/armadillo/armadillo_walking_1_Sheet.png')
armadillo.images.right =love.graphics.newImage('entities/armadillo/armadillo_walking_2_Sheet.png')
armadillo.images.upright =love.graphics.newImage('entities/armadillo/armadillo_walking_3_Sheet.png')
armadillo.images.up =love.graphics.newImage('entities/armadillo/armadillo_walking_4_Sheet.png')
armadillo.images.upleft =love.graphics.newImage('entities/armadillo/armadillo_walking_5_Sheet.png')
armadillo.images.left =love.graphics.newImage('entities/armadillo/armadillo_walking_6_Sheet.png')
armadillo.images.downleft =love.graphics.newImage('entities/armadillo/armadillo_walking_7_Sheet.png')
armadillo.images.current = armadillo.images.right
armadillo.animations = {}
armadillo.grids = {}
armadillo.speed = 100
armadillo.secret_speed =100
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
		armadillo.i = 0
	armadillo.secret_speed =armadillo.speed


end
armadillo.B = function()
		game.player.locked_update = armadillo.updateB
		game.player.locked_draw = armadillo.drawB
end
function armadillo.update(dt)
  armadillo.animations.current:update(dt)
end
function armadillo.draw()
	armadillo.animations.current:draw(armadillo.images.current,game.player.col.x-34,game.player.col.y-37)

end
function armadillo.updateA(dt)
	local x,y = 0,0

	if core.gamepad == nil then

			 x,y = game.camera:worldCoords(love.mouse.getPosition())
		    local hyp = math.sqrt((x-game.player.x)*(x-game.player.x)+ (y-game.player.y)*(y-game.player.y))
		    x,y = (x-game.player.x)/hyp*dt,(y-game.player.y)/hyp*dt
    		if not love.mouse.isDown(1) then
	    			game.player.locked_update = nil
					game.player.locked_draw = nil
			return
		end
	end

	game.player.col.x,game.player.col.y =game.world:move(game.player,x*armadillo.secret_speed+(game.player.x),game.player.y+y*armadillo.secret_speed )
	armadillo.secret_speed = armadillo.secret_speed + 60*dt
	if armadillo.secret_speed > 300 then
		armadillo.secret_speed = 300
	end
	armadillo.i  = armadillo.i+dt
end
function armadillo.drawA()
	armadillo.animations.current:draw(armadillo.images.current,game.player.col.x+14,game.player.col.y+17,armadillo.i*armadillo.secret_speed/10,1,1,48,48)

end
function armadillo.updateB(dt)
	game.player.update_player(dt,false,true)
	
end
function armadillo.drawB()
	love.graphics.setColor( 255,255,255,128)
	armadillo.draw()
	love.graphics.setColor( 255,255,255,255)
end
return armadillo