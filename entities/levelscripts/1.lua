local bools = {}
return function()
	if not bools.intro then
		bools.intro= true
			print("INTRO_SCENE")
		end
if game.player.x > 800 and game.player.x< 900 and game.player.y < 1300 and game.player.y > 1000  and not bools.shooting_intro then
			 bools.shooting_intro  = true
			 print("HOI, je kan schieten met de rechtermuisknop")
	end
	if #game.enemies == 0 and not bools.dramatic then
		game.shape_count=2
		bools.dramatic = true
		print("Dramatic scene; armadillo dies, etc.")
	end
end