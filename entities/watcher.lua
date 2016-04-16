
require 'entities.enemy'
--items, length = game.world:querysegment(x1,y1,x2,y2)
--template
-- patrol points = { (x,y)}
-- if no patrol give empty list
-- cone width and length in pixels
function getNewWatcher(patrolpoints, conelength)
	local enemy = {}
	enemy.x = 59
	enemy.y = 600
	enemy.height = 32
	enemy.width = 32
	enemy.aggroRange = 100
	enemy.attackRange = 50
	enemy.aggro = 0
	enemy.speed = 60
	enemy.patrolindex = 1
	enemy.conelength = conelength
	enemy.patrol = patrolpoints
	enemy.aggrotimer = 5
	enemy.orientation = "BOT"


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
			inCone = playerInCone(enemy.conelength,enemy.orientation,enemy.x,enemy.y)
			if(inCone)then
				enemy.aggro = enemy.aggrotimer
			end

			--only follow if in aggro mode

			if(enemy.aggro > 0) then

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

				if(math.abs(gx-tx) < 3 or math.abs(gy-ty)<3) then

					if(rawdist <= enemy.attackRange) then 
						-- aanvallen!
						print("Ik BEN TELEURGESTELD")
					end
			
					--else move in direction of player to get in los
					if not path._nodes[2] then
						return
					end
					dest.x =   path._nodes[2]._x 
					dest.y =   path._nodes[2]._y 
					dest.x = dest.x * 32
					dest.y = dest.y * 32
					local dx = 0
					local dy = 0
					local goalorientation
					if(dest.x < enemy.x)then
						dx = dx - dt*enemy.speed
						if(dest.y < enemy.y)then
							dy = dy - dt*enemy.speed
						elseif(dest.y>enemy.y)then
							dy = dy + dt*enemy.speed
					elseif(dest.x>enemy.x)then
						dx = dx + dt*enemy.speed
						if(dest.y < enemy.y)then
							dy = dy - dt*enemy.speed
						elseif(dest.y>enemy.y)then
							dy = dy + dt*enemy.speed
					else
						if(dest.y < enemy.y)then
							dy = dy - dt*enemy.speed

						elseif(dest.y>enemy.y)then
							dy = dy + dt*enemy.speed
					end
					--rounding fix ding AKA magic n shit
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
					--Bepaal orientation, even moar magic
					ding = abs(dx)/abs(dy)
					if(ding > 2)then
						if(dx>0)then
							goalorientation = "RIGHT"
						else
							goalorientation = "LEFT"
						end
					elseif(ding<0.5)then
						if(dy>0)then
							goalorientation = "DOWN"
						else
							goalorientation = "TOP"
						end
					else
						if(dx>0)then
							if(dy>0)then
								goalorientation = "BOTRIGHT"
							else
								goalorientation= "TOPRIGHT"
							end
						else
							if(dy>0)then
								goalorientation = "BOTLEFT"
							else
								goalorientation= "TOPLEFT"
							end
					--check for need of turning
					if(goalorientation ~= enemy.orientation)then
						--turn dat shit
						--cant act during turn
						enemy.currentanimationToLive = 0.25
						local stepor = turnmatrix[indexOf(enemy.orientation)][indexOf(goalorientation)]
						enemy.orientation=stepor
						if(stepor = "TOP")then
							--assign animation
						elseif(stepor = "TOPRIGHT")then
							--assign animation
						elseif(stepor = "TOPLEFT")then
							--assign animation
						elseif(stepor = "RIGHT")then
							--assign animation
						elseif(stepor = "LEFT")then
							--assign animation
						elseif(stepor = "BOT")then
							--assign animation
						elseif(stepor = "BOTRIGHT")then
							--assign animation
						elseif(stepor = "BOTLEFT")then
							--assign animation
						elseif(stepor = "RIGHT")then
							--assign animation
						end

					else
						--lekker moven
						enemy.col.x,enemy.col.y = game.world:move(enemy,enemy.col.x+dx,enemy.col.y+dy)
						enemy.currentanimationToLive = -1
					end
				end
				aggro = aggro - dt
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

					--COPYPASTA ALERT
					ding = abs(dx)/abs(dy)
					if(ding > 2)then
						if(dx>0)then
							goalorientation = "RIGHT"
						else
							goalorientation = "LEFT"
						end
					elseif(ding<0.5)then
						if(dy>0)then
							goalorientation = "DOWN"
						else
							goalorientation = "TOP"
						end
					else
						if(dx>0)then
							if(dy>0)then
								goalorientation = "BOTRIGHT"
							else
								goalorientation= "TOPRIGHT"
							end
						else
							if(dy>0)then
								goalorientation = "BOTLEFT"
							else
								goalorientation= "TOPLEFT"
							end
					--check for need of turning
					if(goalorientation ~= enemy.orientation)then
						--turn dat shit
						--cant act during turn
						enemy.currentanimationToLive = 0.25
						local stepor = turnmatrix[indexOf(enemy.orientation)][indexOf(goalorientation)]
						enemy.orientation=stepor
						if(stepor = "TOP")then
							--assign animation
						elseif(stepor = "TOPRIGHT")then
							--assign animation
						elseif(stepor = "TOPLEFT")then
							--assign animation
						elseif(stepor = "RIGHT")then
							--assign animation
						elseif(stepor = "LEFT")then
							--assign animation
						elseif(stepor = "BOT")then
							--assign animation
						elseif(stepor = "BOTRIGHT")then
							--assign animation
						elseif(stepor = "BOTLEFT")then
							--assign animation
						elseif(stepor = "RIGHT")then
							--assign animation
						end

					else
						--lekker moven
						enemy.col.x,enemy.col.y = game.world:move(enemy,enemy.col.x+dx,enemy.col.y+dy)
						enemy.currentanimationToLive = -1
					end				
			end --anders nog bezig, dus mag niks
		end
			--animation updates
		if(enemy.currentanimationToLive == -1 or enemy.currentanimationToLive > 0) then
			if enemy.currentanimationToLive > 0 then
						enemy.currentanimationToLive = enemy.currentanimationToLive - dt 
					end
			enemy.currentanimation:update(dt)
		elseif(aggro>0)
			print("IK BEN NOG BOOS")
			enemy.currentanimationToLive = -1
			enemy.currentanimation:update(dt)
		else
			print("IK BEN niet echt meer BOOS")
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


