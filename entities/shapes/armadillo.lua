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
armadillo.images_idle.down =love.graphics.newImage('entities/armadillo/armadillo_walking_0_Sheet.png')
armadillo.images_idle.downright =love.graphics.newImage('entities/armadillo/armadillo_walking_1_Sheet.png')
armadillo.images_idle.right =love.graphics.newImage('entities/armadillo/armadillo_walking_2_Sheet.png')
armadillo.images_idle.upright =love.graphics.newImage('entities/armadillo/armadillo_walking_3_Sheet.png')
armadillo.images_idle.up =love.graphics.newImage('entities/armadillo/armadillo_walking_4_Sheet.png')
armadillo.images_idle.upleft =love.graphics.newImage('entities/armadillo/armadillo_walking_5_Sheet.png')
armadillo.images_idle.left =love.graphics.newImage('entities/armadillo/armadillo_walking_6_Sheet.png')
armadillo.images_idle.downleft =love.graphics.newImage('entities/armadillo/armadillo_walking_7_Sheet.png')

armadillo.images_A = {}
armadillo.images_A.down =love.graphics.newImage('entities/armadillo/armadillo_attack_A_0_Sheet.png')
armadillo.images_A.up =love.graphics.newImage('entities/armadillo/armadillo_attack_A_0_Sheet.png')
armadillo.images_A.left =love.graphics.newImage('entities/armadillo/armadillo_attack_A_0_Sheet.png')
armadillo.images_A.right =love.graphics.newImage('entities/armadillo/armadillo_attack_A_0_Sheet.png')
armadillo.images_A.upleft =love.graphics.newImage('entities/armadillo/armadillo_attack_A_0_Sheet.png')
armadillo.images_A.upright =love.graphics.newImage('entities/armadillo/armadillo_attack_A_0_Sheet.png')
armadillo.images_A.downleft =love.graphics.newImage('entities/armadillo/armadillo_attack_A_0_Sheet.png')
armadillo.images_A.downright =love.graphics.newImage('entities/armadillo/armadillo_attack_A_0_Sheet.png')


armadillo.grids.B = core.anim8.newGrid(armadillo.images.current:getWidth()/8, 96, armadillo.images.current:getWidth(), armadillo.images.current:getHeight())
armadillo.animations.B = core.anim8.newAnimation(armadillo.grids.B('1-8',1), 0.02,  'pauseAtEnd')
armadillo.grids.A = core.anim8.newGrid(armadillo.images_A.down:getWidth()/8, 96, armadillo.images_A.down:getWidth(), armadillo.images_A.down:getHeight())
armadillo.animations.A = core.anim8.newAnimation(armadillo.grids.A('1-8',1), 0.06)

armadillo.A = function(dx,dy)
		game.player.locked_update = armadillo.updateA
		game.player.locked_draw = armadillo.drawA
		armadillo.i = 0
	armadillo.secret_speed =armadillo.speed


end
function armadillo.damage(hit, status, enemy)
	if game.player.health <= 0 then
		return
	end
	if game.player.invincibility > 0 then
		return
	end

	if hit > 9999 and game.player.health > 1 then
		hit = game.player.health -1
	    local s = core.status_effects.stun(0.1,game.player)
    	 game.player.locked_update = s.update
    	 game.player.locked_draw = s.draw
	else

	-- Apply condition
	if status and status.draw then
		game.player.locked_draw = status.draw
		game.player.locked_update = status.update
	end
	if game.player.locked_update == armadillo.updateA then
		print("HIT STUN")
	    local s = core.status_effects.stun(1,game.player)
    	 game.player.locked_update = s.update
    	 game.player.locked_draw = s.draw
		hit = hit - 3
		if hit < 1 then
			hit = 1
		end

	end


	-- Modifier
	hit = hit * 0.5
	hit = math.floor(hit)
	if hit <1 then
		hit = 1
	end
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
armadillo.B = function()
		game.player.locked_update = armadillo.updateB
		game.player.locked_draw = armadillo.drawB
end
function armadillo.update(dt)
  armadillo.animations.current:update(dt)
end
function armadillo.draw()
	armadillo.animations.current:draw(armadillo.images.current,game.player.col.x-34+game.player.offx,game.player.col.y-37+game.player.offy)

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
	local tanfix = 0
	if x < 0 then
		tanfix = math.pi
	end
	game.player.angle = math.atan(y/x)-0.5*math.pi+tanfix
	game.player.col.x,game.player.col.y =game.world:move(game.player,x*armadillo.secret_speed+(game.player.x),game.player.y+y*armadillo.secret_speed )
	armadillo.secret_speed = armadillo.secret_speed + 60*dt
	if armadillo.secret_speed > 300 then
		armadillo.secret_speed = 300
	end
	armadillo.animations.current:update(dt*armadillo.secret_speed/100)
end
function armadillo.drawA()
	
	armadillo.images.current=armadillo.images_A.left
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
	armadillo.animations.current:draw(armadillo.images.current,game.player.col.x+game.player.offx+14,game.player.col.y+10+game.player.offy,game.player.angle,1,1,48,96-53)

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