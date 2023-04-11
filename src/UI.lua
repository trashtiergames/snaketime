-- Draws icons to screen without being affected by the camera

UI = Class{}

function UI:init(player)
  self.player = player
  self.itemsImg = love.graphics.newImage("art/items.png")
  self.keyQuad = love.graphics.newQuad(16, 0, 16, 16, self.itemsImg:getDimensions())
  self.featherQuad = love.graphics.newQuad(32, 0, 16, 16, self.itemsImg:getDimensions())
  self.heartQuad = love.graphics.newQuad(64, 0, 16, 16, self.itemsImg:getDimensions())
  self.halfHeartQuad = love.graphics.newQuad(80, 0, 16, 16, self.itemsImg:getDimensions())
end

function UI:update() end

function UI:render()
  love.graphics.origin()

  -- Keys
  -- Buffer from edge
  local x, y = 4, 2
  for i=1, self.player.keys do
    love.graphics.draw(self.itemsImg, self.keyQuad, x, y)
    x = x + 16
  end

  -- Feather (max 1)
  local x, y = 4, 18
  if self.player.feather then
    love.graphics.draw(self.itemsImg, self.featherQuad, x, y)
  end

  -- Hearts
  heartSpaces = self.player.maxHp / 2
  heartsToDraw = self.player.hp / 2
  local x = VIRTUAL_WIDTH - 4 - (16 * heartSpaces)
  local y = 2
  for i=1, heartSpaces do
    if heartsToDraw == 0.5 then
      love.graphics.draw(self.itemsImg, self.halfHeartQuad, x, y)
      heartsToDraw = heartsToDraw - 0.5
    elseif heartsToDraw > 0.5 then
      love.graphics.draw(self.itemsImg, self.heartQuad, x, y)
      heartsToDraw = heartsToDraw - 1
    end
    x = x + 16
  end
end