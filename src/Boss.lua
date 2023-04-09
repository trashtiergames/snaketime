Boss = Class{}

function Boss:init(x, y, world, playState)
  self.x = x
  self.y = y
  self.z = 9
  self.height = 32
  self.width = 32
  self.speed = 50
  self.attackTimer = 0
  self.attackWaitAmount = 3
  self.world = world
  self.playState = playState
  self.isBoss = true
  self.isScanning = true
  self.phase = 1
  self.hp = 5
  self.active = false

  -- Variables for being invulnerable after a hit (taken from CS50G code by
  -- Colton Ogden, cogden@cs50.harvard.edu)
  self.invulnerable = false
  self.invulnerableDuration = 0
  self.invulnerableTimer = 0
  self.flashTimer = 0

  self.stateMachine = StateMachine {
    ["idle-1"] = Boss1IdleState(self, self.world),
    ["walk-1"] = Boss1WalkState(self, self.world),
    ["attack-1"] = Boss1AttackState(self, self.world),
    ["transform"] = BossTransformState(self, self.world),
    ["idle-2"] = Boss2IdleState(self, self.world),
    ["walk-2"] = Boss2WalkState(self, self.world),
    ["attack-2"] = Boss2AttackState(self, self.world),
    ["wind-up"] = BossWindUpState(self, self.world),
    ["wind-down"] = BossWindDownState(self, self.world),
  }
  
  self.stateMachine:change("idle-1", "down")
end

function Boss:update(dt)
  self.attackTimer = self.attackTimer + dt
  if self.attackTimer > self.attackWaitAmount and self.isScanning then
    if self.phase == 1 then
      -- Check if player in range above or below (two tiles)
      local items, _ = self.world:queryRect(self.x, self.y - 32, 32, 80)
      for _, item in pairs(items) do
        if item.isPlayer then
          if item.y < self.y then
            self.stateMachine:change("attack-1", "up")
          elseif item.y > self.y then
            self.stateMachine:change("attack-1", "down")
          end
        end
      end

      -- Check if player in range left or right (two tiles)
      local items, _ = self.world:queryRect(self.x - 32, self.y, 80, 32)
      for _, item in pairs(items) do
        if item.isPlayer then
          if item.x < self.x then
            self.stateMachine:change("attack-1", "left")
          elseif item.x > self.x then
            self.stateMachine:change("attack-1", "right")
          end
        end
      end
    end
  end

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

function Boss:render()
  if self.flashTimer > 0.06 then
    self.flashTimer = 0
    love.graphics.setColor(1, 1, 1, 64/255)
  end
  self.stateMachine:render()
  love.graphics.setColor(1, 1, 1, 1)
end

-- Taken from CS50G code by Colton Ogden, cogden@cs50.harvard.edu
function Boss:goInvulnerable(duration)
  self.invulnerable = true
  self.invulnerableDuration = duration
end

function Boss:takeDamage(amount)
  if self.invulnerable then
    return
  end
  self.hp = self.hp - amount
  self:goInvulnerable(1)
  if self.hp < 1 and self.phase == 1 then
    self.hp = 3
    self.stateMachine:change("transform")
  elseif self.hp < 1 and self.phase == 2 then
    self.playState.bossBeaten = true
    self.world:remove(self)
  end
end