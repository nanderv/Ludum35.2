 function drawMessage()
  local msg = instructions:format(tostring(shouldDrawDebug))
  love.graphics.setColor(255, 255, 255)
  love.graphics.print(msg, 550, 10)
end

 function drawDebug()
  bump_debug.draw(game.world)

  local statistics = ("fps: %d, mem: %dKB, collisions: %d, items: %d"):format(love.timer.getFPS(), collectgarbage("count"), cols_len, game.world:countItems())
  love.graphics.setColor(255, 255, 255)
  love.graphics.printf(statistics, 0, 580, 790, 'right')
end

local consoleBuffer = {}
local consoleBufferSize = 15
for i=1,consoleBufferSize do consoleBuffer[i] = "" end
function consolePrint(msg)
  table.remove(consoleBuffer,1)
  consoleBuffer[consoleBufferSize] = msg
end

 function drawConsole()
  local str = table.concat(consoleBuffer, "\n")
  for i=1,consoleBufferSize do
    love.graphics.setColor(255,255,255, i*255/consoleBufferSize)
    love.graphics.printf(consoleBuffer[i], 10, 580-(consoleBufferSize - i)*12, 790, "left")
  end
end

-- helper function
 function drawBox(box, r,g,b)
  love.graphics.setColor(r,g,b,40)
  if box.width == nil then
    return
  end
  love.graphics.rectangle("fill", box.x, box.y, box.width, box.height)
  love.graphics.setColor(r,g,b)
  love.graphics.rectangle("line", box.x, box.y,box.width, box.height)


end


function drawBlocks()
  for _,block in pairs(game.blocks) do
    drawBox(block, 255,0,0)
  end
  for _,block in pairs(game.enemies) do
    drawBox(block, 255,0,0)
  end
    for _,block in pairs(game.projectiles) do
    drawBox(block, 255,0,0)
  end
  drawBox(game.player,255,0,0)
    love.graphics.setColor(255,255,255,255)

end