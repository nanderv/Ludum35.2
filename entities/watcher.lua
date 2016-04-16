
require 'entities.enemy'
--items, length = game.world:querysegment(x1,y1,x2,y2)
--template
-- patrol points = { (x,y)}
-- if no patrol give empty list
-- cone width and length in pixels
function getNewWatcher(patrolpoints, conelength, conewidth)
	local enemy = {}
	enemy.x = 59
	enemy.y = 600
	enemy.height = 32
	enemy.width = 32
	enemy.aggroRange = 100
	enemy.attackRange = 50
	enemy.aggro = false
	enemy.speed = 60
	enemy.patrolindex = 1
	enemy.conelength = conelength
	enemy.patrol = patrolpoints
	enemy.aggrotimer = 500


	enemy.path = nil
	--animations
	enemy.imageIdle = love.graphics.newImage("assets/ugly_sprite.png")
	local g = core.anim8.newGrid(32, 32, enemy.imageIdle:getWidth(), enemy.imageIdle:getHeight())
    enemy.animationIdle = core.anim8.newAnimation(g('1-1',1), 0.1) -- ("frame numbers", "index starting frame", "time per frame", optional end of loop)
    -- do other animations

    --initially idle
    enemy.currentanimation = enemy.animationIdle
    enemy.currentanimationToLive = -1
    enemy.col = game.world:add(enemy,enemy.x,enemy.y,32,32)
	enemy.update = function(dt) 
		-- ai en shit
		local dest = {}


		if (enemy.currentanimationToLive == -1) then
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

			if(enemy.aggro or rawdist<enemy.aggroRange) then

				-- find dat path
				local path, length = pathFinder:getPath(tx,ty,gx,gy)
				if path == nil then
				 	path, length = pathFinder:getPath(tx,ty,gx+1,gy+1)

				end
				if path == nil then
					path = enemy.path 
					if enemy.path == nil then
						return
					end
				else
					enemy.path = path
				end
				local len = #path

				if((math.abs(gx-tx) < 3 or math.abs(gy-ty)<3) or enemy.aggro) then

					if(rawdist < enemy.attackRange) then 
						-- aanvallen!

						local x1,y1,x2,y2 = enemy.x+16, enemy.y+16, game.player.col.x+16, game.player.col.y+16
						local items, length = game.world:querySegment(x1,y1,x2,y2)
						if(items[2] == game.player) then
							--aanvallen want player in los
							enemy.currentanimationToLive = 5
							print("Ik BEN TELEURGESTELD")
							if(not enemy.aggro)then
								enemy.aggro =true
							end
							return
						end
					end
			
					--else move in direction of player to get in los
					--TODO add animations
					if not path._nodes[2] then
						return
					end
					dest.x =   path._nodes[2]._x 
					dest.y =   path._nodes[2]._y 
					dest.x = dest.x * 32
					dest.y = dest.y * 32
					local dx = 0
					local dy = 0
					if(dest.x < enemy.x)then
						dx = dx - dt*enemy.speed
						

						if(dest.y < enemy.y)then
							dy = dy - dt*enemy.speed
							
							--TODO activate animation
						elseif(dest.y>enemy.y)then
							dy = dy + dt*enemy.speed
							--TODO activate animation
						else
							--TODO activate animation
						end
					elseif(dest.x>enemy.x)then
						dx = dx + dt*enemy.speed
						

						if(dest.y < enemy.y)then
							dy = dy - dt*enemy.speed
							--TODO activate animation
						elseif(dest.y>enemy.y)then
							dy = dy + dt*enemy.speed
							--TODO activate animation
						else
							--TODO activate animation
						end
					else
						if(dest.y < enemy.y)then
							dy = dy - dt*enemy.speed
							--TODO activate animation
						elseif(dest.y>enemy.y)then
							dy = dy + dt*enemy.speed
							--TODO activate animation
						else
							--illegalstate, no movement
						end
					end
					if enemy.x + dx < dest.x and dx < 0 then
							dx = dest.x - enemy.x
					end
					if enemy.x + dx > dest.x and dx > 0 then
							dx = dest.x - enemy.x
					end
					if enemy.y + dy < dest.y and dy < 0 then
							dy = dest.y - enemy.y
					end
					if enemy.y + dy > dest.y and dy > 0 then
							dy = dest.y - enemy.y
					end

					enemy.col.x,enemy.col.y = game.world:move(enemy,enemy.col.x+dx,enemy.col.y+dy)
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
				local dx = 0
				local dy = 0
				if(dest.x < enemy.x)then
					dx = dx - dt*enemy.speed
					

					if(dest.y < enemy.y)then
						dy = dy - dt*enemy.speed
						
						--TODO activate animation
					elseif(dest.y>enemy.y)then
						dy = dy + dt*enemy.speed
						--TODO activate animation
					else
						--TODO activate animation
					end
					elseif(dest.x>enemy.x)then
						dx = dx + dt*enemy.speed
						

						if(dest.y < enemy.y)then
							dy = dy - dt*enemy.speed
							--TODO activate animation
						elseif(dest.y>enemy.y)then
							dy = dy + dt*enemy.speed
							--TODO activate animation
						else
							--TODO activate animation
						end
					else
						if(dest.y < enemy.y)then
							dy = dy - dt*enemy.speed
							--TODO activate animation
						elseif(dest.y>enemy.y)then
							dy = dy + dt*enemy.speed
							--TODO activate animation
						else
							--illegalstate, no movement
						end
					end
					if enemy.x + dx < dest.x and dx < 0 then
							dx = dest.x - enemy.x
					end
					if enemy.x + dx > dest.x and dx > 0 then
							dx = dest.x - enemy.x
					end
					if enemy.y + dy < dest.y and dy < 0 then
							dy = dest.y - enemy.y
					end
					if enemy.y + dy > dest.y and dy > 0 then
							dy = dest.y - enemy.y
					end

					enemy.col.x,enemy.col.y = game.world:move(enemy,enemy.col.x+dx,enemy.col.y+dy)				
			end --anders nog bezig, dus mag niks
		end
			--animation updates
		if(enemy.currentanimationToLive == -1 or enemy.currentanimationToLive > 0) then
			if enemy.currentanimationToLive > 0 then
						enemy.currentanimationToLive = enemy.currentanimationToLive - dt 
					end
			enemy.currentanimation:update(dt)
		else
			print("IK BEN WEER BOOS")

			enemy.currentanimation = enemy.animationIdle
			enemy.currentanimationToLive = -1
			enemy.currentanimation:update(dt)
		end
	end

	enemy.draw = function()
		enemy.currentanimation:draw(enemy.imageIdle,enemy.x,enemy.y)
	end
	return enemy
end


orientations = {"TOP","TOPRIGHT","TOPLEFT","RIGHT","LEFT","BOT","BOTLEFT","BOTRIGHT"}
function playerincone(conelength, orientation, enemyx, enemyy)
	relx = game.player.col.x - enemyx
	rely = game.player.col.y - enemyy
	absx = math.abs(relx)
	absy = math.abs(rely)
	rbool = false
	if(orientation = "TOP")then
		if(rely>=0 and absy>=absx)then
			rbool=true
		end
	elseif(orientation = "TOPRIGHT")then
		if(rely>=0 and relx>=0)then
			rbool=true
		end
	elseif(orientation = "TOPLEFT")then
		if(relx<=0 and y>=0)then
			rbool = true
		end
	elseif(orientation = "RIGHT")then
		if(relx>=0 and absy>=absx)then
			rbool =true
		end
	elseif(orientation = "LEFT")then

	elseif(orientation = "BOT")then

	elseif(orientation = "BOTRIGHT")then

	elseif(orientation = "BOTLEFT")then

	elseif(orientation = "RIGHT")then

	return true
	end
