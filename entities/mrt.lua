--SWAG
require "entities.watcher"
function getNewMrT(x,y)
	mrt.x = x
	mrt.y = y
	mrt.height = 124
	mrt.width = 96
	mrt.orientation = "DOWN"
	mrt.speed = 60
	mrt.turn = {0.5,0.33,0.25,0.15}
	mrt.dy = 0
	mrt.dx = 0

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

	mrt.biterange = 100
	mrt.bitecd = {2,1,1,1}
	mrt.bitetimer = 0
	mrt.biteprogress = 0
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

	update = function(dt)
		--attackpatterns
		if(mrt.globalcd<=0 and not mrt.lasereyesactive and not mrt.tailattackactive and not mrt.biteactive)then
			rawdistance = math.sqrt((math.abs(game.player.col.x-mrt.col.x)^2)+(math.abs(game.player.col.y-mrt.col.y)^2))
			if(mrt.nuclearstriketimer<0 and mrt.nuclearstriketimer ~= -5)then
				nuclearstrike()
				mrt.nuclearstriketimer = mrt.nuclearstrikecd[mrt.actp]
			elseif(mrt.orientation == "BOT" and lasereyestimer<=0 and lasereyestimer~=-5)then
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
					--TODO bite him
				else
					-- meh mag niet aanvallen dan maar lopen
					copyPastaKiller(dest, mrt, dt, mrt.turn[mrt.actp], true)
				end
			elseif(mrt.tailattacktimer<=0 and mrt.tailattacktimer ~= -5 and rawdistance<tailattackrange and facingPlayer(true))then
				tailattack(mrt)
			else
				--turn to player and move towards it
				copyPastaKiller(dest, mrt, dt, mrt.turn[mrt.actp], true)
			end
		elseif(mrt.lasereyesactive)then
			-- TODO handle the las0r 3y3s
		elseif(mrt.tailattackactive)then
			-- TODO handle tailattack
		elseif(mrt.biteactive)then
			-- TODO handle biteactive
		else
			--only moving left to do
			copyPastaKiller(dest, mrt, dt, mrt.turn[mrt.actp], true)
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
	end

	draw = function()
		if(mrt.lasereyesactive)then
			-- TODO show correct part of the lasereyes
		elseif(mrt.tailattackactive)then
			-- TODO show correct part of tail attack
		elseif(mrt.biteactive)then
			-- TODO show correct part of the biteattack
		elseif((mrt.dy+mrt.dx)>)then
			-- TODO show correct movement
		else
			-- TODO show idle
		end
	end

	hit = function(dmge)
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

	facingPlayer = function(booltail)
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
	local xje = mrt.x + 0.5*mrt.width - 0.5*tailhitdimension --hack because initially middle
	local ytje = mrt.y
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

