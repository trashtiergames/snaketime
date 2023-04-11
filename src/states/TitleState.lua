-- Display title image, play title theme and listen for game start

TitleState = Class{__includes = BaseState}

function TitleState:init()
  self.titleImage = love.graphics.newImage("art/title.png")
end

function TitleState:enter()
  titleTheme:setLooping(true)
  titleTheme:play()
end

function TitleState:exit()
  titleTheme:stop()
end

function TitleState:update()
  if love.keyboard.wasPressed("s") then
    stateStacc:pop()
  end
end

function TitleState:render()
  love.graphics.origin()
  love.graphics.draw(self.titleImage, 0, 0)
  love.graphics.setColor(44/255, 34/255, 40/255, 1)
  love.graphics.printf("PRESS S TO SNAKE", 20, 130, 100, "center")
  love.graphics.setColor(1, 1, 1, 1)
end