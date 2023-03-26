
KeyCheckZone = Class{}

function KeyCheckZone:init(type)
    self.type = type or nil
    -- Needed for sort function
    self.z = 0
    self.isKeyCheckZone = true
end

function KeyCheckZone:render() end