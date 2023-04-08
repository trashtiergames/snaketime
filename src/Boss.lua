Boss = Class{}

function Boss:init(x, y, world)
  self.x = x
  self.y = y
  self.z = 9
  self.height = 32
  self.width = 32
  self.speed = 50
  self.attackTimer = 0
  self.attackWaitAmount = 3
  self.world = world
  self.isBoss = true
  self.phase = 1
  self.hp = 1

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
  if self.attackTimer > self.attackWaitAmount then
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

    -- Check if player in range above or below (two tiles)
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
  self.stateMachine:update(dt)
end

function Boss:render()
  self.stateMachine:render()
end

function Boss:takeDamage(amount)
  self.hp = self.hp - amount
  if self.hp < 1 then
    self.world:remove(self)
  end
end