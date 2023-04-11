-- Manage idle state, switching back and forth between walking and attacking

EggIdleState = Class{__includes = BaseState}

function EggIdleState:init(egg, world)
  self.egg = egg
  self.world = world
  self.direction = "down"
  -- Animations are solved in a slightly odd way because I saved each direction
  -- as an individual file.
  self.img = love.graphics.newImage("art/egg-idle.png")
  self.quads = {
    ["up"] = love.graphics.newQuad(16, 0, 16, 16, self.img),
    ["down"] = love.graphics.newQuad(0, 0, 16, 16, self.img),
    ["left"] = love.graphics.newQuad(32, 0, 16, 16, self.img),
    ["right"] = love.graphics.newQuad(48, 0, 16, 16, self.img)
  }
end

function EggIdleState:enter(direction)
  -- Stand idly for a random amount of seconds
  self.moveTimer = 0
  self.moveDuration = math.random(5)
  if direction then
    self.quad = self.quads[direction]
  else
    self.quad = self.quads.down
  end
end

function EggIdleState:update(dt)
  -- If timne is up, walk again
  self.moveTimer = self.moveTimer + dt
  if self.moveTimer > self.moveDuration then
    self.moveTimer = 0
    self.egg.stateMachine:change("walk", DIRECTIONS[math.random(4)])
  end
end

function EggIdleState:render()
  love.graphics.draw(self.img, self.quad, self.egg.x, self.egg.y)
end