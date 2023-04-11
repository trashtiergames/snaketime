-- Keeps track of which doors need to be opened after eggs are beaten
-- This gets set from LDtk data

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

-- Needed for calls from bump.world
function DoorOpenZone:update() end
function DoorOpenZone:render() end