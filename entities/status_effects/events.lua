core.status_effects = {}
core.status_effects.stun = function(t, obj)
		local st = {}
		st.t = t
		st.obj = obj
		obj.status_code = "stun"
		function st.draw()
			if st.t*8 % 2 > 1 then
				love.graphics.setColor( 255,255,255,128)
			end
			obj.draw(true)
			love.graphics.setColor( 255,255,255,255)

		end
		function st.update(dt)
			st.t = st.t - dt
			if st.t < 0 then
				obj.locked_update = nil
				obj.locked_draw = nil
			end
		end
		return st
	end

core.status_effects.knockback = function(t, obj,dx,dy)

		local st = {}
		st.dx = dx
		st.dy = dy
		st.t = t
		st.obj = obj
		obj.status_code = "stun"
		function st.draw()
			if game.player.health <= 0 then
				return
			end
			if st.t*8 % 2 > 1 then
				love.graphics.setColor( 255,255,255,128)
			end
			obj.draw(true)
			love.graphics.setColor( 255,255,255,255)

		end
		function st.update(dt)
			st.t = st.t - dt
			if st.t < 0 or game.player.health <= 0  then
				obj.locked_update = nil
				obj.locked_draw = nil
			end
			obj.x,obj.y = game.world:move(obj, obj.x+ dx * dt /10, obj.y + dy * dt/10)
			if st.t < 0 then
				obj.locked_update = nil
				obj.locked_draw = nil
			end
		end
		return st
	end