
local t = {}
t.bools = {}
 t.func =  function()
	if not t.bools.intro then
		t.bools.intro= true
			cutscene.start(t.scene_intro)
		end
end


 
t.scene_intro = { {text="I am the Cat Schrödinger..",character=cutscene.renderCat},
{text = "By entering this box, I'll be both dead and alive..",character=cutscene.renderCat},
{text = "This should be enough for you to be able to switch to my form",character=cutscene.renderCat},
{text = "My dash ability should enable you to get out of the way of attacks",character=cutscene.renderCat},
{text = "and also, it should enable you to jump over a bit of water.",character=cutscene.renderCat},

{text = "Thank you. I won't disappoint you..",character=cutscene.renderPorcupine}}

return t