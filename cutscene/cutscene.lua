	gamestate.cutscene = {}
gamestate.cutscene.bgImg = love.graphics.newImage('graphics/cutscenebackground.png')
gamestate.cutscene.sentences = {}
gamestate.cutscene.next = gamestate.playing
-- sentence : {text = "STRING", character = cutSceneCharacter, dt = time}
function gamestate.cutscene.start(sentences,Xnext)
	gamestate.cutscene.sentences = sentences
	gamestate.cutscene.counter = 1
	if gamestate.cutscene.sentences[gamestate.cutscene.counter] ~= nil then
    	GS.switch(gamestate.cutscene)
	else
		if Xnext == nil then
gamestate.cutscene.next = gamestate.playing
	else
		gamestate.cutscene.next = Xnext

		end
		print("Invalid sentences")
	end
	
end
function gamestate.cutscene:update(dt)
	local scene  = gamestate.cutscene.sentences[gamestate.cutscene.counter] 
	if scene == nil then 
	  	  GS.switch(gamestate.cutscene.next)
	  	  return
 	end
	if scene.dt ~= nil then

		if love.keyboard.isDown("return") then

			if scene.AUTOSKIP then
				gamestate.cutscene.counter = gamestate.cutscene.counter +1
				scene.AUTOSKIP = false
				print("AN")
			end
		else
			scene.AUTOSKIP = true
		end

		scene.dt  = scene.dt  - dt*0.5
		if scene.dt  <= 0 then
			gamestate.cutscene.counter = gamestate.cutscene.counter +1
		end
	if gamestate.cutscene.sentences[gamestate.cutscene.counter] == nil then
  	  GS.switch(gamestate.cutscene.next)
	end
	else
		if scene.options then
			if scene.selected == nil then
				scene.selected = 1
			end
			if love.keyboard.isDown("1","2","3","4") then
		gamestate.cutscene.counter = gamestate.cutscene.counter +1

			end	
		end
	end
    --here we are going to create some keyboard events
end
function gamestate.cutscene.drawScene()
	-- draw background
	love.graphics.draw(gamestate.cutscene.bgImg,1,400)
	--draw character
	local sc =gamestate.cutscene.sentences[gamestate.cutscene.counter]
	if sc~= nil then
		if sc.character ~= nil then
			sc.character()
		end
		if sc.character ~= nil then
			local pFont = love.graphics.getFont()
			love.graphics.setFont(love.graphics.newFont(18))
			if sc.text ~= nil then
			love.graphics.print(sc.text,200,450)
			love.graphics.setFont(pFont)
			end
			if sc.options ~= nil then
				for i=1,#sc.options do
				love.graphics.print(i..".  "..sc.options[i],200,400+24*i)
			end
			end

		end
		  
	end
	--draw text
end
function gamestate.cutscene:draw()
    gamestate.cam:draw(function(l,t,w,h)
        gamestate.room.map:draw()

    drawDoors()

      for k,v in pairs(gamestate.room.objects) do
        v:draw()
    end
    for k,e in pairs(gamestate.room.enemies) do
        e:draw()
    end
        character.draw()

        -- love.graphics.circle("fill",175,75,math.sqrt(0.5*50*0.5*50+0.5*50*0.5*50))
        if(gamestate.room.map.layers["foreground"]) then
            gamestate.room.map.layers["foreground"].draw()
        end
        if(debug) then
            love.graphics.push('all')
            debugWorldDraw(gamestate.room.world,l,t,w,h)
            love.graphics.pop()
        end
        --- ugly hack
    end)

    minimap.draw()
        gamestate.cutscene.drawScene()


end
gamestate.cutscene.meImg = love.graphics.newImage('graphics/cutscene/me.png')
gamestate.cutscene.phoneImg = love.graphics.newImage('graphics/cutscene/phone.png')
gamestate.cutscene.employeeBoss = love.graphics.newImage('graphics/cutscene/employeeBoss.png')

gamestate.cutscene.renderMe = function ()
	local x = 60
	local y = 420
	love.graphics.draw(gamestate.cutscene.meImg,x,y,0,2,2)
end

gamestate.cutscene.renderEmployeeBoss = function ()
	local x = 700
	local y = 420
	love.graphics.draw(gamestate.cutscene.employeeBoss,x,y,0,-2,2)
end
gamestate.cutscene.renderMeStartCombat = function ()
	gamestate.cutscene.renderMe()
	character.hasSuitcase = true

end
gamestate.cutscene.replaceMustacheMan = function()
	Enemy(mustacheMan.x,mustacheMan.y,gamestate.room,gamestate.room.world)
	mustacheMan.body.body:setY(-100000)
	end
gamestate.cutscene.phone = function ()
	local x = 700
	local y = 420
	love.graphics.draw(gamestate.cutscene.phoneImg,x,y,0,2,2)
end

gamestate.cutscene.mustache = love.graphics.newImage('graphics/cutscene/mustache.png')
gamestate.cutscene.renderMustache = function ()
	local x = 700
	local y = 420
	love.graphics.draw(gamestate.cutscene.mustache,x,y,0,-2,2)
end