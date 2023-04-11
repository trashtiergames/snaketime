-- If the player collides with these zones, boss room doors close
-- This gets set from LDtk data

EnterTriggerZone = Class{}

function EnterTriggerZone:init()
  -- Needed for sort function
  self.z = 0
  self.isEnterTriggerZone = true
end

-- Needed for calls from bump.world
function EnterTriggerZone:update() end
function EnterTriggerZone:render() end