BossTransformState = Class{__includes = BaseState}

function BossTransformState:init(boss, world)
  self.boss = boss
  self.world = world

  self.img = love.graphics.newImage("art/boss/boss-transform.png")
  local grid = anim8.newGrid(32, 32, self.img:getWidth(), self.img:getHeight())
  self.animation = anim8.newAnimation(grid('1-45',1), 0.2)
  self.animComplete = false
end

function BossTransformState:enter(diection)
  self.animation:gotoFrame(1)
  self.animComplete = false
  self.boss.isBoss = false
  self.boss.isScanning = false
end

function BossTransformState:update(dt)
  if self.animation.position == 1 and self.animComplete then
    self.boss.phase = 2
    self.boss.isBoss = true
    self.boss.isScanning = true
    self.boss.stateMachine:change("idle-2", "down")
  end
  self.animation:update(dt)
end

function BossTransformState:render()
  -- If last frame, change state
  if self.animation.position == #self.animation.frames then
    self.animComplete = true
  end

  self.animation:draw(self.img, self.boss.x, self.boss.y)
end