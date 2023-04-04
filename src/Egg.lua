Egg = Class{}

function Egg:init(x, y, world)
  self.x = x
  self.y = y
  self.z = 9
  self.height = 16
  self.width = 16
  self.speed = 50
  self.attackTimer = 0
  self.moveTimer = 0
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