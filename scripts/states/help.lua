local help = GS.new()
help.lines = {
    'SYNOPSIS',
    '',
    'Mr T. the Famous Muricalligator has won the Swampian Presedential Elections, and',
    'is about to build a wall to block your access to the swamp. To maintain your',
    'freedom, you have to go and defeat him to prevent the wall from being completed.',
    '',
    'CONTROLS',
    '',
    'Switch between unlocked characters by pressing the designated keys.',
    '',
    'GAME INFO',
    '',
    'I am the game developed by team IAPC during the Ludum Dare 35 game jam.',
    'I was developed during the weekend of 16 and 17 april 2016.',
    'My developers used LOVE as their engine',
    '',
    'Thanks for playing!',
    '',
    '- Fluffy the Porcupine Saves the World'
}
function help:enter(from)
    self.from = from
end

function help:draw()
    W, H = love.graphics.getWidth(), love.graphics.getHeight()
    self.from:draw(true)
    love.graphics.printf('HELP', 0, H/2-80, W, 'center')
    
    for i, line in pairs(self.lines) do
        love.graphics.printf(line, W/4 - 10, H/2 -60 + i*20, W/2 + 20, 'left')
    end
end

function help:keypressed(key)
    if key == "return" or key == "escape" then
        GS.pop()
    end
end

return help
