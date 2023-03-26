TitleState = Class{__includes = BaseState}

function TitleState:init()
  self.titleImage = love.graphics.newImage("art/title.png")
end

function TitleState:update()
  if love.keyboard.wasPressed("f") then
    stateStacc:pop()
  end
end

function TitleState:render()
  love.graphics.origin()
  love.graphics.draw(self.titleImage, 0, 0)
end