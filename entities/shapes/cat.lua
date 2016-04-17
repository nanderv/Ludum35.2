local function cat_col_handler(self, other)
	if other.isWall or other.isEnemy then
		return "slide"
	end
	return "cross"
end

require 'entities.quill'
local cat = {}

cat.images = {}
cat.images.down =love.graphics.newImage('entities/cat/cat_walking_0_Sheet.png')
cat.images.up =love.graphics.newImage('entities/cat/cat_walking_0_Sheet.png')
cat.images.left =love.graphics.newImage('entities/cat/cat_walking_0_Sheet.png')
cat.images.right =love.graphics.newImage('entities/cat/cat_walking_0_Sheet.png')
cat.images.upleft =love.graphics.newImage('entities/cat/cat_walking_0_Sheet.png')
cat.images.upright =love.graphics.newImage('entities/cat/cat_walking_0_Sheet.png')
cat.images.downleft =love.graphics.newImage('entities/cat/cat_walking_0_Sheet.png')
cat.images.downright =love.graphics.newImage('entities/cat/cat_walking_0_Sheet.png')

cat.images.current = cat.images.down
cat.animations = {}
cat.grids = {}
cat.speed = 200
cat.grids.walk = core.anim8.newGrid(cat.images.current:getWidth()/8, 96, cat.images.current:getWidth(), cat.images.current:getHeight())
cat.animations.walk = core.anim8.newAnimation(cat.grids.walk('1-8',1), 0.06)
cat.animations.current = cat.animations.walk



cat.images_A =love.graphics.newImage('entities/cat/cat_attack_A_0_Sheet.png')


cat.images_B =love.graphics.newImage('entities/cat/cat_dodge_0_Sheet.png')


cat.images_idle = {}
cat.images_idle.down =love.graphics.newImage('entities/cat/cat_walking_0_Sheet.png')



cat.grids.B = core.anim8.newGrid(cat.images.current:getWidth()/8, 96, cat.images.current:getWidth(), cat.images.current:getHeight())
cat.animations.B = core.anim8.newAnimation(cat.grids.B('1-8',1), 0.02,  'pauseAtEnd')

cat.A = function(dx,dy)

		game.player.locked_update = cat.updateA
		game.player.locked_draw = cat.drawA
		cat.timeout = 0.3
		local ddx = 0
		local ddy = 0
		if game.player.orientation == "up" then
			ddy = 1
		end
		if game.player.orientation == "down" then
			ddy = -1
		end
		if game.player.orientation == "right" then
			ddx = 1
		end
		if game.player.orientation == "left" then
			ddx = -1
		end
		local a = 1/math.sqrt(2)
		if game.player.orientation == "upleft" then
			ddx = -a
			ddy = -a
		end
		if game.player.orientation == "upright" then
			ddx = a
			ddy = -a
		end
		if game.player.orientation == "downleft" then
			ddx = -a
			ddy = a
		end
		if game.player.orientation == "downright" then
			ddx = a
			ddy = a
		end
		game.player.ddx = ddx
		game.player.ddy = ddy


		
end
cat.B = function()
	if 	game.player.shape.attack_B_pause and 		game.player.shape.attack_B_pause > 0 then
		return true
	end
		game.player.locked_update = cat.updateB
		game.player.locked_draw = cat.drawB
		cat.timeout = 0.3
		local ddx = 0
		local ddy = 0
		if game.player.orientation == "up" then
			ddy = -1
		end
		if game.player.orientation == "down" then
			ddy = 1
		end
		if game.player.orientation == "right" then
			ddx = 1
		end
		if game.player.orientation == "left" then
			ddx = -1
		end
		local a = 1/math.sqrt(2)
		if game.player.orientation == "upleft" then
			ddx = -a
			ddy = -a
		end
		if game.player.orientation == "upright" then
			ddx = a
			ddy = -a
		end
		if game.player.orientation == "downleft" then
			ddx = -a
			ddy = a
		end
		if game.player.orientation == "downright" then
			ddx = a
			ddy = a
		end
		game.player.shape.attack_B_pause=2
		game.player.ddx = ddx
		game.player.ddy = ddy
		cat.animations.current = cat.animations.B:clone()
		cat.images.current = cat.images_B[game.player.orientation]
