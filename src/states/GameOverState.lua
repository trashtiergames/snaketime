-- Display game over image and text, listen for retry

GameOverState = Class{__includes = BaseState}

function GameOverState:init()
  self.gameOverImage = love.graphics.newImage("art/game-over.png")
end

function GameOverState:update()
  if love.keyboard.wasPressed("t") then
    stateStacc:pop()
    stateStacc:push(TitleState())
  end
end

function GameOverState:render()
  love.graphics.origin()
  love.graphics.draw(self.gameOverImage, 0, 0)
  love.graphics.setColor(237/255, 239/255, 226/255, 1)
  love.graphics.printf(
    "PRESS T TO TRY AGAIN", 
    0, 
    VIRTUAL_HEIGHT * 0.75, 
    VIRTUAL_WIDTH, 
    "center")
  love.graphics.setColor(1, 1, 1, 1)
end