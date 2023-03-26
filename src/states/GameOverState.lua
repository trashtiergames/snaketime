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
end