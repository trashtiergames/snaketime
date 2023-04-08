WinState = Class{__includes = BaseState}

function WinState:update()
  -- if love.keyboard.wasPressed("t") then
  --   stateStacc:pop()
  --   stateStacc:push(TitleState())
  -- end
end

function WinState:render()
  love.graphics.origin()
  love.graphics.setColor(237/255, 239/255, 226/255, 1)
  love.graphics.printf(
    "YOU WIN!", 
    0, 
    VIRTUAL_HEIGHT * 0.75, 
    VIRTUAL_WIDTH, 
    "center")
  love.graphics.setColor(1, 1, 1, 1)
end