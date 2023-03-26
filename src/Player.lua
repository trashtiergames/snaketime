-- Saves infos about tiles of the level

Player = Class{}

function Player:init(x, y, world)
  self.x = x
  self.y = y
  self.z = 10
  self.speed = 50
  self.img = love.graphics.newImage("art/snake.png")
  self.quad = love.graphics.newQuad(0, 0, 16, 16, self.img:getDimensions())
  self.world = world

  self.keys = 0
  self.feather = false

  self.stateMachine = StateMachine {
      ['walk'] = function() return PlayerWalkState(self, self.world) end,
      ['attack'] = function() return PlayerAttackState(self, self.world) end
  }
  self.stateMachine:change("walk")
end

function Player:update(dt)
  self.stateMachine:update(dt)
end

function Player:render()
  self.stateMachine:render()
end