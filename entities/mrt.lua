--SWAG

---offset = 14,20
-- size = 68, 81
--12,23,84,92

require "entities.watcher"
function getNewMrT(x,y)
	math.randomseed(1234)
	local mrt = {}
	mrt.x = x
	mrt.y = y
	mrt.height = 64
	mrt.width = 64
	mrt.orientation = "BOT"
	mrt.speed = 60
	mrt.turn = {1,0.75,0.5,0.25}
	mrt.dy = 0
	mrt.dx = 0
	mrt.path = nil
	mrt.isEnemy = true

	mrt.health = 60
	mrt.p1 = 45
	mrt.p2 = 30
	mrt.p3 = 15
	mrt.actp = 1

	mrt.entities = {}

	mrt.currentanimationToLive = -1

	mrt.globalcd = 0

	mrt.nuclearstrikecd = {2, 15, 13, 10}
	mrt.nuclearstrikes = {-5, 5, 10, 15}
	mrt.nuclearstriketimer = -5
	mrt.nuclearstriketimeribt = 2
	mrt.nuclearstrikeradius = 44
	mrt.nuclearstrikesleft = 0

	mrt.biterange = 30
	mrt.bitecd = {2,1,1,1}
	mrt.bitetimer = 0
	mrt.biteactive = false
	mrt.bitedamage = 2

	mrt.wallcd = {-5,-5,10,10}
	mrt.walltimer = -5

	mrt.tailattackcd = {8,8,8,8}
	mrt.tailattacktimer = 0
	mrt.tailattackrange = 30
	mrt.tailattackprogress = 0
	mrt.tailattackactive = false
	mrt.tailattackdamage = 1

	mrt.lasereyescd = {-5,-5,-5, 5}
	mrt.lasereyesrange = 2000
	mrt.lasereyescenteroffset = 54
	mrt.lasereyestimer = -5
	mrt.lasereyesprogress = 0
	mrt.lasereyesactive = false
	mrt.lasereyesdamage = 1
	mrt.lasereyesvisited = false
	mrt.lasereyesdamage = 2
	mrt.rotation = 0
	mrt.middle_x = 0
	mrt.middle_y = 0
	mrt.origin_x = 0
	mrt.origin_y = 0
	mrt.end_x = 0
	mrt.end_y = 0

	--TODO add all animations
	mrt.imageIdle1 = love.graphics.newImage("entities/mrt/mr.t_0.png")
	local g = core.anim8.newGrid(96, 128, mrt.imageIdle1:getWidth(), mrt.imageIdle1:getHeight())
    mrt.animationIdle1 = core.anim8.newAnimation(g('1-1',1), 0.1)

    mrt.imageIdle2 = love.graphics.newImage("entities/mrt/mr.t_2.png")
	g = core.anim8.newGrid(96, 128, mrt.imageIdle2:getWidth(), mrt.imageIdle2:getHeight())
    mrt.animationIdle2 = core.anim8.newAnimation(g('1-1',1), 0.1)

    mrt.imageTail1 = love.graphics.newImage("entities/mrt/muricalligator_attack_B_0_Sheet.png")
	g = core.anim8.newGrid(96, 128, mrt.imageTail1:getWidth(), mrt.imageTail1:getHeight())
    mrt.animationTail1 = core.anim8.newAnimation(g('1-8',1), 0.1) 

    mrt.imageTail2 = love.graphics.newImage("entities/mrt/muricalligator_phase4_attack_B_0_Sheet.png")
	g = core.anim8.newGrid(96, 128, mrt.imageTail2:getWidth(), mrt.imageTail2:getHeight())
    mrt.animationTail2 = core.anim8.newAnimation(g('1-8',1), 0.1) 

    mrt.imageWalk1 = love.graphics.newImage("entities/mrt/muricalligator_walking_0_Sheet.png")
	g= core.anim8.newGrid(96, 128, mrt.imageWalk1:getWidth(), mrt.imageWalk1:getHeight())
    mrt.animationWalk1 = core.anim8.newAnimation(g('1-8',1), 0.1) 

    mrt.imageWalk2 = love.graphics.newImage("entities/mrt/muricalligator_phase4_walking_0_Sheet.png")
	g= core.anim8.newGrid(96, 128, mrt.imageWalk2:getWidth(), mrt.imageWalk2:getHeight())
    mrt.animationWalk2 = core.anim8.newAnimation(g('1-8',1), 0.1) 

    mrt.imageBite1 = love.graphics.newImage("entities/mrt/muricalligator_attack_A_0_Sheet.png")
	g= core.anim8.newGrid(96, 128, mrt.imageBite1:getWidth(), mrt.imageBite1:getHeight())
    mrt.animationBite1 = core.anim8.newAnimation(g('1-8',1), 0.1) 

    mrt.imageBite2 = love.graphics.newImage("entities/mrt/muricalligator_phase4_attack_A_0_Sheet.png")
	g= core.anim8.newGrid(96, 128, mrt.imageBite2:getWidth(), mrt.imageBite2:getHeight())
    mrt.animationBite2 = core.anim8.newAnimation(g('1-8',1), 0.1) 

    mrt.imagelasor = love.graphics.newImage("entities/mrt/muricalligator_laser_0_Sheet.png")
	g= core.anim8.newGrid(96, 128, mrt.imagelasor:getWidth(), mrt.imagelasor:getHeight())
    mrt.animationlasor = core.anim8.newAnimation(g('1-8',1), 0.1)

    mrt.imagelasorrot = love.graphics.newImage("entities/mrt/muricalligator_laser_0_image.png") 
    g= core.anim8.newGrid(96, 128, mrt.imagelasorrot:getWidth(), mrt.imagelasorrot:getHeight())
    mrt.animationlasorrot = core.anim8.newAnimation(g('1-1',1), 0.1)


    mrt.currentanimation = mrt.animationIdle1
    mrt.currentimage = mrt.imageIdle1
    mrt.currentanimationToLive = -1

    mrt.col = game.world:add(mrt,mrt.x,mrt.y,mrt.width,mrt.height)

	mrt.update = function(dt)
		if mrt.health ~= mrt.last_health then
			core.sounds.enemy_hit()
			mrt.last_health = mrt.health
		end
		if(mrt.health<mrt.p3 and mrt.actp == 3)then
			mrt.actp = 4
			--resetcd's
			mrt.nuclearstriketimer = 0
			mrt.walltimer = 0
			mrt.lasereyestimer = 0
		elseif(mrt.health<mrt.p2 and mrt.actp == 2)then
			mrt.actp = 3
			--resetcd's
			mrt.nuclearstriketimer = 0
			mrt.walltimer = 0
		elseif(mrt.health<mrt.p1 and mrt.actp == 1)then
			mrt.actp = 2
			--resetcd's
			mrt.nuclearstriketimer = 0
		end	
		--handle ents
		for a, entity in pairs(mrt.entities)do
			entity.update(dt,mrt,a)
		end

		--nuke handler
		if(mrt.nuclearstrikesleft > 0 and mrt.nuclearstriketimeribt<=0)then
			--FIRE NUKE
			table.insert(mrt.entities,createNuke(game.player.x-((32-game.player.width)/2),game.player.y -((32-game.player.height)/2)))
			mrt.nuclearstrikesleft = mrt.nuclearstrikesleft -1
			mrt.nuclearstriketimeribt = 0.2
		end
		mrt.x = mrt.col.x
		mrt.y = mrt.col.y
		--attackpatterns
		if(mrt.globalcd<=0 and not mrt.lasereyesactive and not mrt.tailattackactive and not mrt.biteactive and mrt.currentanimationToLive < 0)then
			rawdistance = math.sqrt(((game.player.col.x-mrt.col.x)^2)+((game.player.col.y-mrt.col.y)^2))
			if(mrt.nuclearstriketimer<=0 and mrt.nuclearstriketimer ~= -5)then
				mrt.nuclearstrikesleft = mrt.nuclearstrikes[mrt.actp]
				mrt.nuclearstriketimer = mrt.nuclearstrikecd[mrt.actp]
			elseif((mrt.orientation == "BOT" or mrt.orientation == "RIGHT" or mrt.orientation == "LEFT" or mrt.orientation == "TOP") and mrt.lasereyestimer<=0 and mrt.lasereyestimer~=-5 and not mrt.lasereyesactive)then
				--laz0r activation
				mrt.currentanimation = mrt.animationlasor
				mrt.currentimage = mrt.imagelasor
				mrt.lasereyestimer = mrt.lasereyescd[mrt.actp]
				mrt.currentanimationToLive = 4.8
				mrt.lasereyesactive = true
				mrt.lasereyesprogress = 0
				if mrt.orientation == "TOP" then
					mrt.rotation = 1*math.pi
				end
				if mrt.orientation == "BOT" then
					mrt.rotation = 0*math.pi
				end
				if mrt.orientation == "RIGHT" then
					mrt.rotation = 1.5*math.pi
				end
				if mrt.orientation == "LEFT" then
					mrt.rotation = 0.5*math.pi
				end
				core.sounds.laser()
			elseif(mrt.facingPlayer(false))then
				if(mrt.walltimer<=0 and mrt.walltimer ~= -5)then
					--get target coordinates
					--get randoms for randomness
					local randx = 0
					local randy = 0
					if(math.random(100)>50)then
						randx = game.player.col.x - 50
					else
						randx = game.player.col.x + 50
					end
					if(math.random(100)>50)then
						randy = game.player.col.y + 75
					else
						randy = game.player.col.y - 25
					end

					table.insert(mrt.entities,buildwall(randx,randy))
					mrt.walltimer = mrt.wallcd[mrt.actp]

				elseif (rawdistance <= mrt.biterange + game.player.height*0.67 and mrt.facingPlayer(false) and mrt.bitetimer<=0) then
					-- bite
					if(mrt.actp == 4)then
						mrt.currentanimation = mrt.animationBite2
						mrt.currentimage = mrt.imageBite2
					else
						mrt.currentanimation = mrt.animationBite1
						mrt.currentimage = mrt.imageBite1
					end
					mrt.bitetimer = mrt.bitecd[mrt.actp]
					mrt.currentanimationToLive = 0.8
					mrt.biteactive = true
				else
					-- meh mag niet aanvallen dan maar lopen
					local dest = destMAKER(mrt)
					if(dest == {} or dest.x == nil or dest.y ==nil)then
						return false
					end
					copyPastaKiller(dest, mrt, dt, mrt.turn[mrt.actp], true)
					if(mrt.actp == 4)then
						mrt.currentanimation = mrt.animationWalk2
						mrt.currentimage = mrt.imageWalk2
					else
						mrt.currentanimation = mrt.animationWalk1
						mrt.currentimage = mrt.imageWalk1
					end
				end
			elseif(mrt.tailattacktimer<=0 and rawdistance<mrt.tailattackrange + game.player.height*0.67 and mrt.facingPlayer(true))then
				-- tail
				if(mrt.actp == 4)then
						mrt.currentanimation = mrt.animationTail2
						mrt.currentimage = mrt.imageTail2
					else
						mrt.currentanimation = mrt.animationTail1
						mrt.currentimage = mrt.imageTail1
					end
					mrt.tailattacktimer = mrt.tailattackcd[mrt.actp]
					mrt.currentanimationToLive = 0.8
					mrt.tailattackactive = true
			else
				--turn to player and move towards it
				local dest = destMAKER(mrt)	
				if(dest == {} or dest.x == nil or dest.y ==nil)then
					return false
				end
				copyPastaKiller(dest, mrt, dt, mrt.turn[mrt.actp], true)
				if(mrt.actp == 4)then
					mrt.currentanimation = mrt.animationWalk2
					mrt.currentimage = mrt.imageWalk2
				else
					mrt.currentanimation = mrt.animationWalk1
					mrt.currentimage = mrt.imageWalk1
				end
			end
		elseif(mrt.lasereyesactive)then
			-- TODO handle the laz0r 3y3s
			if(mrt.currentanimationToLive < 0 )then
				--stop laser eyes attack
				mrt.lasereyesactive = false
				mrt.currentanimation = mrt.animationWalk2
				mrt.currentimage = mrt.imageWalk2
			elseif mrt.currentanimationToLive <= 4 then
				--laser rotation
				if not mrt.lasereyesvisited then --set new animation
					mrt.currentimage = mrt.imagelasorrot
					mrt.currentanimation = mrt.animationlasorrot
					mrt.lasereyesvisited = true
				end
				mrt.lasereyesprogress = mrt.lasereyesprogress + dt
				mrt.rotation = mrt.rotation + 2*math.pi*(dt/4)
				mrt.middle_x, mrt.middle_y = mrt.x+mrt.width/2, mrt.y+mrt.height/2
				mrt.origin_x, mrt.origin_y = mrt.middle_x+mrt.lasereyescenteroffset*math.cos(mrt.rotation+0.5*math.pi), mrt.middle_y+mrt.lasereyescenteroffset*math.sin(mrt.rotation+0.5*math.pi)
				mrt.end_x, mrt.end_y = mrt.middle_x+(mrt.lasereyescenteroffset+mrt.lasereyesrange)*math.cos(mrt.rotation+0.5*math.pi), mrt.middle_y+(mrt.lasereyescenteroffset+mrt.lasereyesrange)*math.sin(mrt.rotation+0.5*math.pi)
				local others, others_len = game.world:querySegment(mrt.origin_x, mrt.origin_y, mrt.end_x, mrt.end_y, function (obj) return obj.isPlayer end)
				if others_len > 0 then
					game.player.shape.damage(mrt.lasereyesdamage, nil, nil, false)
				end
			else
				--charge animation
				--do nothing here
			end
		elseif(mrt.tailattackactive)then
			if(mrt.currentanimationToLive < 0 )then
				mrt.tailattackactive = false
				if mrt.actp == 4 then
					mrt.currentanimation = mrt.animationWalk2
					mrt.currentimage = mrt.imageWalk2
				else
					mrt.currentanimation = mrt.animationWalk1
					mrt.currentimage = mrt.imageWalk1
				end
			else
				local ddx = 0
				local ddy = 0
				if mrt.orientation == "TOP" then
					ddy = 1
				end
				if mrt.orientation == "BOT" then
					ddy = -1
				end
				if mrt.orientation == "RIGHT" then
					ddx = -1
				end
				if mrt.orientation == "LEFT" then
					ddx = 1
				end
				local a = 1/math.sqrt(2)
				if mrt.orientation == "TOPLEFT" then
					ddx = a
					ddy = a
				end
				if mrt.orientation == "TOPRIGHT" then
					ddx = -a
					ddy = a
				end
				if mrt.orientation == "BOTLEFT" then
					ddx = a
					ddy = -a
				end
				if mrt.orientation == "BOTRIGHT" then
					ddx = -a
					ddy = -a
				end

				local atk_x, atk_y = mrt.x+mrt.width/2+ddx*38, mrt.y+mrt.height/2+ddy*38
				if math.sqrt(math.pow(game.player.y+game.player.height/2-atk_y, 2) + math.pow(game.player.x+game.player.width/2-atk_x, 2))<= mrt.tailattackrange + game.player.height*0.67 and mrt.currentanimationToLive < 0.2  then
					game.player.shape.damage(mrt.tailattackdamage, nil, mrt)
				end

			end
		elseif(mrt.biteactive)then
			if(mrt.currentanimationToLive < 0 )then
				mrt.biteactive = false
				if mrt.actp == 4 then
					mrt.currentanimation = mrt.animationWalk2
					mrt.currentimage = mrt.imageWalk2
				else
					mrt.currentanimation = mrt.animationWalk1
					mrt.currentimage = mrt.imageWalk1
				end
			else
				local ddx = 0
				local ddy = 0
				if mrt.orientation == "TOP" then
					ddy = -1
				end
				if mrt.orientation == "BOT" then
					ddy = 1
				end
				if mrt.orientation == "RIGHT" then
					ddx = 1
				end
				if mrt.orientation == "LEFT" then
					ddx = -1
				end
				local a = 1/math.sqrt(2)
				if mrt.orientation == "TOPLEFT" then
					ddx = -a
					ddy = -a
				end
				if mrt.orientation == "TOPRIGHT" then
					ddx = a
					ddy = -a
				end
				if mrt.orientation == "BOTLEFT" then
					ddx = -a
					ddy = a
				end
				if mrt.orientation == "BOTRIGHT" then
					ddx = a
					ddy = a
				end

				local atk_x, atk_y = mrt.x+mrt.width/2+ddx*50, mrt.y+mrt.height/2+ddy*50
				if math.sqrt(math.pow(game.player.y+game.player.height/2-atk_y, 2) + math.pow(game.player.x+game.player.width/2-atk_x, 2))<= mrt.biterange + game.player.height*0.67 and mrt.currentanimationToLive < 0.2  then
					game.player.shape.damage(mrt.bitedamage, nil, mrt)
				end

			end

		else
			--only moving left to do, yes i can move during animations
			local dest = destMAKER(mrt)
			if(dest == {} or dest.x == nil or dest.y ==nil)then
				return false

			else
			copyPastaKiller(dest, mrt, dt, mrt.turn[mrt.actp], true)
			end
			if(mrt.actp == 4)then
				mrt.currentanimation = mrt.animationWalk2
				mrt.currentimage = mrt.imageWalk2
			else
				mrt.currentanimation = mrt.animationWalk1
				mrt.currentimage = mrt.imageWalk1
			end
		end
		--timerhandling
		if(mrt.nuclearstriketimer>0)then
			mrt.nuclearstriketimer = mrt.nuclearstriketimer-dt
		end
		if(mrt.bitetimer>0)then
			mrt.bitetimer = mrt.bitetimer-dt
		end
		if(mrt.walltimer>0)then
			mrt.walltimer = mrt.walltimer-dt
		end
		if(mrt.tailattacktimer>0)then
			mrt.tailattacktimer = mrt.tailattacktimer-dt
		end
		if(mrt.lasereyestimer>0)then
			mrt.lasereyestimer = mrt.lasereyestimer-dt
		end
		if(mrt.currentanimationToLive>0)then
			mrt.currentanimationToLive = mrt.currentanimationToLive-dt
		end
		if(mrt.globalcd>0)then
			mrt.globalcd = mrt.globalcd-dt
		end
		if(mrt.nuclearstriketimeribt>0)then
			mrt.nuclearstriketimeribt = mrt.nuclearstriketimeribt - dt
		end
		--update dat animation
		mrt.currentanimation:update(dt)
		return true;
	end

	mrt.draw = function()
		if(not mrt.lasereyesactive)then
			if(mrt.orientation == "TOP")then
				mrt.currentanimation:draw(mrt.currentimage,mrt.col.x+32,mrt.col.y+40,(180*math.pi/180),1,1,48,48)
			elseif(mrt.orientation == "TOPRIGHT")then
				mrt.currentanimation:draw(mrt.currentimage,mrt.col.x+28,mrt.col.y+38,(225*math.pi/180),1,1,48,48)
			elseif(mrt.orientation == "TOPLEFT")then
				mrt.currentanimation:draw(mrt.currentimage,mrt.col.x+38,mrt.col.y+40,(135*math.pi/180),1,1,48,48)
			elseif(mrt.orientation == "RIGHT")then
				mrt.currentanimation:draw(mrt.currentimage,mrt.col.x+24,mrt.col.y+32,(270*math.pi/180),1,1,48,48)
			elseif(mrt.orientation == "LEFT")then
				mrt.currentanimation:draw(mrt.currentimage,mrt.col.x+42,mrt.col.y+32,(90*math.pi/180),1,1,48,48)
			elseif(mrt.orientation == "BOT")then
				mrt.currentanimation:draw(mrt.currentimage,mrt.col.x-16,mrt.col.y-25)
			elseif(mrt.orientation =="BOTRIGHT")then
				mrt.currentanimation:draw(mrt.currentimage,mrt.col.x+27,mrt.col.y+27,(315*math.pi/180),1,1,48,48)
			elseif(mrt.orientation == "BOTLEFT")then
				mrt.currentanimation:draw(mrt.currentimage,mrt.col.x+38,mrt.col.y+25,(45*math.pi/180),1,1,48,48)
			end
		else
			mrt.currentanimation:draw(mrt.currentimage,mrt.col.x+31,mrt.col.y+24,mrt.rotation,1,1,48,48)
			if (mrt.currentanimationToLive <= 4) then
				love.graphics.line(mrt.origin_x, mrt.origin_y, mrt.end_x, mrt.end_y)
			end
		end
		for _, entity in pairs(mrt.entities)do
			entity.draw()
		end
	end

	mrt.facingPlayer = function(booltail)
		local relx = game.player.col.x - mrt.x
		local rely = game.player.col.y - mrt.y
		local absx = math.abs(relx)
		local absy = math.abs(rely)
		local rbool = false
		-- is it inside the correct cone?
		if(mrt.orientation == "TOP")then
			if((rely>=0 and absy>=absx and booltail)or(rely<=0 and absy>=absx and not booltail))then
				rbool=true
			end
		elseif(mrt.orientation == "TOPRIGHT")then
			if(rely>=0 and relx<=0 and booltail)or(rely<=0 and relx>=0 and not booltail)then
				rbool=true
			end
		elseif(mrt.orientation == "TOPLEFT")then
			if(relx>=0 and rely>=0 and booltail)or(rely<=0 and relx<=0 and not booltail)then
				rbool = true
			end
		elseif(mrt.orientation == "RIGHT")then
			if(relx<=0 and absy<=absx and booltail)or(relx>=0 and absy<=absx and not booltail)then
				rbool =true
			end
		elseif(mrt.orientation == "LEFT")then
			if(relx>=0 and absy<=absx and booltail)or(relx<=0 and absy<=absx and not booltail)then
				rbool = true
			end
		elseif(mrt.orientation == "BOT")then
			if(rely<=0 and absy>=absx and booltail)or(rely>=0 and absy>=absx and not booltail)then
				rbool=true
			end
		elseif(mrt.orientation == "BOTRIGHT")then
			if(relx<=0 and rely<=0 and booltail)or(rely>=0 and rely>=0 and not booltail)then
				rbool=true
			end
		elseif(mrt.orientation == "BOTLEFT")then
			if(rely<=0 and relx>=0 and booltail)or(rely>=0 and relx<=0 and not booltail)then
				rbool=true
			end
		end
		return rbool
	end

	return mrt
