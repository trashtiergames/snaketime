Boss2AttackState = Class{__includes = BaseState}

function Boss2AttackState:init(boss, world)
  self.boss = boss
  self.world = world
  self.spinTimer = 0
  self.spinLimit = 1
  self.xSpeed = 50
  self.ySpeed = 50

  self.img = love.graphics.newImage("art/boss/boss-2-attack.png")
  local grid = anim8.newGrid(48, 48, self.img:getWidth(), self.img:getHeight())
  self.animation = anim8.newAnimation(grid('1-6',1), 0.05)
end

function Boss2AttackState:enter()
  self.xSpeed = math.random(40,70)
  self.ySpeed = math.random(40,70)
  if math.random(2) == 2 then
    self.xSpeed = -self.xSpeed
  end
  if math.random(2) == 2 then
    self.ySpeed = -self.ySpeed
  end
  self.spinTimer = 0
  self.spinLimit = math.random(4, 8)
  self.animation:gotoFrame(1)
end

function Boss2AttackState:exit()
  
end

function Boss2AttackState:update(dt)
  self.spinTimer = self.spinTimer + dt
  if self.spinTimer > self.spinLimit then
    self.spinTimer = 0
    self.boss.stateMachine:change("wind-down")
  end

  self.animation:update(dt)
  self.boss.x, self.boss.y, cols, len = self.world:move(
    self.boss, 
    self.boss.x + dt * self.xSpeed, 
    self.boss.y + dt * self.ySpeed,
    bossSpinFilter
  )

  if self.animation.position == 3 then
    sounds["honk"]:stop()
    sounds["honk"]:play()
  end
  
  for i=1, len do
    local col = cols[i]
    local nx = col.normal.x
    local ny = col.normal.y

    if nx ~= 0 then
      self.xDir = nx
      self.xSpeed = -self.xSpeed
    end
    if ny ~= 0 then
      self.yDir = ny
      self.ySpeed = -self.ySpeed
    end
  end

  -- if self.xSpeed > 0 and self.xSpeed < 50 then
  --   self.xSpeed = self.xSpeed + self.xSpeed * dt
  -- elseif self.xSpeed < 0 and self.xSpeed > -50 then
  --   self.xSpeed = self.xSpeed - self.xAccel * dt
  -- end

  -- if self.ySpeed > 0 and self.ySpeed < 50 then
  --   self.ySpeed = self.ySpeed + self.ySpeed * dt
  -- elseif self.ySpeed < 0 and self.ySpeed > -50 then
  --   self.ySpeed = self.ySpeed - self.yAccel * dt
  -- end
  -- print("xSpeed:", self.xSpeed)
  -- print("ySpeed:", self.ySpeed)
end

function Boss2AttackState:render()
  self.animation:draw(self.img, self.boss.x, self.boss.y)
end