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
    love.graphics.translate(-math.floor(self.x), -math.floor(self.y))
end