end


function buildwall(x,y)
	local wall = {}
	wall.ttl = 5
	wall.x = x
	wall.y = y
	wall.width = 32
	wall.height = 25
	wall.col = game.world:add(wall,wall.x,wall.y,wall.width*3,25)

    wall.image = love.graphics.newImage("entities/explosion/wall.png")
	wall.update = function( dt, mrt, a)

		if(game.player.x>wall.x and game.player.x<(wall.x+96) and game.player.y > wall.y and game.player.y < (wall.y+25))then
			--dmge
			game.player.shape.damage(1)
		end
		wall.ttl =  wall.ttl - dt
		if(wall.ttl <0)then
			game.world:remove(wall)
			table.remove(mrt.entities,a)
		end
	end
	wall.draw = function()
		for i=1,5 do
			for j=1,3 do
				love.graphics.draw(wall.image,(wall.x+32*(j-1)),(wall.y+5*(i-1)))
			end
		end
	end
	return wall
end

function destMAKER (mrt)
	local gx, gy = math.floor(game.player.col.x/32),math.floor(game.player.col.y/32) --prolly just player pos
	local tx, ty = math.floor(0.5+mrt.col.x/32),math.floor(0.5+mrt.col.y/32) --prolly just player pos
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
	local path, length = nil,nil
	local dest = {}
	print(tx,ty, gx,gy)
	if not game.player.invisible then
	path,length = pathFinder:getPath(tx,ty,gx,gy)
		if path == nil then
		 	path, length = pathFinder:getPath(tx,ty,gx+1,gy+1)

		end
	end
	if path == nil then
		path = mrt.path 
		if mrt.path == nil then
			return {}
		end
	else
		mrt.path = path
	end
	local len = #path
	if not path._nodes[2] then
		return {}
	end

	dest.x =   path._nodes[2]._x 
	dest.y =   path._nodes[2]._y 
	dest.x = dest.x * 32
	dest.y = dest.y * 32
	return dest
