Player = Class{}

function Player:init(x, y, world)
  self.x = x
  self.y = y
  self.z = 10
  self.height = 16
  self.width = 16
  self.speed = 50
  self.world = world
  self.hp = 6
  self.maxHp = 6
  self.isPlayer = true

  self.keys = 0
  self.feather = false

  -- Variables for being invulnerable after a hit (taken from CS50G code by
  -- Colton Ogden, cogden@cs50.harvard.edu)
  self.invulnerable = false
  self.invulnerableDuration = 0
  self.invulnerableTimer = 0
  self.flashTimer = 0

  self.stateMachine = StateMachine({
    ["walk"] = PlayerWalkState(self, self.world),
    ["attack"] = PlayerAttackState(self, self.world)
  })
  
  self.stateMachine:change("walk", "down")
end

function Player:update(dt)
  if self.invulnerable then
    self.flashTimer = self.flashTimer + dt
    self.invulnerableTimer = self.invulnerableTimer + dt

    if self.invulnerableTimer > self.invulnerableDuration then
        self.invulnerable = false
        self.invulnerableTimer = 0
        self.invulnerableDuration = 0
        self.flashTimer = 0
    end
  end

  self.stateMachine:update(dt)
end

function Player:render()
  if self.invulnerable and self.flashTimer > 0.06 then
    self.flashTimer = 0
    love.graphics.setColor(1, 1, 1, 64/255)
  end
  self.stateMachine:render()
  love.graphics.setColor(1, 1, 1, 1)
end

-- Taken from CS50G code by Colton Ogden, cogden@cs50.harvard.edu
function Player:goInvulnerable(duration)
  self.invulnerable = true
  self.invulnerableDuration = duration
end

function Player:takeDamage(amount)
  self.hp = self.hp - amount
  self:goInvulnerable(1)
  if self.hp < 1 then
    stateStacc:pop()
    stateStacc:push(PlayState())
    stateStacc:push(GameOverState())
  end
end