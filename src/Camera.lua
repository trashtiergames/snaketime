-- Saves infos about tiles of the level

Camera = Class{}

function Camera:init(player)
  self.player = player
  self.x = player.x - 120
  self.y = player.y - 72
end

function Camera:update()
  self.x = self.player.x - 120
  self.y = self.player.y - 72
end

function Camera:render()
  -- The löve2d docs advise only translating by whole numbers.
  -- It seems to work like this as well. I suspect push.lua already takes
  -- care of the problem, so we can leave it like this.
  love.graphics.translate(-self.x, -self.y)
end