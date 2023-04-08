EggWalkState = Class{__includes = BaseState}

function EggWalkState:init(egg, world)
  self.egg = egg
  self.world = world
  self.direction = "down"
  self.moveTimer = 0
  self.moveDuration = 0
  -- Animations are solved in a slightly odd way because I saved each direction
  -- as an individual file.
  self.img = {
    ["up"] = love.graphics.newImage("art/egg-walk-up.png"),
    ["down"] = love.graphics.newImage("art/egg-walk-down.png"),
    ["left"] = love.graphics.newImage("art/egg-walk-left.png"),
    ["right"] = love.graphics.newImage("art/egg-walk-right.png")
  }
  local grid = anim8.newGrid(
    16, 16, self.img.up:getWidth(), self.img.up:getHeight())
  local downGrid = anim8.newGrid(
    16, 16, self.img.down:getWidth(), self.img.down:getHeight())
  self.animations = {
    ["up"] = anim8.newAnimation(grid('1-2',1), 0.1),
    ["down"] = anim8.newAnimation(downGrid('1-3',1), 0.1),
    ["left"] = anim8.newAnimation(grid('1-2',1), 0.1),
    ["right"] = anim8.newAnimation(grid('1-2',1), 0.1)
  }
  self.animation = self.animations[self.direction]
end

function EggWalkState:enter(direction)
  self.animation = self.animations[direction]
  self.animation:gotoFrame(1)
  self.moveTimer = 0
  self.moveDuration = math.random(5)
  self.direction = direction
end

function EggWalkState:update(dt)
  if self.direction == "up" then
    self.egg.x, self.egg.y, cols, len = self.world:move(
      self.egg, 
      self.egg.x, 
      self.egg.y - dt * self.egg.speed,
      eggFilter
    )
  elseif self.direction == "left" then
    self.egg.x, self.egg.y, cols, len = self.world:move(
      self.egg, 
      self.egg.x - dt * self.egg.speed, 
      self.egg.y,
      eggFilter
    )
  elseif self.direction == "down" then
    self.egg.x, self.egg.y, cols, len = self.world:move(
      self.egg, 
      self.egg.x, 
      self.egg.y + dt * self.egg.speed,
      eggFilter
    )
  elseif self.direction == "right" then
    self.egg.x, self.egg.y, cols, len = self.world:move(
      self.egg, 
      self.egg.x + dt * self.egg.speed, 
      self.egg.y,
      eggFilter
    )
  end

  for _, col in pairs(cols) do
    if col.other.isWall then
      -- self.egg.stateMachine:change("walk", DIRECTIONS[math.random(4)])
      local oldDirection = self.direction
      while self.direction == oldDirection do
        self.direction = DIRECTIONS[math.random(4)]
        self.animation = self.animations[self.direction]
      end
    end
  end
  
  self.animation:update(dt)
  self.moveTimer = self.moveTimer + dt
end

function EggWalkState:render()
  self.animation:draw(self.img[self.direction], self.egg.x, self.egg.y)

  if self.moveTimer > self.moveDuration then
    self.moveTimer = 0

    if math.random(2) == 2 then
      self.egg.stateMachine:change("idle", DIRECTIONS[math.random(4)])
    else
      self.egg.stateMachine:change("walk", DIRECTIONS[math.random(4)])
    end
  end
end
