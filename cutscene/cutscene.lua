cutscene = {}

cutscene.sentences = {}
cutscene.next = playing
-- sentence : {text = "STRING", character = cutSceneCharacter, dt = time}
function cutscene.start(sentences)
	print(sentences)
	cutscene.sentences = sentences
	cutscene.counter = 1
	if cutscene.sentences[cutscene.counter] ~= nil then
    	GS.push(cutscene)
	end
	print("HOI") 
		
	
end
function cutscene:enter(from)
	    self.from = from -- record previous state

end
function cutscene:update(dt)
	local scene  = cutscene.sentences[cutscene.counter] 
	if scene == nil then 
	  	  GS.pop()
	  	  return
 	end

		if love.keyboard.isDown("return") then

			if FORCESKIP then
				cutscene.counter = cutscene.counter +1
				FORCESKIP = false
			end
		else
			FORCESKIP = true
		end

	
	
		
    --here we are going to create some keyboard events
end
function cutscene.drawScene()
	-- draw background
	love.graphics.setColor(0,0,0,255)
	love.graphics.rectangle("fill",1,400,40000,40000)
	love.graphics.setColor(255,255,255,255)
	--draw character
	local sc =cutscene.sentences[cutscene.counter]
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
function cutscene:draw()
	    self.from:draw()
     

        cutscene.drawScene()


end


local mrT = love.graphics.newImage("entities/hud/mrt_portrait.png")
local porcupine = love.graphics.newImage("entities/hud/porcupine_portrait.png")
local armadillo = love.graphics.newImage( "entities/hud/armadillo_portrait.png")
local turtle =  love.graphics.newImage("entities/hud/turtle_portrait.png")
local cat = love.graphics.newImage( "entities/hud/cat_portrait.png")
local list = {mrt,cat,turtle,armadillo,porcupine}
cutscene.renderPorcupine = function ()
	local x = 60
	local y = 420
	love.graphics.draw(porcupine,x,y,0,2,2)
end

cutscene.renderArmadillo = function ()
	local x = 60
	local y = 420
	love.graphics.draw(armadillo,x,y,0,2,2)
end
cutscene.renderTurtle = function ()
	local x = 60
	local y = 420
	love.graphics.draw(turtle,x,y,0,2,2)
end
cutscene.renderCat = function ()
	local x = 60
	local y = 420
	love.graphics.draw(cat,x,y,0,2,2)
end

cutscene.renderMRT = function ()
	local x = 60
	local y = 420
	love.graphics.draw(mrT,x,y,0,2,2)
end



core.images = {love.image.newImageData( "entities/hud/porcupine_portrait.png" ), love.image.newImageData( "entities/hud/armadillo_portrait.png" ), love.image.newImageData( "entities/hud/turtle_portrait.png" ), love.image.newImageData( "entities/hud/cat_portrait.png" ), love.image.newImageData( "entities/hud/mrt_portrait.png" )}
love.math.setRandomSeed( love.timer.getTime()*10000000 )


local a = (love.math.random(1,5))
love.math.random()
love.math.random()
love.math.random()
love.math.random()


love.math.random()
love.math.random()
love.window.setIcon(core.images[love.math.random(1,5)])