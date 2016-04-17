
local function regularmove(item, other)
		 if other.isPorcupine then
		 	return "cross"
		 end
		 if other.isWall or other.isCatWater then
		 	return "slide"
		 end
		 return "cross"
end
require 'entities.enemy'

-- patrol points = { (x,y)}
-- if no patrol give empty list
-- cone width and length in pixels
function getNewWatcher(x,y,patrolpoints, conelength)
	local enemy = {}
	enemy.x = x
	enemy.y = y
	enemy.height = 21
	enemy.width = 39
	enemy.offx = 28
	enemy.offy = 40
	enemy.aggro = 0
	enemy.speed = 60
	enemy.patrolindex = 1
	enemy.conelength = conelength
	enemy.patrol = patrolpoints
	enemy.aggrotimer = 5
	enemy.orientation = "BOT"
	enemy.attackrange = 23
	enemy.testcounter = 0
	enemy.health = 5
	enemy.dy = 0
	enemy.dx = 0
	enemy.isEnemy=true

	enemy.path = nil
	--animations
	enemy.image = love.graphics.newImage("entities/watcher/watcher_0_Sheet.png")
	local g = core.anim8.newGrid(96, 96, enemy.image:getWidth(), enemy.image:getHeight())
    enemy.animation = core.anim8.newAnimation(g('1-8',1), 0.06) -- ("frame numbers", "index starting frame", "time per frame", optional end of loop)
    -- do other animations

    --initially idle
    enemy.currentanimation = enemy.animationIdle
    enemy.currentanimationToLive = -1
    enemy.col = game.world:add(enemy,enemy.x+48,enemy.y+52,39,21)

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
			local inCone = playerInCone(enemy.conelength,enemy.orientation,enemy)

			if(inCone)then
				enemy.aggro = enemy.aggrotimer
			end

			--only follow if in aggro mode

			if(enemy.aggro > 0) then
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
						return false
					end
				else
					enemy.path = path
				end
				local len = #path

				local rawdist = math.sqrt((math.abs(game.player.col.x-enemy.col.x)^2)+(math.abs(game.player.col.y-enemy.col.y)^2))
				if(rawdist <= enemy.attackrange) then 
					--aanvallen!

					 s = core.status_effects.knockback(1,game.player,enemy.dx*100, enemy.dy*100)
				     game.player.shape.damage(2,s, enemy)

					enemy.currentanimationToLive = 2

				end
		
				--else move in direction of player to get in los
				if not path._nodes[2] then
					return
				end
				dest.x =   path._nodes[2]._x 
				dest.y =   path._nodes[2]._y 
				dest.x = dest.x * 32
				dest.y = dest.y * 32
				copyPastaKiller(dest,enemy, dt,0.25, false)
				enemy.aggro = enemy.aggro - dt
			else
				-- patrol area if patrol specified
				if(#enemy.patrol>0) then
					if(math.abs(enemy.x - enemy.patrol[enemy.patrolindex+1].x)<32 and math.abs(enemy.y - enemy.patrol[enemy.patrolindex+1].y)<32)then
						enemy.patrolindex = (enemy.patrolindex+1)%(#enemy.patrol)
					end
					dest.x = enemy.patrol[enemy.patrolindex+1].x
					dest.y = enemy.patrol[enemy.patrolindex+1].y
				end
				copyPastaKiller(dest, enemy, dt, 0.25, false)
			end --anders nog bezig, dus mag niks
		end
			--animation updates

		if(enemy.currentanimationToLive == -1 or enemy.currentanimationToLive > 0) then
			if enemy.currentanimationToLive > 0 then
						enemy.currentanimationToLive = enemy.currentanimationToLive - dt 
					end
			enemy.animation:update(dt)
		elseif(enemy.aggro>0) then
			enemy.currentanimationToLive = -1
			enemy.animation:update(dt)
		else
			enemy.currentanimationToLive = -1
			enemy.animation:update(dt)
		end
		return true
	end

	enemy.draw = function()

	love.graphics.line(enemy.col.x,enemy.col.y,enemy.x+enemy.width,enemy.col.y+enemy.col.height)

	love.graphics.line(enemy.col.x+enemy.width,enemy.col.y,enemy.col.x,enemy.col.y+enemy.height)
		if(enemy.orientation == "TOP")then
			enemy.animation:draw(enemy.image,enemy.col.x+19,enemy.col.y+15,(180*math.pi/180),1,1,48,48)
		elseif(enemy.orientation == "TOPRIGHT")then
			enemy.animation:draw(enemy.image,enemy.col.x+19,enemy.col.y+15,(225*math.pi/180),1,1,48,48)
		elseif(enemy.orientation == "TOPLEFT")then
			enemy.animation:draw(enemy.image,enemy.col.x+19,enemy.col.y+15,(135*math.pi/180),1,1,48,48)
		elseif(enemy.orientation == "RIGHT")then
			enemy.animation:draw(enemy.image,enemy.col.x+19,enemy.col.y+15,(270*math.pi/180),1,1,48,48)
		elseif(enemy.orientation == "LEFT")then
			enemy.animation:draw(enemy.image,enemy.col.x+19,enemy.col.y+15,(90*math.pi/180),1,1,48,48)
		elseif(enemy.orientation == "BOT")then
			enemy.animation:draw(enemy.image,enemy.col.x-enemy.offx,enemy.col.y-enemy.offy)
		elseif(enemy.orientation =="BOTRIGHT")then
			enemy.animation:draw(enemy.image,enemy.col.x+19,enemy.col.y+15,(315*math.pi/180),1,1,48,48)
		elseif(enemy.orientation == "BOTLEFT")then
			enemy.animation:draw(enemy.image,enemy.col.x+19,enemy.col.y+15,(45*math.pi/180),1,1,48,48)
		end
	end
	return enemy
end


function copyPastaKiller(dest, enemy, dt,delay,mrtbool)
	local dx = 0
	local dy = 0	
	if(dest.x < enemy.x)then
	dx = dx - dt*enemy.speed
	

	if(dest.y < enemy.y)then
		dy = dy - dt*enemy.speed
		
		
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
	local ding
	if(dy == 0) then 
		ding = math.abs(dx)/0.001
	else
		ding = math.abs(dx)/math.abs(dy)
	end
	if(ding > 2)then
		if(dx>0)then
			goalorientation = "RIGHT"
		else
			goalorientation = "LEFT"
		end
	elseif(ding<0.5)then
		if(dy>0)then
			goalorientation = "BOT"
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
		end
	end
	--check for need of turning
	if(goalorientation ~= enemy.orientation and enemy.currentanimationToLive < 0)then
		--turn dat shit
		--cant act during turn
		enemy.currentanimationToLive = delay
		local stepor = turnmatrix[indexOf(goalorientation)][indexOf(enemy.orientation)]
		enemy.orientation=stepor
		if(mrtbool)then
			--lekker moven, mrt doesnt giva a shit
			enemy.col.x,enemy.col.y = game.world:move(enemy,enemy.col.x+dx,enemy.col.y+dy,regularmove)
			enemy.dx = dx
			enemy.dy = dy
		end
	else
		--lekker moven
		enemy.col.x,enemy.col.y = game.world:move(enemy,enemy.col.x+dx,enemy.col.y+dy,regularmove)
		enemy.dx = dx
		enemy.dy = dy
	end	
end


orientations = {"TOP","TOPRIGHT","RIGHT","BOTRIGHT","BOT","BOTLEFT","LEFT","TOPLEFT"}
function playerInCone(conelength, orientation, enemy)
	local relx = game.player.col.x - enemy.x
	local rely = game.player.col.y - enemy.y
	local absx = math.abs(relx)
	local absy = math.abs(rely)
	local rbool = false

	-- not too far?
	if(math.sqrt(relx^2+rely^2)<enemy.conelength)then

		local x1,y1,x2,y2 = enemy.x+0.5*enemy.width, enemy.y+0.5*enemy.height, game.player.col.x+0.5*game.player.width, game.player.col.y+0.5*game.player.height
		local items, length = game.world:querySegment(x1,y1,x2,y2)
		-- can i see it?
		if(items[2] == game.player) then
			-- is it inside the correct cone?

			if(orientation == "TOP")then
				if(rely<=0 and absy>=absx)then
					rbool=true
				end
			elseif(orientation == "TOPRIGHT")then
				if(rely<=0 and relx>=0)then
					rbool=true
				end
			elseif(orientation == "TOPLEFT")then
				if(relx<=0 and rely<=0)then
					rbool = true
				end
			elseif(orientation == "RIGHT")then
				if(relx>=0 and absy<=absx)then
					rbool =true
				end
			elseif(orientation == "LEFT")then
				if(relx<=0 and absy<=absx)then
					rbool = true
				end
			elseif(orientation == "BOT")then
				if(rely>=0 and absy>=absx)then
					rbool=true
				end
			elseif(orientation == "BOTRIGHT")then
				if(relx>=0 and rely>=0)then
					rbool=true
				end
			elseif(orientation == "BOTLEFT")then
				if(rely>=0 and relx<=0)then
					rbool=true
				end
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
    return 0 --gebeurt toch niet, toch?
end

-- {goal,goal} -> firststep
-- 				{"TOP",		"TOPRIGHT",	"RIGHT",	"BOTRIGHT",	"BOT",		"BOTLEFT",	"LEFT",		"TOPLEFT"}
turnmatrix= {	{nil,		"TOP",		"TOPRIGHT",	"RIGHT",	"BOTRIGHT",	"LEFT",		"TOPLEFT",	"TOP"}, --TOP
			 	{"TOPRIGHT",nil,		"TOPRIGHT",	"RIGHT",	"BOTRIGHT",	"BOT",		"TOPLEFT",	"TOP"}, --TOPRIGHT
			 	{"TOPRIGHT","RIGHT",	nil,		"RIGHT",	"BOTRIGHT",	"BOT",		"BOTLEFT", 	"TOP"}, --RIGHT
			 	{"TOPRIGHT","RIGHT",	"BOTRIGHT",	nil,		"BOTRIGHT",	"BOT",		"BOTLEFT",	"TOP"}, --BOTRIGHT
			 	{"TOPRIGHT","RIGHT",	"BOTRIGHT",	"BOT",		nil,		"BOT",		"BOTLEFT",	"LEFT"}, --BOT
			 	{"TOPLEFT",	"RIGHT",	"BOTRIGHT",	"BOT",		"BOTLEFT",	nil,		"BOTLEFT",	"LEFT"}, --BOTLEFT
			 	{"TOPLEFT",	"TOP",		"BOTRIGHT",	"BOT",		"BOTLEFT",	"LEFT",		nil,		"LEFT"}, --LEFT
			 	{"TOPLEFT",	"TOP",		"TOPRIGHT",	"BOT",		"BOTLEFT",	"LEFT",		"TOPLEFT",	nil}	}--TOPLEFT

