-- Manages player walk behavior, which is active most of the game

PlayerWalkState = Class{__includes = BaseState}

function PlayerWalkState:init(player, world)
  self.player = player
  self.world = world
  self.direction = "down"
  -- Animations are solved in a slightly odd way because I saved each direction
  -- as an individual file
  self.img = {
    ["up"] = love.graphics.newImage("art/player-walk-up.png"),
    ["down"] = love.graphics.newImage("art/player-walk-down.png"),
    ["left"] = love.graphics.newImage("art/player-walk-left.png"),
    ["right"] = love.graphics.newImage("art/player-walk-right.png")
  }
  local grid = anim8.newGrid(16, 16, self.img.up:getWidth(), self.img.up:getHeight())
  self.animations = {
    ["up"] = anim8.newAnimation(grid("1-4",1), 0.07),
    ["down"] = anim8.newAnimation(grid("1-4",1), 0.07),
    ["left"] = anim8.newAnimation(grid("1-4",1), 0.07),
    ["right"] = anim8.newAnimation(grid("1-4",1), 0.07)
  }
  self.animation = self.animations[self.direction]
end

function PlayerWalkState:enter(direction)
  self.direction = direction
  self.animation = self.animations[self.direction]
  self.animation:gotoFrame(1)
end

function PlayerWalkState:update(dt)
  local cols, len = {}, 0
  -- We might have stopped if no key was pressed before
  self.animation:resume()

  -- "Move" the player if button was pressed. The player filter makes it so 
  -- that the player will bump into walls and go over certain other items
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
    -- Still check if anything walks into player even if standing still
    _, _, cols, len = self.world:move(
      self.player, self.player.x, self.player.y, playerFilter)
  end

  if love.keyboard.isDown("space") then
    self.player.stateMachine:change("attack", self.direction)
  end
  
  self.animation:update(dt)

  -- Resolve collisions with things other than walls
  local playerHasKey = self.player.keys > 0

  for i=1, len do
    local other = cols[i].other
    
    -- Pick up items if colliding with them
    if other.isKey then
      self.player.keys = self.player.keys + 1
      self.world:remove(other)
      sounds["ding"]:play()

    elseif other.isFeather then
      self.player.feather = true
      self.world:remove(other)
      sounds["ding"]:play()

    elseif other.isHeartContainer then
      self.player.maxHp = self.player.maxHp + 2
      self.player.hp = self.player.hp + 2
      self.world:remove(other)
      sounds["blooip"]:play()

    elseif other.isHeart then
      self.player.hp = self.player.hp + 2
      self.world:remove(other)
      sounds["blooip"]:play()

    elseif other.isEgg then
      self.player:takeDamage(1)

    elseif other.isBoss then
      self.player:takeDamage(1)

    -- On key check zones, check for keys, open doors
    elseif other.isKeyCheckZone then
      if other.type == "key" and playerHasKey then
        sounds["bchh"]:play()
        self.player.keys = self.player.keys - 1
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
      elseif other.type == "feather" and self.player.feather then
        sounds["bchuich"]:play()
        self.player.feather = false
        local zone = cols[i].otherRect
        local items, len = self.world:queryRect(zone.x, zone.y, zone.w, zone.h)
        for _, item in pairs(items) do
          if item.isWall then
            item.isWall = false
          end
          if item.quadId then
            if item.quadId == 71 then
              item.quadId = 69
            elseif item.quadId == 72 then
              item.quadId = 70
            end
          end
        end
        self.world:remove(other)
      end

    -- On entering boss room, close its doors, activate boss
    elseif other.isEnterTriggerZone then
      sounds["bchh"]:play()
      local zonesToClose = {}
      for _, item in pairs(self.world:getItems()) do
        if item.isBoss then
          item.active = true
        elseif item.isDramaticDoorCloseZone then
          table.insert(zonesToClose, item)
          self.world:remove(item)
        elseif item.isEnterTriggerZone then
          self.world:remove(item)
        end
      end
      
      for _, zone in pairs(zonesToClose) do
        local items, _ = self.world:queryRect(zone.x, zone.y, zone.w, zone.h)
        for _, item in pairs(items) do
          if item.isWall == false then
            item.isWall = true
          end
          if item.quadId then
            if item.quadId == 9 then
              item.quadId = 84
            elseif item.quadId == 10 then
              item.quadId = 85
            elseif item.quadId == 24 then
              item.quadId = 99
            elseif item.quadId == 25 then
              item.quadId = 100
            end
          end
        end
      end
    end
  end
end

function PlayerWalkState:render()
  self.animation:draw(self.img[self.direction], self.player.x, self.player.y)
end