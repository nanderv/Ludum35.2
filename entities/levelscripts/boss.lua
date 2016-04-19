
local t = {}
t.bools = {}
 t.func =  function()
	if not t.bools.intro then
		t.bools.intro= true
			cutscene.start(t.scene_intro)
		end
end


 
t.scene_intro = { {text="I, MISTER T, the Famous Muricalligator, will now show you the definition of death..",character=cutscene.renderMRT},
{text = "Mister T, the Famous Murricaligator will show you how Walls solve every problem..",character=cutscene.renderMRT},
{text = "I know words, like nuclear missile",character=cutscene.renderMRT},
{text = "My dash ability should enable you to get out of the way of attacks",character=cutscene.renderMRT},
{text = "and also, it should enable you to jump over a bit of water.",character=cutscene.renderMRT},

{text = "Thank you. I won't disappoint you..",character=cutscene.renderPorcupine}}

return t