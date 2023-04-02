Player = Class{}

function Player:init(x, y, world)
  self.x = x
  self.y = y
  self.z = 10
  self.height = 16
  self.width = 16
  self.speed = 50
  self.world = world

  self.keys = 0
  self.feather = false

  -- self.stateMachine = StateMachine {
  --     ["walk"] = function() return PlayerWalkState(self, self.world) end,
  --     ["attack"] = function() return PlayerAttackState(self, self.world) end
  -- }

  -- We now pass states instead of functions into the statemachine
  self.stateMachine = StateMachine({
    ["walk"] = PlayerWalkState(self, self.world),
    ["attack"] = PlayerAttackState(self, self.world)
  })
  
  self.stateMachine:change("walk")
end

function Player:update(dt)
  self.stateMachine:update(dt)
end

function Player:render()
  self.stateMachine:render()
end