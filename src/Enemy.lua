Enemy = Class{}

function Enemy:init(x, y, world)
  self.x = x
  self.y = y
  self.z = 9
  self.height = 16
  self.width = 16
  self.speed = 50
  self.world = world
  self.isEnemy = true
  self.hp = 1

  -- self.stateMachine = StateMachine {
  --   ["walk"] = EnemyWalkState(self, self.world),
  --   ["attack"] = EnemyAttackState(self, self.world)
  -- }
  
  -- self.stateMachine:change("walk")
end

function Enemy:update(dt)
  if self.hp < 1 then
    -- Will this work? :o
    self.world:remove(self)
  end
  self.stateMachine:update(dt)
end

function Enemy:render()
  self.stateMachine:render()
end

function Enemy:takeDamage(amount)
  self.hp = self.hp - amount
end