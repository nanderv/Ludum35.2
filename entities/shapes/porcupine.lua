local porcupine = {}
porcupine.A = function()
		game.player.locked_update = porcupine.updateA
		game.player.locked_draw = porcupine.drawA
		porcupine.timeout = 1
end
porcupine.B = function()

end
function porcupine.update(dt)

end
function porcupine.draw()

end
function porcupine.updateA(dt)
	porcupine.timeout = porcupine.timeout-dt
	if porcupine.timeout < 0 then
		game.player.locked_update = nil
		game.player.locked_draw = nil
	end
end
function porcupine.drawA()

end
function porcupine.updateB(dt)

end
function porcupine.drawB()

end
return porcupine