-- Play attack animation once, and cause damage using a hitbox

Boss1AttackState = Class{__includes = BaseState}

function Boss1AttackState:init(boss, world, direction)
  self.boss = boss
  self.world = world
  self.hitbox = none
  self.animComplete = false

  self.img = {
    ["up"] = love.graphics.newImage("art/boss/boss-attack-up.png"),
    ["down"] = love.graphics.newImage("art/boss/boss-attack-down.png"),
    ["left"] = love.graphics.newImage("art/boss/boss-attack-left.png"),
    ["right"] = love.graphics.newImage("art/boss/boss-attack-right.png")
  }
  local grids = {
    ["up"] = anim8.newGrid(
      32, 64, self.img.up:getWidth(), self.img.up:getHeight()),
    ["down"] = anim8.newGrid(
      32, 64, self.img.down:getWidth(), self.img.down:getHeight()),
    ["left"] = anim8.newGrid(
      64, 32, self.img.left:getWidth(), self.img.left:getHeight()),
    ["right"] = anim8.newGrid(
      64, 32, self.img.right:getWidth(), self.img.right:getHeight())
  }
  self.animations = {
    ["up"] = anim8.newAnimation(grids.up("1-7",1), 0.1),
    ["down"] = anim8.newAnimation(grids.down("1-7",1), 0.1),
    ["left"] = anim8.newAnimation(grids.left("1-7",1), 0.1),
    ["right"] = anim8.newAnimation(grids.right("1-7",1), 0.1)
  }
end

function Boss1AttackState:enter(direction)
  self.direction = direction
  self.animComplete = false
  self.animation = self.animations[self.direction]
  self.boss.attackTimer = 0
  self.animation:gotoFrame(1)
end

function Boss1AttackState:exit()
  -- Remove hitbox from world and self
  -- It's possible that the boss loads another attack state while scanning,
  -- so it may not have a hitbox yet
  if self.hitbox then
    self.world:remove(self.hitbox)
    self.hitbox = none
  end
end

function Boss1AttackState:update(dt)
  self.animation:update(dt)

  -- Change state if animation has just ended
  if self.animation.position == 1 and self.animComplete then
    self.boss.attackTimer = 0
    self.boss.animComplete = false
    self.boss.stateMachine:change("idle-1", self.direction)
  end

  -- Add hitbox to world on frame 3 (actually this should only trigger once)
  if self.animation.position == 3 and not self.hitbox then
    sounds["honk"]:play()
    self.hitbox = Hitbox(0, 0, 32, 32)
    if self.direction == "up" then
      self.hitbox = Hitbox(0, 0, 8, 20)
      local xOffset = (self.boss.width - self.hitbox.width) / 2
      self.hitbox.x = self.boss.x + xOffset
      self.hitbox.y = self.boss.y - self.hitbox.height
    elseif self.direction == "down" then
      self.hitbox = Hitbox(0, 0, 8, 20)
      local xOffset = (self.boss.width - self.hitbox.width) / 2
      self.hitbox.x = self.boss.x + xOffset
      self.hitbox.y = self.boss.y + self.boss.height
    elseif self.direction == "left" then
      self.hitbox = Hitbox(0, 0, 20, 8)
      local yOffset = (self.boss.height - self.hitbox.height) / 2
      self.hitbox.x = self.boss.x - self.hitbox.width
      self.hitbox.y = self.boss.y + yOffset
    elseif self.direction == "right" then
      self.hitbox = Hitbox(0, 0, 20, 8)
      local yOffset = (self.boss.height - self.hitbox.height) / 2
      self.hitbox.x = self.boss.x + self.boss.width
      self.hitbox.y = self.boss.y + yOffset
    end
    self.world:add(self.hitbox, self.hitbox.x, self.hitbox.y, 
      self.hitbox.width, self.hitbox.height)
  end
  
  if self.hitbox then
    -- "Move" the hitbox to where it already is to detect collisions
    _, _, cols, len = self.world:move(
      self.hitbox, self.hitbox.x, self.hitbox.y, boss1HitboxFilter)

    for i=1, len do
      local other = cols[i].other
      
      if other.isPlayer then
        other:takeDamage(2)
      end
    end
  end
end

function Boss1AttackState:render()
  local xOffset = {
    ["up"] = 0,
    ["down"] = 0,
    ["left"] = -32,
    ["right"] = 0
  }
  local yOffset = {
    ["up"] = -32,
    ["down"] = 0,
    ["left"] = 0,
    ["right"] = 0
  }

  -- If last frame, change state
  if self.animation.position == #self.animation.frames then
    self.animComplete = true
  end

  -- Add offset depending on direction
  local x = self.boss.x + xOffset[self.direction]
  local y = self.boss.y + yOffset[self.direction]
  self.animation:draw(self.img[self.direction], x, y)
end