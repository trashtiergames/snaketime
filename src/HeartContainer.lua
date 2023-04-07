-- Saves infos about tiles of the level

HeartContainer = Class{}

function HeartContainer:init(x, y)
  self.x = x
  self.y = y
  self.z = 2
  self.img = love.graphics.newImage("art/items.png")
  self.quad = love.graphics.newQuad(48, 0, 16, 16, self.img:getDimensions())
  self.isHeartContainer = true
end

function HeartContainer:update() end

function HeartContainer:render()
  love.graphics.draw(self.img, self.quad, self.x, self.y)
end