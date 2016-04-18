--SWAG

---offset = 14,20
-- size = 68, 81
require "entities.watcher"
function getNewMrT(x,y)
	local mrt = {}
	mrt.x = x
	mrt.y = y
	mrt.height = 124
	mrt.width = 96
	mrt.orientation = "DOWN"
	mrt.speed = 60
	mrt.turn = {0.5,0.33,0.25,0.15}
	mrt.dy = 0
	mrt.dx = 0
	mrt.path = nil
	mrt.isEnemy = true
	mrt.health = 40

	mrt.hp = 600
	mrt.p1 = 450
	mrt.p2 = 300
	mrt.p3 = 150
	mrt.actp = 1

	mrt.currentanimationToLive = -1

	mrt.globalcd = 0

	mrt.nuclearstrikecd = {-5, 15, 13, 10}
	mrt.nuclearstrikes = {-5, 5, 10, 15}
	mrt.nuclearstriketimer = -5
	mrt.nuclearstrikeradius = 44

	mrt.biterange = 40
	mrt.bitecd = {2,1,1,1}
	mrt.bitetimer = 0
	mrt.biteactive = false

	mrt.wallcd = {-5,-5,10,10}
	mrt.walltimer = -5
	mrt.wallsize = 5*32

	mrt.tailattackcd = {8,8,8,8}
	mrt.tailattacktimer = -5
	mrt.tailattackrange = {100,100}
	mrt.tailattackprogress = 0
	mrt.tailattackactive = false

	mrt.lasereyescd = {-5,-5,-5, 10}
	mrt.lasereyesrange = 2000
	mrt.lasereyestimer = -5
	mrt.lasereyesprogress = 0
	mrt.lasereyesactive = false

	--TODO add all animations
	mrt.imageIdle1 = love.graphics.newImage("entities/mrt/mr.t_0.png")
	local g = core.anim8.newGrid(96, 128, mrt.imageIdle1:getWidth(), mrt.imageIdle1:getHeight())
    mrt.animationIdle1 = core.anim8.newAnimation(g('1-1',1), 0.1)

    mrt.imageIdle2 = love.graphics.newImage("entities/mrt/mr.t_0.png")
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

    mrt.imagelasor = love.graphics.newImage("entities/mrt/muricalligator_phase4_attack_A_0_Sheet.png")
	g= core.anim8.newGrid(96, 128, mrt.imagelasor:getWidth(), mrt.imagelasor:getHeight())
    mrt.animationlasor = core.anim8.newAnimation(g('1-8',1), 0.2) 


    mrt.currentanimation = mrt.animationIdle1
    mrt.currentimage = mrt.imageIdle1
    mrt.currentanimationToLive = -1

    mrt.col = game.world:add(mrt,mrt.x,mrt.y,mrt.width,mrt.height)

	mrt.update = function(dt)
		--attackpatterns
		if(mrt.globalcd<=0 and not mrt.lasereyesactive and not mrt.tailattackactive and not mrt.biteactive and mrt.currentanimationToLive < 0)then
			rawdistance = math.sqrt((math.abs(game.player.col.x-mrt.col.x)^2)+(math.abs(game.player.col.y-mrt.col.y)^2))
			if(mrt.nuclearstriketimer<0 and mrt.nuclearstriketimer ~= -5)then
				nuclearstrike()
				mrt.nuclearstriketimer = mrt.nuclearstrikecd[mrt.actp]
			elseif((mrt.orientation == "BOT" or mrt.orientation == "RIGHT" or mrt.orientation == "LEFT" or mrt.orientation == "BOT") and lasereyestimer<=0 and lasereyestimer~=-5)then
				startlasereyes()
			elseif(mrt.facingPlayer(false))then
				if(mrt.walltimer<=0 and mrt.walltimer ~= -5)then
					--get target coordinates
					--get randoms for randomness
					local bool = true
					while bool do
						local randx = math.random(50,200)
						local randy = math.random(50,200)
						local randsign1 = math.random(0,1)
						local randsign2 = math.random(0,1)
						local randdir = math.floor(math.random(0,2))
						if(randsign>0.5)then
							randx = -randx
						end
						if(randsign2>0.5)then
							randy = -randy
						end
						randx = game.player.x + randx
						randy = game.player.y + randy
						--check for collisions with anything
						local randx2 = randx+mrt.wallsize
						local randy2 = randy+mrt.wallsize
						local items, length = game.world:querySegment(randx,randy,randx2,randy2)
						if(#length == 0)then
							bool =true
							buildwall(randx,randy,randx2,randy2)
						end
					end
				elseif(rawdistance<mrt.biterange and mrt.bitecd<=0) then
					if(mrt.actp == 4)then
						mrt.currentanimation = mrt.animationBite2
						mrt.currentimage = mrt.imageBite2
					else
						mrt.currentanimation = mrt.imageBite1
						mrt.currentimage = mrt.imageBite1
					end
					mrt.currentanimationToLive = 0.8
					mr.biteactive = true
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
			elseif(mrt.tailattacktimer<=0 and mrt.tailattacktimer ~= -5 and rawdistance<tailattackrange and facingPlayer(true))then
				tailattack(mrt)
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
			-- TODO handle the las0r 3y3s
		elseif(mrt.tailattackactive)then
			-- TODO handle tailattack
		elseif(mrt.biteactive)then
			if(mrt.currentanimationToLive < 0 )then
				mrt.biteactive = false
			else

			-- TODO handle biteactive
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
			mrt.nuclearstriketimer = mrt.nuclearstriketimer-dt
		end
		if(mrt.bitetimer>0)then
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
		if(mrt.currentanimationToLive>0)then
			mrt.currentanimationToLive = mrt.currentanimationToLive -dt
		end
		--update dat animation
		mrt.currentanimation:update(dt)
		print("animation update")
		return true;
	end

	mrt.draw = function()
		if(not mrt.lasereyesactive)then
			print("lasereyesactive")
			if(mrt.orientation == "TOP")then
				mrt.currentanimation:draw(mrt.currentimage,mrt.col.x+19,mrt.col.y+15,(180*math.pi/180),1,1,48,48)
			elseif(mrt.orientation == "TOPRIGHT")then
				mrt.currentanimation:draw(mrt.currentimage,mrt.col.x+19,mrt.col.y+15,(225*math.pi/180),1,1,48,48)
			elseif(mrt.orientation == "TOPLEFT")then
				mrt.currentanimation:draw(mrt.currentimage,mrt.col.x+19,mrt.col.y+15,(135*math.pi/180),1,1,48,48)
			elseif(mrt.orientation == "RIGHT")then
				mrt.currentanimation:draw(mrt.currentimage,mrt.col.x+19,mrt.col.y+15,(270*math.pi/180),1,1,48,48)
			elseif(mrt.orientation == "LEFT")then
				mrt.currentanimation:draw(mrt.currentimage,mrt.col.x+19,mrt.col.y+15,(90*math.pi/180),1,1,48,48)
			elseif(mrt.orientation == "BOT")then
				mrt.currentanimation:draw(mrt.currentimage,mrt.col.x-28,mrt.col.y-28)
			elseif(mrt.orientation =="BOTRIGHT")then
				mrt.currentanimation:draw(mrt.currentimage,mrt.col.x+19,mrt.col.y+15,(315*math.pi/180),1,1,48,48)
			elseif(mrt.orientation == "BOTLEFT")then
				mrt.currentanimation:draw(mrt.currentimage,mrt.col.x+19,mrt.col.y+15,(45*math.pi/180),1,1,48,48)
			end
		else
			--TODO current angle bepalen aan de hand van de lasereyes progress
			local angle = 0;
			print("animation draw")
			mrt.currentanimation:draw(mrt.currentimage,mrt.col.x+19,mrt.col.y+15,angle,1,1,48,48)
			--TODO laser tekenen
		end
	end

	mrt.hit = function(dmge)
		mrt.hp = mrt.hp - dmge
		if(mrt.hp<mrt.p3)then
			mrt.actp = 4
			--resetcd's
			mrt.nuclearstriketimer = 0
			mrt.walltimer = 0
			mrt.lasereyestimer = 0
		elseif(mrt.hp<mrt.p2)then
			mrt.actp = 3
			--resetcd's
			mrt.nuclearstriketimer = 0
			mrt.walltimer = 0
		elseif(mrt.hp<mrt.p1)then
			mrt.act = 2
			--resetcd's
			mrt.nuclearstriketimer = 0
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

function bite(targettinginfo)
	--TODO
end

function startlasereyes()
	--TODO
end

function nuclearstrike()
	--TODO spawn nuke on player pos with 0.5 delay, do this a certain amount of times in short succesion
end

function buildwall(x1,x2,y1,y2)
	--TODO spawn wall entitys, handle dmge in them
end

tailhitdimension = 30
function tailattack(mrt)
	magicdegreefix = 0.785398 --45graden
	--top first, calculate others from there
	local xje = mrt.x + 0.5*mrt.width  --hack because initially middle
	local ytje = mrt.y + 0.5*tailhitdimension
	--get hitbox left up
	if(mrt.orientation == "TOP")then
		-- niks, is al goed
	elseif(mrt.orientation == "TOPRIGHT")then
		xje = xje + math.cos(magicdegreefix)*xje
		ytje = ytje + math.sin(magicdegreefix)*ytje
	elseif(mrt.orientation == "RIGHT")then
		xje = xje + math.cos(magicdegreefix*2)*xje
		ytje = ytje + math.sin(magicdegreefix*2)*ytje
	elseif(mrt.orientation == "BOTRIGHT")then
		xje = xje + math.cos(magicdegreefix*3)*xje
		ytje = ytje + math.sin(magicdegreefix*3)*ytje
	elseif(mrt.orientation == "BOT")then
		xje = xje + math.cos(magicdegreefix*4)*xje
		ytje = ytje + math.sin(magicdegreefix*4)*ytje
	elseif(mrt.orientation == "BOTLEFT")then
		xje = xje + math.cos(magicdegreefix*5)*xje
		ytje = ytje + math.sin(magicdegreefix*5)*ytje
	elseif(mrt.orientation == "LEFT")then
		xje = xje + math.cos(magicdegreefix*5)*xje
		ytje = ytje + math.sin(magicdegreefix*5)*ytje
	elseif(mrt.orientation == "TOPLEFT")then
		xje = xje + math.cos(magicdegreefix*6)*xje
		ytje = ytje + math.sin(magicdegreefix*6)*ytje
	end
	--TODO animation + hitbox op xje,ytje
end


function destMAKER (mrt)
	local gx, gy = math.floor(.5+game.player.col.x/32),math.floor(.5+game.player.col.y/32) --prolly just player pos
	local tx, ty = math.floor(0.5+mrt.x/32),math.floor(.5+mrt.y/32) --prolly just player pos
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