end
function cat.damage(hit, status)
			if game.player.invincibility > 0 then
				return
			end

			game.player.health = game.player.health - hit
			print("HIT")

			if game.player.health <= 0 then
				print("DEAD")
				GS.push(core.states.death )
				return
			end
	 game.player.invincibility = 2
		
end	
function cat.update(dt)
  cat.animations.current:update(dt)
  if game.player.shape.attack_B_pause ~= nil then
  	game.player.shape.attack_B_pause=game.player.shape.attack_B_pause- dt
  end
end
function cat.draw()
	cat.images.current=cat.images.left
	local angle = 0
	if game.player.orientation == "up" then
		angle=180*math.pi/180
	end
	if game.player.orientation == "left" then
		angle=90*math.pi/180
	end
	if game.player.orientation == "right" then
		angle=-90*math.pi/180
	end

if game.player.orientation == "upright" then
		angle=-135*math.pi/180
	end
	if game.player.orientation == "downright" then
		angle=-45*math.pi/180
	end
	if game.player.orientation == "upleft" then
		angle=135*math.pi/180
	end
	if game.player.orientation == "downleft" then
		angle=45*math.pi/180
	end




	cat.animations.current:draw(cat.images.current,game.player.col.x+14,game.player.col.y+17,angle,1,1,48,48)

end
function cat.updateA(dt)
	cat.timeout = cat.timeout-dt
	if cat.timeout < 0 then
		game.player.locked_update = nil
		game.player.locked_draw = nil
	end
end
function cat.drawA()
	cat.images.current=cat.images.left
	local angle = 0
	if game.player.orientation == "up" then
		angle=180*math.pi/180
	end
	if game.player.orientation == "left" then
		angle=90*math.pi/180
	end
	if game.player.orientation == "right" then
		angle=-90*math.pi/180
	end

if game.player.orientation == "upright" then
		angle=-135*math.pi/180
	end
	if game.player.orientation == "downright" then
		angle=-45*math.pi/180
	end
	if game.player.orientation == "upleft" then
		angle=135*math.pi/180
	end
	if game.player.orientation == "downleft" then
		angle=45*math.pi/180
	end




	cat.animations.current:draw(cat.images.current,game.player.col.x+14,game.player.col.y+17,angle,1,1,48,48)
end
function cat.updateB(dt)
	cat.timeout = cat.timeout-dt
	game.player.col.x , game.player.col.y, cols, len =game.world:move(game.player,game.player.col.x+game.player.ddx*dt*400,game.player.y+game.player.ddy*dt*400,cat_col_handler)


	if love.mouse.isDown(2) then
		cat.animations.current:update(dt)
	end
	if cat.timeout < 0 then
		game.player.locked_update = nil
		game.player.locked_draw = nil
		cat.animations.current = cat.animations.walk
		game.player.shape.attack_B_pause=1.2
	
	end
	
end
function cat.drawB()
cat.images.current=cat.images.left
	local angle = 0
	if game.player.orientation == "up" then
		angle=180*math.pi/180
	end
	if game.player.orientation == "left" then
		angle=90*math.pi/180
	end
	if game.player.orientation == "right" then
		angle=-90*math.pi/180
	end

if game.player.orientation == "upright" then
		angle=-135*math.pi/180
	end
	if game.player.orientation == "downright" then
		angle=-45*math.pi/180
	end
	if game.player.orientation == "upleft" then
		angle=135*math.pi/180
	end
	if game.player.orientation == "downleft" then
		angle=45*math.pi/180
	end




	cat.animations.current:draw(cat.images.current,game.player.col.x+14,game.player.col.y+17,angle,1,1,48,48)	

end
return cat