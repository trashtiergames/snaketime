BossWindDownState = Class{__includes = BaseState}

function BossWindDownState:init(boss, world)
  self.boss = boss
  self.world = world

  self.img = love.graphics.newImage("art/boss/boss-2-attack-wind-down.png")
  local grid = anim8.newGrid(48, 48, self.img:getWidth(), self.img:getHeight())
  self.animation = anim8.newAnimation(grid('1-7',1), 0.1)
  self.animComplete = false
end

function BossWindDownState:exit()
  -- Change some details to process the smaller sprite correctly later
  self.boss.width = 32
  self.boss.height = 32
  self.boss.x = self.boss.x + 7
  self.boss.y = self.boss.y + 1
  self.boss.x, self.boss.y, _, _ = self.world:move(
    self.boss, self.boss.x, self.boss.y, bossFilter)
  self.world:update(
    self.boss, self.boss.x, self.boss.y, self.boss.width, self.boss.height)
end

function BossWindDownState:enter()
  self.animation:gotoFrame(1)
  self.animComplete = false
end

function BossWindDownState:update(dt)  
  self.animation:update(dt)

  if self.animation.position == 1 and self.animComplete then
    self.boss.stateMachine:change("idle-2", "down")
  end
end

function BossWindDownState:render()
  -- If last frame, change state
  if self.animation.position == #self.animation.frames then
    self.animComplete = true
  end

  self.animation:draw(self.img, self.boss.x, self.boss.y)
end