-- Manages keys that are used to open locked doors

Key = Class{}

function Key:init(x, y)
  self.x = x
  self.y = y
  self.z = 2
  self.img = love.graphics.newImage("art/items.png")
  self.quad = love.graphics.newQuad(0, 0, 16, 16, self.img:getDimensions())
  self.isKey = true
end

function Key:update() end

function Key:render()
  love.graphics.draw(self.img, self.quad, self.x, self.y)
end