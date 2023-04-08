PlayerAttackState = Class{__includes = BaseState}

function PlayerAttackState:init(player, world, direction)
  self.player = player
  self.world = world
  self.hitbox = none
  self.animComplete = false

  self.img = {
    ["up"] = love.graphics.newImage("art/player-attack-up.png"),
    ["down"] = love.graphics.newImage("art/player-attack-down.png"),
    ["left"] = love.graphics.newImage("art/player-attack-left.png"),
    ["right"] = love.graphics.newImage("art/player-attack-right.png")
  }
  local grids = {
    ["up"] = anim8.newGrid(
      16, 32, self.img.up:getWidth(), self.img.up:getHeight()),
    ["down"] = anim8.newGrid(
      16, 32, self.img.down:getWidth(), self.img.down:getHeight()),
    ["left"] = anim8.newGrid(
      32, 16, self.img.left:getWidth(), self.img.left:getHeight()),
    ["right"] = anim8.newGrid(
      32, 16, self.img.right:getWidth(), self.img.right:getHeight())
  }
  self.animations = {
    ["up"] = anim8.newAnimation(grids.up('1-4',1), 0.1),
    ["down"] = anim8.newAnimation(grids.down('1-4',1), 0.1),
    ["left"] = anim8.newAnimation(grids.left('1-4',1), 0.1),
    ["right"] = anim8.newAnimation(grids.right('1-4',1), 0.1)
  }
end

function PlayerAttackState:enter(direction)
  self.direction = direction
  self.animComplete = false
  self.animation = self.animations[self.direction]
  self.animation:gotoFrame(1)
end

function PlayerAttackState:exit()
  -- Remove hitbox from world and self
  self.world:remove(self.hitbox)
  self.hitbox = none
end

function PlayerAttackState:update(dt)
  self.animation:update(dt)
  
  if self.animation.position == 1 and self.animComplete then
    self.player.stateMachine:change("walk", self.direction)
  end

  -- Add hitbox to world on frame 2
  if self.animation.position == 2 and not self.hitbox then
    self.hitbox = Hitbox(0, 0, 16, 16)
    if self.direction == "up" then
      self.hitbox.x = self.player.x
      self.hitbox.y = self.player.y - self.player.height
    elseif self.direction == "down" then
      self.hitbox.x = self.player.x
      self.hitbox.y = self.player.y + self.player.height
    elseif self.direction == "left" then
      self.hitbox.x = self.player.x - self.player.width
      self.hitbox.y = self.player.y
    elseif self.direction == "right" then
      self.hitbox.x = self.player.x + self.player.width
      self.hitbox.y = self.player.y
    end
    self.world:add(self.hitbox, self.hitbox.x, self.hitbox.y, 
      self.hitbox.width, self.hitbox.height)
  end
  
  if self.hitbox then
    -- This "moves" the hitbox to where it already is to detect collisions
    _, _, cols, len = self.world:move(
      self.hitbox, self.hitbox.x, self.hitbox.y, hitboxFilter)

    for i=1, len do
      local other = cols[i].other
      
      if other.isKey then
        self.player.keys = self.player.keys + 1
        self.world:remove(other)
      elseif other.isFeather then
        self.player.feather = true
        self.world:remove(other)
      elseif other.isHeart then
        self.player.hp = self.player.hp + 2
        self.world:remove(other)
      elseif other.isHeartContainer then
        self.player.maxHp = self.player.maxHp + 2
        self.player.hp = self.player.hp + 2
        self.world:remove(other)
      elseif other.isEgg then
        other:takeDamage(1)
      elseif other.isBoss then
        other:takeDamage(1)
      end
    end
  end

  -- Check if an egg collides with player during player's attack animation
  _, _, cols, len = self.world:move(
    self.player, self.player.x, self.player.y, playerFilter)

  for i=1, len do
    local other = cols[i].other
    
    if other.isEgg then
      self.player:takeDamage(1)
    elseif other.isBoss then
      self.player:takeDamage(1)
    end
  end

  
end

function PlayerAttackState:render()
  local xOffset = {
    ["up"] = 0,
    ["down"] = 0,
    ["left"] = -16,
    ["right"] = 0
  }
  local yOffset = {
    ["up"] = -16,
    ["down"] = 0,
    ["left"] = 0,
    ["right"] = 0
  }
  -- Add offset depending on direction
  local x = self.player.x + xOffset[self.direction]
  local y = self.player.y + yOffset[self.direction]
  self.animation:draw(self.img[self.direction], x, y)

  -- If last frame, change state
  if self.animation.position == #self.animation.frames then
    self.animComplete = true
  end
end