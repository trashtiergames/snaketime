-- Manage boss walk state in phase 1

Boss1WalkState = Class{__includes = BaseState}

function Boss1WalkState:init(boss, world)
  self.boss = boss
  self.world = world
  self.direction = "down"
  self.moveTimer = 0
  self.moveDuration = 0
  -- Animations are solved in a slightly odd way because I saved each direction
  -- as an individual file.
  self.img = {
    ["up"] = love.graphics.newImage("art/boss/boss-walk-up.png"),
    ["down"] = love.graphics.newImage("art/boss/boss-walk-down.png"),
    ["left"] = love.graphics.newImage("art/boss/boss-walk-left.png"),
    ["right"] = love.graphics.newImage("art/boss/boss-walk-right.png")
  }
  local grid = anim8.newGrid(
    32, 32, self.img.up:getWidth(), self.img.up:getHeight())
  self.animations = {
    ["up"] = anim8.newAnimation(grid('1-4',1), 0.1),
    ["down"] = anim8.newAnimation(grid('1-4',1), 0.1),
    ["left"] = anim8.newAnimation(grid('1-4',1), 0.1),
    ["right"] = anim8.newAnimation(grid('1-4',1), 0.1)
  }
  self.animation = self.animations[self.direction]
end

function Boss1WalkState:enter(direction)
  self.animation = self.animations[direction]
  self.animation:gotoFrame(1)
  self.moveTimer = 0
  self.moveDuration = math.random(5)
  self.direction = direction
end

-- Attempt to move into set diretion, colliding with walls
function Boss1WalkState:update(dt)
  if self.direction == "up" then
    self.boss.x, self.boss.y, cols, len = self.world:move(
      self.boss, 
      self.boss.x, 
      self.boss.y - dt * self.boss.speed,
      bossFilter
    )
  elseif self.direction == "left" then
    self.boss.x, self.boss.y, cols, len = self.world:move(
      self.boss, 
      self.boss.x - dt * self.boss.speed, 
      self.boss.y,
      bossFilter
    )
  elseif self.direction == "down" then
    self.boss.x, self.boss.y, cols, len = self.world:move(
      self.boss, 
      self.boss.x, 
      self.boss.y + dt * self.boss.speed,
      bossFilter
    )
  elseif self.direction == "right" then
    self.boss.x, self.boss.y, cols, len = self.world:move(
      self.boss, 
      self.boss.x + dt * self.boss.speed, 
      self.boss.y,
      bossFilter
    )
  end

  for _, col in pairs(cols) do
    if col.other.isWall then
      self.boss.stateMachine:change("walk-1", DIRECTIONS[math.random(4)])
    end
  end
  
  self.animation:update(dt)
  self.moveTimer = self.moveTimer + dt
end

function Boss1WalkState:render()
  self.animation:draw(self.img[self.direction], self.boss.x, self.boss.y)

  -- Change direction, or to idle, after a while
  if self.moveTimer > self.moveDuration then
    self.moveTimer = 0

    if math.random(2) == 2 then
      self.boss.stateMachine:change("idle-1", DIRECTIONS[math.random(4)])
    else
      self.boss.stateMachine:change("walk-1", DIRECTIONS[math.random(4)])
    end
  end
end
