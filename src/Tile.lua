-- Saves infos about tiles of the level

Tile = Class{}

function Tile:init(x, y, quadId, isWall, isDoor, isOpen)
  self.x = x
  self.y = y
  self.z = 1
  self.quadId = quadId
  -- Init isWall if you get one, set to false otherwise
  self.isWall = isWall or false
  self.isDoor = isDoor or false
  if self.isDoor then
    self.z = 2
  end
end

function Tile:render()
  love.graphics.draw(tileset, quads[self.quadId], self.x, self.y)
end

function Tile:openDoor()

end
