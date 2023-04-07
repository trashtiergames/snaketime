-- Saves infos about tiles of the level

Heart = Class{}

function Heart:init(x, y)
  self.x = x
  self.y = y
  self.z = 2
  self.img = love.graphics.newImage("art/items.png")
  self.quad = love.graphics.newQuad(48, 16, 16, 16, self.img:getDimensions())
  self.isHeart = true
end

function Heart:update() end

function Heart:render()
  love.graphics.draw(self.img, self.quad, self.x, self.y)
end