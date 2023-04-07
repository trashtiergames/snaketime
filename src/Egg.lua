Egg = Class{}

function Egg:init(x, y, world)
  self.x = x
  self.y = y
  self.z = 9
  self.height = 16
  self.width = 16
  self.speed = 50
  self.attackTimer = 0
  self.attackWaitAmount = 3
  self.world = world
  self.isEgg = true
  self.hp = 1

  self.stateMachine = StateMachine {
    ["idle"] = EggIdleState(self, self.world),
    ["walk"] = EggWalkState(self, self.world),
    ["roll"] = EggRollState(self, self.world)
  }
  
  self.stateMachine:change("idle")
end

function Egg:update(dt)
  self.attackTimer = self.attackTimer + dt
  if self.attackTimer > self.attackWaitAmount then
    -- Check if player in range above or below (two tiles)
    local items, _ = self.world:queryRect(self.x, self.y - 32, 16, 80)
    for _, item in pairs(items) do
      if item.isPlayer then
        if item.y < self.y then
          self.stateMachine:change("roll", "up")
        elseif item.y > self.y then
          self.stateMachine:change("roll", "down")
        end
      end
    end

    -- Check if player in range above or below (two tiles)
    local items, _ = self.world:queryRect(self.x - 32, self.y, 80, 16)
    for _, item in pairs(items) do
      if item.isPlayer then
        if item.x < self.x then
          self.stateMachine:change("roll", "left")
        elseif item.x > self.x then
          self.stateMachine:change("roll", "right")
        end
      end
    end
  end
  self.stateMachine:update(dt)
end

function Egg:render()
  self.stateMachine:render()
end

function Egg:takeDamage(amount)
  self.hp = self.hp - amount
  if self.hp < 1 then
    self.world:remove(self)
  end
end