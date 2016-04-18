local function regularmove(item, other)
		 if other.isPorcupine then
		 	return "cross"
		 end
		 if other.isWall or other.isCatWater then
		 	return "slide"
		 end
		 return "cross"
end
local function found_shot(item)
	if item.isPorcupine then
		return false
	end
	return true
end
require 'entities.enemy'
--items, length = game.world:querysegment(x1,y1,x2,y2)
--template
-- patrol points = { (x,y)}
-- if no patrol give empty list
function getNewArcher(x,y,patrolpoints)
	local enemy = {}
	enemy.x = x
	enemy.y = y
	enemy.height = 40
	enemy.width = 30
	enemy.aggroRange = 300
	enemy.attackRange = 180
	enemy.aggro = false
	enemy.speed = 60
	enemy.patrolindex = 1
	enemy.isEnemy=true
	enemy.patrol = patrolpoints
	enemy.path = nil
	enemy.dx = 0
	enemy.dy = 0
	enemy.angle = 0
	enemy.aimx = 0
	enemy.aimy = 0
	enemy.health = 2
	enemy.isEnemy = true
	enemy.shootbool = false

	--animations
	enemy.imageIdle = love.graphics.newImage("entities/archer/scorpion_1.png")
	local g1 = core.anim8.newGrid(96, 96, enemy.imageIdle:getWidth(), enemy.imageIdle:getHeight())
    enemy.animationIdle = core.anim8.newAnimation(g1('1-1',1), 0.1)
    enemy.imageAttack = love.graphics.newImage("entities/archer/scorpion_attack_1_Sheet.png")
	local g2 = core.anim8.newGrid(96, 96, enemy.imageAttack:getWidth(), enemy.imageAttack:getHeight())
    enemy.animationAttack = core.anim8.newAnimation(g2('1-7',1), 0.5/7) 
    enemy.imageWalk = love.graphics.newImage("entities/archer/scorpion_move_1_Sheet.png")
	local g3 = core.anim8.newGrid(96, 96, enemy.imageWalk:getWidth(), enemy.imageWalk:getHeight())
    enemy.animationWalk = core.anim8.newAnimation(g3('1-8',1), 0.1) 

    --initially idle
    enemy.currentanimation = enemy.animationIdle
    enemy.currentimage = enemy.imageIdle
    enemy.currentanimationToLive = -1

    enemy.col = game.world:add(enemy,enemy.x+32,enemy.y+30,enemy.width,enemy.height)
	enemy.update = function(dt) 
		-- ai en shit
		local dest = {}
		if(enemy.shootbool and enemy.currentanimationToLive < 0)then
			--FIRE!!!!
			new_quill(enemy.x+0.5*enemy.width,enemy.y+0.5*enemy.height, enemy.aimx,enemy.aimy, true)
			enemy.shootbool = false
			enemy.currentanimation = enemy.animationIdle
			enemy.currentimage = enemy.imageIdle
			enemy.currentanimationToLive = 1
		elseif (enemy.currentanimationToLive == -1) then
			enemy.y = enemy.col.y
			enemy.x = enemy.col.x
			--denken
			-- eerst goal bepalen!
			local gx, gy = math.floor(.5+game.player.col.x/32),math.floor(.5+game.player.col.y/32) --prolly just player pos
			local tx, ty = math.floor(0.5+enemy.x/32),math.floor(.5+enemy.y/32) --prolly just player pos
			if tx < 1 then
				tx = 1
			end
			if ty < 1 then
				ty = 1
			end
			if gx < 1 then
				gx = 1
			end
			if gy < 1 then
				gy = 1
			end
			-- precheck to avoid pathfinding when possible
			local rawdist = math.sqrt((math.abs(game.player.col.x-enemy.col.x)^2)+(math.abs(game.player.col.y-enemy.col.y)^2))
			if rawdist > 100000 then
				return true
			end
			if(enemy.aggro or rawdist<=enemy.aggroRange) then
				-- find dat path
				local path, length = nil,nil
				if not game.player.invisible then
				path,length = pathFinder:getPath(tx,ty,gx,gy)
					if path == nil then
					 	path, length = pathFinder:getPath(tx,ty,gx+1,gy+1)
					end
				end
				if path == nil then
					path = enemy.path 
					if enemy.path == nil then
						enemy.currentanimation:update(dt)
						return false
					end
				else
					enemy.path = path
				end
				local len = #path

				if((math.abs(gx-tx) < 3 or math.abs(gy-ty)<3) or enemy.aggro) then
					if(rawdist < enemy.attackRange) then 
						-- aanvallen!
						local x1,y1,x2,y2 = enemy.x+0.5*enemy.width, enemy.y+0.5*enemy.height, game.player.col.x+0.5*game.player.width, game.player.col.y+0.5*game.player.height
						local items, length = game.world:querySegment(x1,y1,x2,y2,found_shot)
						if(items[1]==game.player or items[2] == game.player) then
							--aanvallen want player in los

							enemy.currentanimationToLive = 0.5
							enemy.currentanimation = enemy.animationAttack
							enemy.currentimage = enemy.imageAttack
							local hyp = math.sqrt((enemy.x-game.player.x)*(enemy.x-game.player.x)+ (enemy.y-game.player.y)*(enemy.y-game.player.y))
							local x,y = (-enemy.x+game.player.x)/hyp, (-enemy.y+game.player.y)/hyp
							enemy.aimx = x
							enemy.aimy = y
							enemy.shootbool = true

							if(not enemy.aggro)then
								enemy.aggro =true
							end
							return true
						end
					end
			
					--else move in direction of player to get in los
					if not path._nodes[2] then
						enemy.currentanimation:update(dt)
						return true
					end
					dest.x =   path._nodes[2]._x 
					dest.y =   path._nodes[2]._y 
					dest.x = dest.x * 32
					dest.y = dest.y * 32
					enemy.dx = 0
					enemy.dy = 0
					if(dest.x < enemy.x)then
						enemy.dx = enemy.dx - dt*enemy.speed
					if(dest.y < enemy.y)then
						enemy.dy = enemy.dy - dt*enemy.speed
					elseif(dest.y>enemy.y)then
						enemy.dy = enemy.dy + dt*enemy.speed
					end
					elseif(dest.x>enemy.x)then
						enemy.dx = enemy.dx + dt*enemy.speed
						if(dest.y < enemy.y)then
							enemy.dy = enemy.dy - dt*enemy.speed
						elseif(dest.y>enemy.y)then
							enemy.dy = enemy.dy + dt*enemy.speed
						end
					else
						if(dest.y < enemy.y)then
							enemy.dy = enemy.dy - dt*enemy.speed
						elseif(dest.y>enemy.y)then
							enemy.dy = enemy.dy + dt*enemy.speed
						end
					end
					if enemy.x + enemy.dx < dest.x and enemy.dx < 0 then
							enemydx = dest.x - enemy.x
					end
					if enemy.x + enemy.dx > dest.x and enemy.dx > 0 then
							enemy.dx = dest.x - enemy.x
					end
					if enemy.y + enemy.dy < dest.y and enemy.dy < 0 then
							enemy.dy = dest.y - enemy.y
					end
					if enemy.y + enemy.dy > dest.y and enemy.dy > 0 then
							enemy.dy = dest.y - enemy.y
					end
					enemy.currentanimation = enemy.animationWalk
					enemy.currentimage = enemy.imageWalk
					enemy.col.x,enemy.col.y = game.world:move(enemy,enemy.col.x+enemy.dx,enemy.col.y+enemy.dy,regularmove)
					-- now aggroed
					if(not enemy.aggro)then
						enemy.aggro =true
					end
				end
			else
				-- patrol area if patrol specified
				if(#enemy.patrol>0) then
					if(math.abs(enemy.x - enemy.patrol[enemy.patrolindex+1].x)<32 and math.abs(enemy.y - enemy.patrol[enemy.patrolindex+1].y)<32)then
						enemy.patrolindex = (enemy.patrolindex+1)%(#enemy.patrol)
					end
					dest.x = enemy.patrol[enemy.patrolindex+1].x
					dest.y = enemy.patrol[enemy.patrolindex+1].y
				end
				enemy.dy = 0
				enemy.dx=0
				if(dest.x < enemy.x)then
					enemy.dx = enemy.dx - dt*enemy.speed
					if(dest.y < enemy.y)then
						enemy.dy = enemy.dy - dt*enemy.speed
					elseif(dest.y>enemy.y)then
						enemy.dy = enemy.dy + dt*enemy.speed
					end
					elseif(dest.x>enemy.x)then
						enemy.dx = enemy.dx + dt*enemy.speed
						if(dest.y < enemy.y)then
							enemy.dy = enemy.dy - dt*enemy.speed
						elseif(dest.y>enemy.y)then
							enemy.dy = enemy.dy + dt*enemy.speed
						end
					else
						if(dest.y < enemy.y)then
							enemy.dy = enemy.dy - dt*enemy.speed
						elseif(dest.y>enemy.y)then
							enemy.dy = enemy.dy + dt*enemy.speed
						end
					end
					if enemy.x + enemy.dx < dest.x and enemy.dx < 0 then
							enemydx = dest.x - enemy.x
					end
					if enemy.x + enemy.dx > dest.x and enemy.dx > 0 then
							enemy.dx = dest.x - enemy.x
					end
					if enemy.y + enemy.dy < dest.y and enemy.dy < 0 then
							enemy.dy = dest.y - enemy.y
					end
					if enemy.y + enemy.dy > dest.y and enemy.dy > 0 then
							enemy.dy = dest.y - enemy.y
					end
					enemy.col.x,enemy.col.y = game.world:move(enemy,enemy.col.x+enemy.dx,enemy.col.y+enemy.dy,regularmove)	
					enemy.currentanimation = enemy.animationWalk
					enemy.currentimage = enemy.imageWalk	
			end 
		end--anders nog bezig, dus mag niks
		--animation updates
		if(enemy.currentanimationToLive == -1 or enemy.currentanimationToLive > 0) then
			if enemy.currentanimationToLive > 0 then
						enemy.currentanimationToLive = enemy.currentanimationToLive - dt 
					end
			enemy.currentanimation:update(dt)
		else
			enemy.currentanimation = enemy.animationWalk
			enemy.currentimage = enemy.imageWalk
			enemy.currentanimationToLive = -1
			enemy.currentanimation:update(dt)
		end
		return true
	end


	enemy.draw = function()
		local ding
		if(enemy.dy == 0) then 
			ding = math.abs(enemy.dx)/0.001
		else
			ding = math.abs(enemy.dx)/math.abs(enemy.dy)
		end
		if(ding > 4)then
			if(enemy.dx>0)then
				enemy.currentanimation:draw(enemy.currentimage,enemy.col.x+15,enemy.col.y+22,(270*math.pi/180),1,1,48,48)
			else
				enemy.currentanimation:draw(enemy.currentimage,enemy.col.x+15,enemy.col.y+22,(90*math.pi/180),1,1,48,48)
			end
		elseif(ding<0.25)then
			if(enemy.dy>0)then
				enemy.currentanimation:draw(enemy.currentimage,enemy.col.x-33,enemy.col.y-30)
			else
				enemy.currentanimation:draw(enemy.currentimage,enemy.col.x+15,enemy.col.y+22,(180*math.pi/180),1,1,48,48)
			end
		else
			if(enemy.dx>0)then
				if(enemy.dy>0)then
					enemy.currentanimation:draw(enemy.currentimage,enemy.col.x+15,enemy.col.y+22,(315*math.pi/180),1,1,48,48)
				else
					enemy.currentanimation:draw(enemy.currentimage,enemy.col.x+15,enemy.col.y+22,(225*math.pi/180),1,1,48,48)
				end
			else
				if(enemy.dy>0)then
					enemy.currentanimation:draw(enemy.currentimage,enemy.col.x+15,enemy.col.y+22,(45*math.pi/180),1,1,48,48)
				else
					enemy.currentanimation:draw(enemy.currentimage,enemy.col.x+15,enemy.col.y+22,(125*math.pi/180),1,1,48,48)
				end
			end
		end
	end
	return enemy
end