orientations = {"TOP","TOPRIGHT","RIGHT","BOTRIGHT","BOT","BOTLEFT","LEFT","TOPLEFT"}
function playerInCone(conelength, orientation, enemyx, enemyy)
	relx = game.player.col.x - enemyx
	rely = game.player.col.y - enemyy
	absx = math.abs(relx)
	absy = math.abs(rely)
	rbool = false
	-- not too far?
	if(math.sqrt(relx^2+rely^2)<conelength)then
		local x1,y1,x2,y2 = enemy.x+16, enemy.y+16, game.player.col.x+16, game.player.col.y+16
		local items, length = game.world:querySegment(x1,y1,x2,y2)
		-- can i see it?
		if(items[2] == game.player) then
			-- is it inside the correct cone?
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
				if(x<=0 and absy<=absx)then
					rbool = true
				end
			elseif(orientation = "BOT")then
				if(rely<=0 and absy>=absx)then
					rbool=true
				end
			elseif(orientation = "BOTRIGHT")then
				if(relx>=0 and rely<=0)then
					rbool=true
				end
			elseif(orientation = "BOTLEFT")then
				if(rely<=0 and relx<=0)then
					rbool=true
				end
			elseif(orientation = "RIGHT")then
				if(relx>=0 and absy>=absx)then
					rbool =true
				end
			end
		end
	return rbool
end

function indexOf(element)
    for i=1,(#orientations+1) do
    	if(orientations[i]==element)then
    		return i;
    	end
    end
    return 0 --gebeurt toch niet
end

-- {start,goal} -> firststep
-- 				{"TOP",		"TOPRIGHT",	"RIGHT",	"BOTRIGHT",	"BOT",		"BOTLEFT",	"LEFT",		"TOPLEFT"}
turnmatrix= {	{nil,		"TOP",		"TOPRIGHT",	"RIGHT",	"BOTRIGHT",	"LEFT",		"TOPLEFT",	"TOP"}, --TOP
			 	{"TOPRIGHT",nil,		"TOPRIGHT",	"RIGHT",	"BOTRIGHT",	"BOT",		"TOPLEFT",	"TOP"}, --TOPRIGHT
			 	{"TOPRIGHT","RIGHT",	nil,		"RIGHT",	"BOTRIGHT",	"BOT",		"BOTLEFT", 	"TOP"}, --RIGHT
			 	{"TOPRIGHT","RIGHT",	"BOTRIGHT",	nil,		"BOTRIGHT",	"BOT",		"BOTLEFT",	"TOP"}, --BOTRIGHT
			 	{"TOPRIGHT","RIGHT",	"BOTRIGHT",	"BOT",		nil,		"BOT",		"BOTLEFT",	"LEFT"}, --BOT
			 	{"TOPLEFT",	"RIGHT",	"BOTRIGHT",	"BOT",		"BOTLEFT",	nil,		"BOTLEFT",	"LEFT"}, --BOTLEFT
			 	{"TOPLEFT",	"TOP",		"BOTRIGHT",	"BOT",		"BOTLEFT",	"LEFT",		nil,		"LEFT"}, --LEFT
			 	{"TOPLEFT",	"TOP",		"TOPRIGHT",	"BOT",		"BOTLEFT",	"LEFT",		"TOPLEFT",	nil}	}--TOPLEFT