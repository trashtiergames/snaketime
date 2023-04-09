Egg = Class{}

function Egg:init(x, y, world, eggList)
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
  self.hp = 2
  self.eggs = eggList

  -- Variables for being invulnerable after a hit (taken from CS50G code by
  -- Colton Ogden, cogden@cs50.harvard.edu)
  self.invulnerable = false
  self.invulnerableDuration = 0
  self.invulnerableTimer = 0
  self.flashTimer = 0

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

function Egg:render()
  if self.invulnerable and self.flashTimer > 0.06 then
    self.flashTimer = 0
    love.graphics.setColor(1, 1, 1, 64/255)
  end
  self.stateMachine:render()
  love.graphics.setColor(1, 1, 1, 1)
end

-- Taken from CS50G code by Colton Ogden, cogden@cs50.harvard.edu
function Egg:goInvulnerable(duration)
  self.invulnerable = true
  self.invulnerableDuration = duration
end

function Egg:takeDamage(amount)
  if self.invulnerable then
    return
  end
  sounds["hit"]:play()
  self.hp = self.hp - amount
  self:goInvulnerable(1)
  if self.hp < 1 then
    self.world:remove(self)

    -- Complicated way needed to remove specific item from table
    local idToRemove
    for i, egg in ipairs(self.eggs) do 
      if egg == self then
        idToRemove = i
      end
    end
    table.remove(self.eggs, i)
  end
end