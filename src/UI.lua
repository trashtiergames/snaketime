-- Draw amount of keys to screen without being affected by the camera

UI = Class{}

function UI:init(player)
  self.player = player
  self.keyImg = love.graphics.newImage("art/items.png")
  self.keyQuad = love.graphics.newQuad(16, 0, 16, 16, self.keyImg:getDimensions())
  self.featherQuad = love.graphics.newQuad(32, 0, 16, 16, self.keyImg:getDimensions())
end
 
function UI:update()
    
end

function UI:render()
  love.graphics.origin()

  -- Buffer
  local x, y = 4, 2
  for i=1, self.player.keys do
    love.graphics.draw(self.keyImg, self.keyQuad, x, y)
    x = x + 16
  end

  local x, y = 4, 18
  if self.player.feather then
    love.graphics.draw(self.keyImg, self.featherQuad, x, y)
  end
end