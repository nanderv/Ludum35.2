
local t = {}
t.bools = {}
 t.func =  function()
	if not t.bools.intro then
		t.bools.intro= true
			cutscene.start(t.scene_intro)
		end
	if not t.bools.p3 and game.enemies[1].health < game.enemies[1].p1 then
			t.bools.p3 = true
			cutscene.start(t.scene_3)
	end
	if not t.bools.p2 and game.enemies[1].health < game.enemies[1].p2 then
			t.bools.p2 = true
			cutscene.start(t.scene_4)
	end
	love.graphics.setColor(128,128,128)
	love.graphics.rectangle("fill",300,650, 700,680 )
	love.graphics.setColor(255,0,0)
	love.graphics.rectangle("fill",300,650, 100+ (600* game.enemies[1].health/60),680 )
	love.graphics.setColor(255,255,255)
end


 
t.scene_intro = { {text="I, MISTER T, the Famous Muricalligator, will now show you the definition of death..",character=cutscene.renderMRT},
{text = "My dash ability should enable you to get out of the way of attacks",character=cutscene.renderMRT},
{text = "We shall see..",character=cutscene.renderPorcupine}}


t.scene_3 = {{text = "I know words, like nuclear missile strike",character=cutscene.renderMRT}}

t.scene_4 = {{text = "Mister T, the Famous Murricaligator will show you how Walls solve every problem..",character=cutscene.renderMRT}}



return t