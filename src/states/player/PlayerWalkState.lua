PlayerWalkState = Class{__includes = BaseState}

function PlayerWalkState:init(player, world)
  self.player = player
  self.world = world
  self.direction = down
  self.img = {
    ["up"] = love.graphics.newImage("art/player-walk-up"),
    ["down"] = love.graphics.newImage("art/player-walk-down"),
    ["left"] = love.graphics.newImage("art/player-walk-left"),
    ["right"] = love.graphics.newImage("art/player-walk-right")
  }
  local grid = anim8.newGrid(32, 32, img.up:getWidth(), img.up:getHeight())
  local dg = anim8.newGrid(32, 32, img.down:getWidth(), img.down:getHeight())
  local lg = anim8.newGrid(32, 32, img.left:getWidth(), img.left:getHeight())
  local rg = anim8.newGrid(32, 32, img.right:getWidth(), img.right:getHeight())
  self.animations = {
    ["up"] = anim8.newAnimation(ug('1-4',1), 0.1),
    ["down"] = anim8.newAnimation(dg('1-4',1), 0.1),
    ["left"] = anim8.newAnimation(lg('1-4',1), 0.1),
    ["right"] = anim8.newAnimation(rg('1-4',1), 0.1)
  }
  self.animation = self.animations.down
end

function PlayerWalkState:update(dt)
  local cols, len = {}, 0
  self.animation:resume()
  if love.keyboard.isDown("w") then
    self.player.x, self.player.y, cols, len = self.world:move(
      self.player, 
      self.player.x, 
      self.player.y - dt * self.player.speed,
      playerFilter
    )
    self.direction = "up"
    self.animation = self.animations.up
  elseif love.keyboard.isDown("a") then
    self.player.x, self.player.y, cols, len = self.world:move(
      self.player, 
      self.player.x - dt * self.player.speed, 
      self.player.y,
      playerFilter
    )
    self.direction = "left"
    self.animation = self.animations.left
  elseif love.keyboard.isDown("s") then
    self.player.x, self.player.y, cols, len = self.world:move(
      self.player, 
      self.player.x, 
      self.player.y + dt * self.player.speed,
      playerFilter
    )
    self.direction = "down"
    self.animation = self.animations.down
  elseif love.keyboard.isDown("d") then
    self.player.x, self.player.y, cols, len = self.world:move(
      self.player, 
      self.player.x + dt * self.player.speed, 
      self.player.y,
      playerFilter
    )
    self.direction = "right"
    self.animation = self.animations.right
  else
    self.animation:pause()
  end

  self.animation:update(dt)

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
  self.animation:draw(self.img[self.direction], self.x, self.y)
end

function PlayerWalkState:changeAnimation(dt, newDirection)
  local animToUpdate = nil
  if self.newDirection == "up" then
    animToUpdate = self.upAnimation
  elseif self.newDirection == "down" then
    animToUpdate = self.downAnimation
  elseif self.newDirection == "left" then
    animToUpdate = self.leftAnimation
  elseif self.newDirection == "right" then
    animToUpdate = self.rightAnimation
  end

  if self.direction == newDirection then
    animToUpdate:update(dt)
  else
    self.direction = newDirection
    self

end