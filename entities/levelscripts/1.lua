
local t = {}
t.bools = {}
 t.func =  function()
	if not t.bools.intro then
		t.bools.intro= true
			cutscene.start(t.scene_intro)
		end
if game.player.x > 800 and not t.bools.shooting_intro then
		if game.hasKey then
			cutscene.start(t.smartkid)
	t.bools.gate_closed=true

		t.bools.shot=true
		else
			cutscene.start(t.scene_shooting)
		end
			 t.bools.shooting_intro  = true
			
			 
	end

	if game.player.x > 1000  and not t.bools.gate_closed then
		cutscene.start(t.gate_closed)

		t.bools.gate_closed=true

	end


	if game.hasKey and not t.bools.shot then
		if game.player.x > 800 then

		
		cutscene.start(t.scene_shot)
	end
		t.bools.gate_closed=true

		t.bools.shot=true

	end

		
	if game.player.x > 1400   and not t.bools.dramatic then
		
		t.bools.dramatic = true
		cutscene.start(t.scene_dramatic )
		game.enemies[1].aggro = 1000

		print("Dramatic scene; armadillo dies, etc.")
	end


	if #game.enemies == 0 and not t.bools.levelend then
		game.shape_count=2
		t.bools.levelend = true
				cutscene.start(t.scene_end)

		print("EXTRA SHAPE")
	end
end


 
t.scene_intro = { {text="Hi, my name is Fluffy.",character=cutscene.renderPorcupine},
{text = "Ever since Mister T, the Famous Muricalligator took over the world\n things have been getting worse.",character=cutscene.renderPorcupine},
{text = "I am going to meet my friends to see if we have a way to stop him..",character=cutscene.renderPorcupine}}

t.scene_shooting  = { {text="I can shoot by pressing the left mouse button.",character=cutscene.renderPorcupine},
{text="Also, I can hide myself by pressing the right mouse button.",character=cutscene.renderPorcupine},{text=" Enemies stupid enough to attack me will get double their damage back.",character=cutscene.renderPorcupine}}


t.gate_closed = {{ text="The gate is closed. Walk North a bit to find the target to shoot..",character=cutscene.renderPorcupine}}

t.scene_shot = { {text="Nice shot!. I can continue my way going right now.",character=cutscene.renderPorcupine}}

t.scene_dramatic = { {text="Hi! ...",character=cutscene.renderPorcupine}
,{text="Oh, you're here.",character=cutscene.renderArmadillo}
,{text="Mister T, the Famous Muricalligator knows what we're planning",character=cutscene.renderArmadillo}
,{text="We have to act now!",character=cutscene.renderArmadillo}
,{text="Suddenly, a scorpion appears, and kills the armadillo",character=cutscene.renderNIL}}



t.scene_end = {{text="... Here, take my power. Use it to stop Mister T, the Famous Muricalligator",character=cutscene.renderArmadillo}
,{text="(To try your new powers, press the ".. CONTROLS.TWO.. " key. To return to your former self, press "..CONTROLS.ONE .. ")",character=cutscene.renderNIL},
{text="When you're ready, walk to the right.",character=cutscene.renderNIL}}

t.smartkid = { {text="Well, aren't you the clever kid, doing things before you're supposed to...",character=cutscene.renderPorcupine}}

return t