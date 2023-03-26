PlayerWalkState = Class{__includes = BaseState}

function PlayerWalkState:init(player, world)
  self.player = player
  self.world = world
  self.image = love.graphics.newImage("")
  self.animation = 1
end

function PlayerWalkState:update(dt)
  local cols, len = {}, 0
  if love.keyboard.isDown("w") then
    self.player.x, self.player.y, cols, len = self.world:move(
      self.player, 
      self.player.x, 
      self.player.y - dt * self.player.speed,
      playerFilter
    )
  elseif love.keyboard.isDown("a") then
    self.player.x, self.player.y, cols, len = self.world:move(
      self.player, 
      self.player.x - dt * self.player.speed, 
      self.player.y,
      playerFilter
    )
  elseif love.keyboard.isDown("s") then
    self.player.x, self.player.y, cols, len = self.world:move(
      self.player, 
      self.player.x, 
      self.player.y + dt * self.player.speed,
      playerFilter
    )
  elseif love.keyboard.isDown("d") then
    self.player.x, self.player.y, cols, len = self.world:move(
      self.player, 
      self.player.x + dt * self.player.speed, 
      self.player.y,
      playerFilter
    )
  end


  -- Resolve collisions with things other than walls
  local playerHasKey = self.player.keys > 0

  for i=1, len do
    local other = cols[i].other
    
    if other.isKey then
      self.player.keys = self.player.keys + 1
      self.world:remove(other)
    elseif other.isFeather then
      self.player.feather = true
      self.world:remove(other)
    elseif other.isKeyCheckZone and playerHasKey then
      self.player.keys = self.player.keys - 1
      local doorOpened = true
      local zone = cols[i].otherRect
      local items, len = self.world:queryRect(zone.x, zone.y, zone.w, zone.h)
      for _, item in pairs(items) do
        if item.isWall then
          item.isWall = false
        end
        if item.quadId then
          if item.quadId == 41 then
            item.quadId = 11
          elseif item.quadId == 56 then
            item.quadId = 26
          end
        end
      end
      self.world:remove(other)
    end
  end
end

function PlayerWalkState:render()
  
end