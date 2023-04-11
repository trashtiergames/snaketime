-- Covers doors that can be opened by key, as well as the area immediately
-- in front of the door. If the player collides with the area, and has a key,
-- the door will open.
-- This gets set from LDtk data

KeyCheckZone = Class{}

function KeyCheckZone:init(type)
  self.type = type or nil
  -- Needed for sort function
  self.z = 0
  self.isKeyCheckZone = true
end

-- Needed for calls from bump.world
function KeyCheckZone:update() end
function KeyCheckZone:render() end