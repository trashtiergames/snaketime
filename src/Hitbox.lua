Hitbox = Class{}

function Hitbox:init(x, y, width, height)
  self.x = x
  self.y = y
  self.width = width
  self.height = height
  self.z = 11
  self.isHitbox = true
end

function Hitbox:update() end

function Hitbox:render()
  love.graphics.setColor(255,0,0)
  love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
  love.graphics.setColor(255,255,255)
end