local function regularmove(item, other)
		 if other.isPorcupine then
		 	return "cross"
		 end
		 if other.isWall or other.isCatWater or other== game.player or other.isEnemy then
		 	return "slide"
		 end
		 return "cross"
end





-- Library setup
Grid = require ("lib.jumper.jumper.grid") -- The grid class
Pathfinder = require ("lib.jumper.jumper.pathfinder") -- The pathfinder lass
collisionGrid = Grid(game.abstractmap)
require 'core.connected_components'
ccmap = connected_components(game.abstractmap, 0)
walkable = 0 -- which nodes are walkable?
pathFinder = Pathfinder(collisionGrid, 'JPS', walkable)
function math.round(n, deci) deci = 10^(deci or 0) return math.floor(n*deci+.5)/deci end
--template
function getNewEnemy(x,y,patrolpoints)
	local enemy = {}
	enemy.x = x
	enemy.y = y
	enemy.height = 40
	enemy.width = 30
	enemy.aggroRange = 300
	enemy.attackRange = 35
	enemy.aggro = false
	enemy.speed = 80
	enemy.patrolindex = 1
	enemy.isEnemy=true
	enemy.patrol = patrolpoints
	enemy.path = nil
	enemy.dx = 0
	enemy.dy = 0
	enemy.attframe = 0
	enemy.attbool = false
	enemy.health = 3
	enemy.isEnemy = true
    enemy.countdown = 0

	--animations
	enemy.imageIdle = love.graphics.newImage("entities/enemy/scorpion_0.png")
	local g1 = core.anim8.newGrid(96, 96, enemy.imageIdle:getWidth(), enemy.imageIdle:getHeight())
    enemy.animationIdle = core.anim8.newAnimation(g1('1-1',1), 0.1)
    enemy.imageAttack = love.graphics.newImage("entities/enemy/scorpion_attack_0_Sheet.png")
	local g2 = core.anim8.newGrid(96, 96, enemy.imageAttack:getWidth(), enemy.imageAttack:getHeight())
    enemy.animationAttack = core.anim8.newAnimation(g2('1-5',1), 0.2) 
    enemy.imageWalk = love.graphics.newImage("entities/enemy/scorpion_move_0_Sheet.png")
	local g3 = core.anim8.newGrid(96, 96, enemy.imageWalk:getWidth(), enemy.imageWalk:getHeight())
    enemy.animationWalk = core.anim8.newAnimation(g3('1-8',1), 0.1) 

    --initially idle
    enemy.currentanimation = enemy.animationIdle
    enemy.currentimage = enemy.imageIdle
    enemy.currentanimationToLive = -1


    enemy.col = game.world:add(enemy,enemy.x+32,enemy.y+30,enemy.width,enemy.height)
	enemy.update = function(dt) 


 local items, length = game.world:querySegment(enemy.x,enemy.y,game.player.x,game.player.y)
    for k,v in pairs( items ) do
    	if v.isWall or v.isCatWater then
    		break
    	end
    	if v == game.player then
    		enemy.aggro = 10
    	end
    end

		if enemy.countdown >= 0 then
			enemy.countdown = enemy.countdown - dt
		end
		if enemy.prev_health ~= enemy.health then
			core.sounds.enemy_hit()
			enemy.countdown = 0.3
		end
		enemy.prev_health = enemy.health
		local rawdist = math.sqrt((math.abs(game.player.col.x-enemy.col.x)^2)+(math.abs(game.player.col.y-enemy.col.y)^2))
		-- ai en shit
		local dest = {}
		if(enemy.attbool and enemy.attframe>0)then
			--ATTACK
			if(rawdist<enemy.attackRange)then
			    game.player.shape.damage(1,s, enemy)
			end
			enemy.attframe = enemy.attframe-dt
			if(enemy.attframe<0)then
				enemy.currentanimation = enemy.animationIdle
				enemy.currentimage = enemy.imageIdle
				enemy.currentanimationToLive = 0.2
			end
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
						enemy.currentanimationToLive = 0.3
						enemy.currentanimation = enemy.animationAttack
						enemy.currentimage = enemy.imageAttack
						enemy.attbool = true
						enemy.attframe = 0.7
						if(not enemy.aggro)then
							enemy.aggro =true
						end
						return true
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
					
					local oldx = enemy.x
					local oldy = enemy.y
					enemy.col.x,enemy.col.y = game.world:move(enemy,enemy.col.x+enemy.dx,enemy.col.y+enemy.dy,regularmove)	
					if oldx == enemy.x and oldy == enemy.y then

						if(#enemy.patrol>0) then
							enemy.patrolindex = (enemy.patrolindex+1)%(#enemy.patrol)
							dest.x = enemy.patrol[enemy.patrolindex+1].x
							dest.y = enemy.patrol[enemy.patrolindex+1].y
						end
					end
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
					local oldx = enemy.x
					local oldy = enemy.y
					enemy.col.x,enemy.col.y = game.world:move(enemy,enemy.col.x+enemy.dx,enemy.col.y+enemy.dy,regularmove)	
					if oldx == enemy.x and oldy == enemy.y then

						if(#enemy.patrol>0) then
							enemy.patrolindex = (enemy.patrolindex+1)%(#enemy.patrol)
							dest.x = enemy.patrol[enemy.patrolindex+1].x
							dest.y = enemy.patrol[enemy.patrolindex+1].y
						end
					end
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
		if enemy.countdown > 0 then
			love.graphics.setColor(255,255,255,128)
			end

		if(enemy.currentanimation == enemy.animationAttack)then
			--print("hank")
		end

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
				love.graphics.setColor(255,255,255,255)

	end
	return enemy
end