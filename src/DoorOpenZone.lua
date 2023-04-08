
DoorOpenZone = Class{}

function DoorOpenZone:init(x, y, width, height)
  self.x = x
  self.y = y
  self.w = width
  self.h = height
  -- Needed for sort function
  self.z = 0
  self.isDoorOpenZone = true
end

function DoorOpenZone:update() end

function DoorOpenZone:render() end