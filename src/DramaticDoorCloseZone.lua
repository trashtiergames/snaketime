
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

function DramaticDoorCloseZone:update() end

function DramaticDoorCloseZone:render() end