end

function createNuke(tarx, tary)
	local nuke = {}
	nuke.explosion = love.graphics.newImage("entities/explosion/explosion1-sheet.png")
	local g = core.anim8.newGrid(32, 32, nuke.explosion:getWidth(), nuke.explosion:getHeight())
    nuke.explosionani = core.anim8.newAnimation(g('1-6',1), 0.1)
    nuke.crosshair = love.graphics.newImage("entities/explosion/crosshairs.png")
	nuke.x = tarx
	nuke.y = tary
	nuke.ttl = 0.5
	nuke.explttl = 0.6
	nuke.dim = 44
	nuke.sound = false

	nuke.update = function ( dt, mrt, a )	

		if(nuke.ttl < 0)then
			--deal dmge to player if in range
			if(not nuke.sound)then
				core.sounds.explosion()
				nuke.sound = true
			end
			local midx = nuke.x + 0.5*nuke.dim
			local midy = nuke.y + 0.5*nuke.dim
			local playx = game.player.x + 0.5 * game.player.width
			local playy = game.player.y + 0.5 * game.player.height
			local dist = math.sqrt((midx-playx)^2 + (midy-playy)^2)
			if(dist<=16)then
				--do dmge
				game.player.shape.damage(1)
			end
			nuke.explttl = nuke.explttl -dt
			if(nuke.explttl<0)then
				table.remove(mrt.entities,a)
			end
			nuke.explosionani:update(dt)
		else
			nuke.ttl = nuke.ttl - dt
		end
	end
	nuke.draw = function()
		love.graphics.line(nuke.x,nuke.y,nuke.x,nuke.y)
		if(nuke.ttl>=0)then
			love.graphics.draw(nuke.crosshair,nuke.x-32,nuke.y-32)
		else
			nuke.explosionani:draw(nuke.explosion,nuke.x,nuke.y)
		end
	end
	return nuke
end
