


local t = {}
t.bools = {}
 t.func =  function()
	if not t.bools.scene1 and game.player.x > 1050 then

		t.bools.scene1 = true
		cutscene.start(t.scene1 )
	end
	if not t.bools.scene2 and game.hasKey then
		t.bools.scene2 = true
		cutscene.start(t.scene2 )
	end
end

t.scene1  = { {text="I am prepared to give my life for this cause, but only if you prove your worth \n by killing these enemies.",character=cutscene.renderTurtle},
{text="Also, I can burrow underneath these rocks by pressing the right mouse button.",character=cutscene.renderPorcupine},{text=" It seems every character has an action on both mousebuttons.",character=cutscene.renderPorcupine}}
t.scene2  = { {text="You've proven your worth..",character=cutscene.renderTurtle}
,{text="(To try your new powers, press the ".. CONTROLS.THREE.. " key.)",character=cutscene.renderNIL},
{text="When you're ready, walk to the right.",character=cutscene.renderNIL}}

return t