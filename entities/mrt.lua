--SWAG

function getNewMrT(x,y){
	mrt.x = x
	mrt.y = y
	mrt.height = 100
	mrt.width = 100

	mrt.hp = 600
	mrt.p1 = 450
	mrt.p2 = 300
	mrt.p3 = 150
	mrt.actp = 1

	mrt.nuclearstrikecd = {-5,5,4,3}
	mrt.nuclearstriketimer = -5

	mrt.biterange = 100
	mrt.bitecd = {2,1,1,1}
	mrt.bitetimer = 0

	mrt.wallcd = {-5,-5,10,10}
	mrt.walltimer = -5
	mrt.wallsize = 200


	update = function(dt)
		--attackpatterns
		if(mrt.nuclearstriketimer<0 and mrt.nuclearstriketimer ~= -5)then
			nuclearstrike()
			mrt.nuclearstriketimer = mrt.nuclearstrikecd[mrt.actp]
		end
		if(mr.facingPlayer())then
			if(mrt.walltimer<0 and mrt.walltimer ~= -5)then
				--get target coordinates



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
	end

	draw = function()
		enemy.currentanimation:draw(enemy.imageIdle,enemy.x,enemy.y)
	end

	hit = function(dmge)
		mrt.hp = mrt.hp - dmge
		if(mrt.hp<mrt.p3)then
			mrt.actp = 4
			--resetcd's
			mrt.nuclearstriketimer = 0
			mrt.walltimer = 0
		elseif(mrt.hp<mrt.p2)
			mrt.actp = 3
			--resetcd's
			mrt.nuclearstriketimer = 0
			mrt.walltimer = 0
		elseif(mrt.hp<mrt.p1)
			mrt.act = 2
			--resetcd's
			mrt.nuclearstriketimer = 0
		end	

	end

	facingPlayer = function()
	--TODO
	return true
	end

	return mrt
end

function bite(targettinginfo)
	--TODO
end

function lasereyes(targettinginfo)
	--TODO
end

function nuclearstrike()
	--TODO
end

function buildwall(targettinginfo)
	--TODO
end

function swekattack(targettinginfo)
	--TODO
end

}