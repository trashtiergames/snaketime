-- Saves infos about tiles of the level

Feather = Class{}

function Feather:init(x, y)
    self.x = x
    self.y = y
    self.z = 2
    self.img = love.graphics.newImage("art/items.png")
    self.quad = love.graphics.newQuad(16, 16, 16, 16, self.img:getDimensions())
    self.isFeather = true
end

function Feather:render()
    love.graphics.draw(self.img, self.quad, self.x, self.y)
end