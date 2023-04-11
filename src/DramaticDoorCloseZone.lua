-- Keeps track of which doors need to be closed after player enters final 
-- boss room (and triggering the EnterTriggerZones)
-- This gets set from LDtk data

DramaticDoorCloseZone = Class{}

function DramaticDoorCloseZone:init(x, y, width, height)
  self.x = x
  self.y = y
  self.w = width
  self.h = height
  -- Needed for sort function
  self.z = 0
  self.isDramaticDoorCloseZone = true
end

-- Needed for calls from bump.world
function DramaticDoorCloseZone:update() end
function DramaticDoorCloseZone:render() end