-- Manage boss phase 2 idle state

Boss2IdleState = Class{__includes = BaseState}

function Boss2IdleState:init(boss, world)
  self.boss = boss
  self.world = world
  self.direction = "down"
  self.img = love.graphics.newImage("art/boss/boss-2-idle.png")
  self.quads = {
    ["up"] = love.graphics.newQuad(0, 0, 32, 32, self.img),
    ["down"] = love.graphics.newQuad(96, 0, 32, 32, self.img),
    ["left"] = love.graphics.newQuad(64, 0, 32, 32, self.img),
    ["right"] = love.graphics.newQuad(32, 0, 32, 32, self.img)
  }
end

function Boss2IdleState:enter(direction)
  self.moveTimer = 0
  self.moveDuration = math.random(4)
  if direction then
    self.quad = self.quads[direction]
  else
    self.quad = self.quads.down
  end
end

function Boss2IdleState:update(dt)
  -- After a while, change to either walk, or start attack wind up
  self.moveTimer = self.moveTimer + dt
  if self.moveTimer > self.moveDuration then
    local timerUp = self.boss.attackTimer > self.boss.attackWaitAmount
    if (math.random(2) == 2) and timerUp then
      self.boss.attackTimer = 0
      self.moveTimer = 0
      self.boss.stateMachine:change("wind-up")
    else
      self.moveTimer = 0
      self.boss.stateMachine:change("walk-2", DIRECTIONS[math.random(4)])
    end
  end
end

function Boss2IdleState:render()
  love.graphics.draw(self.img, self.quad, self.boss.x, self.boss.y)
end