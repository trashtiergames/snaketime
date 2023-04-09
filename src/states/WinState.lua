WinState = Class{__includes = BaseState}

function WinState:init(player, camera)
  self.player = player
  self.camera = camera
  
  self.img = love.graphics.newImage("art/player-walk-right.png")
  local grid = anim8.newGrid(16, 16, self.img:getWidth(), self.img:getHeight())
  self.animation = anim8.newAnimation(grid('1-4',1), 0.1)
end

function WinState:update(dt)
  self.animation:update(dt)
  self.camera:update()
end

function WinState:render()
  self.camera:render()
  self.animation:draw(self.img, self.player.x, self.player.y)
  
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