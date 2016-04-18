require 'entities.quill'
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
porcupine.speed = 80
porcupine.grids.walk = core.anim8.newGrid(porcupine.images.current:getWidth()/8, 96, porcupine.images.current:getWidth(), porcupine.images.current:getHeight())
porcupine.animations.walk = core.anim8.newAnimation(porcupine.grids.walk('1-8',1), 0.06)
porcupine.animations.current = porcupine.animations.walk

porcupine.images_B = {}
porcupine.images_B.down =love.graphics.newImage('entities/porcupine/porcupine_attack_b_0_Sheet.png')
porcupine.images_B.downright =love.graphics.newImage('entities/porcupine/porcupine_attack_b_0_Sheet.png')
porcupine.images_B.right =love.graphics.newImage('entities/porcupine/porcupine_attack_b_2_Sheet.png')
porcupine.images_B.upright =love.graphics.newImage('entities/porcupine/porcupine_attack_b_2_Sheet.png')
porcupine.images_B.up =love.graphics.newImage('entities/porcupine/porcupine_attack_b_4.png')
porcupine.images_B.upleft =love.graphics.newImage('entities/porcupine/porcupine_attack_b_4.png')
porcupine.images_B.left =love.graphics.newImage('entities/porcupine/porcupine_attack_b_6_Sheet.png')
porcupine.images_B.downleft =love.graphics.newImage('entities/porcupine/porcupine_attack_b_6_Sheet.png')


porcupine.images_idle = {}
porcupine.images_idle.down =love.graphics.newImage('entities/porcupine/porcupine_idle_0_Sheet.png')
porcupine.images_idle.downright =love.graphics.newImage('entities/porcupine/porcupine_idle_1_Sheet.png')
porcupine.images_idle.right =love.graphics.newImage('entities/porcupine/porcupine_idle_2_Sheet.png')
porcupine.images_idle.upright =love.graphics.newImage('entities/porcupine/porcupine_idle_3_Sheet.png')
porcupine.images_idle.up =love.graphics.newImage('entities/porcupine/porcupine_idle_4_Sheet.png')
porcupine.images_idle.upleft =love.graphics.newImage('entities/porcupine/porcupine_idle_5_Sheet.png')
porcupine.images_idle.left =love.graphics.newImage('entities/porcupine/porcupine_idle_6_Sheet.png')
porcupine.images_idle.downleft =love.graphics.newImage('entities/porcupine/porcupine_idle_7_Sheet.png')


porcupine.grids.B = core.anim8.newGrid(porcupine.images.current:getWidth()/8, 96, porcupine.images.current:getWidth(), porcupine.images.current:getHeight())
porcupine.animations.B = core.anim8.newAnimation(porcupine.grids.B('1-8',1), 0.02,  'pauseAtEnd')

porcupine.A = function(dx,dy)
		game.player.locked_update = porcupine.updateA
		game.player.locked_draw = porcupine.drawA
		porcupine.timeout = 0.6

		new_quill(game.player.x+game.player.width/2,game.player.y+game.player.height/2,dx,dy,false)
end
porcupine.B = function()
		game.player.locked_update = porcupine.updateB
		game.player.locked_draw = porcupine.drawB
		porcupine.timeout = 0.5
		porcupine.animations.current = porcupine.animations.B:clone()
		porcupine.images.current = porcupine.images_B[game.player.orientation]
end
function porcupine.damage(hit, status, enemy)
		if game.player.invincibility > 0 then
				return
			end

			if hit > 9999 and game.player.health > 1 then
				hit = game.player.health -1
			    local s = core.status_effects.stun(0.1,game.player)
		    	 game.player.locked_update = s.update
		    	 game.player.locked_draw = s.draw
			else

			-- Modifier
			hit = hit * 0.5
			hit = math.floor(hit)
			if hit <1 then
				hit = 1
			end
			if enemy and enemy.health and game.player.locked_update == porcupine.updateB then
				enemy.health = enemy.health - 2*hit
				if enemy.health <= 0 then
					game.enemy_ids_to_delete[#game.enemy_ids_to_delete+1] = enemy
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
		end
	 		game.player.invincibility = 1
		
end	
function porcupine.update(dt)
  porcupine.animations.current:update(dt)
end
function porcupine.draw()
	porcupine.animations.current:draw(porcupine.images.current,game.player.col.x-34-game.player.offx,game.player.col.y-37-game.player.offy)

end
function porcupine.updateA(dt)
	porcupine.timeout = porcupine.timeout-dt
	if porcupine.timeout < 0 then
		game.player.locked_update = nil
		game.player.locked_draw = nil
	end
end
function porcupine.drawA()
	porcupine.animations.current:draw(porcupine.images.current,game.player.col.x-37,game.player.col.y-37)

end
function porcupine.updateB(dt)
	porcupine.timeout = porcupine.timeout-dt
	if love.mouse.isDown(2) then
		porcupine.animations.current:update(dt)
	else
	if porcupine.timeout < 0 then
		game.player.locked_update = nil
		game.player.locked_draw = nil
		porcupine.animations.current = porcupine.animations.walk

	end
	end

end
function porcupine.drawB()
	porcupine.animations.current:draw(porcupine.images.current,game.player.col.x-37,game.player.col.y-37)
	

end
return porcupine