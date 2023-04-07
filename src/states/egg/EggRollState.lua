EggRollState = Class{__includes = BaseState}

function EggRollState:init(egg, world)
  self.egg = egg
  self.world = world
  self.animComplete = false

  self.img = {
    ["up"] = love.graphics.newImage("art/egg-attack-up.png"),
    ["down"] = love.graphics.newImage("art/egg-attack-down.png"),
    ["left"] = love.graphics.newImage("art/egg-attack-left.png"),
    ["right"] = love.graphics.newImage("art/egg-attack-right.png")
  }
  local grids = {
    ["up"] = anim8.newGrid(
      16, 16, self.img.up:getWidth(), self.img.up:getHeight()),
    ["down"] = anim8.newGrid(
      16, 16, self.img.down:getWidth(), self.img.down:getHeight()),
    ["left"] = anim8.newGrid(
      16, 16, self.img.left:getWidth(), self.img.left:getHeight()),
    ["right"] = anim8.newGrid(
      16, 16, self.img.right:getWidth(), self.img.right:getHeight())
  }
  self.animations = {
    ["up"] = anim8.newAnimation(grids.up('1-8',1), 0.1),
    ["down"] = anim8.newAnimation(grids.down('1-8',1), 0.1),
    ["left"] = anim8.newAnimation(grids.left('1-8',1), 0.1),
    ["right"] = anim8.newAnimation(grids.right('1-8',1), 0.1)
  }
end

function EggRollState:enter(direction)
  self.direction = direction
  self.animation = self.animations[self.direction]
  self.animComplete = false
  self.egg.attackTimer = 0
  self.animation:gotoFrame(1)
end

function EggRollState:exit()
  -- -- Remove hitbox from world and self
  -- self.world:remove(self.hitbox)
  -- self.hitbox = none
end

function EggRollState:update(dt)
  -- Change state if egg is about to restart roll anim
  if self.animation.position == #self.animation.frames and self.animComplete then
    self.egg.attackTimer = 0
    self.egg.stateMachine:change("idle", DIRECTIONS[math.random(4)])
  end
  self.animation:update(dt)
  if self.animation.position > 5 then
    if self.direction == "up" then
      self.egg.x, self.egg.y, cols, len = self.world:move(
        self.egg, 
        self.egg.x, 
        self.egg.y - dt * self.egg.speed * 2,
        eggFilter
      )
    elseif self.direction == "left" then
      self.egg.x, self.egg.y, cols, len = self.world:move(
        self.egg, 
        self.egg.x - dt * self.egg.speed * 2, 
        self.egg.y,
        eggFilter
      )
    elseif self.direction == "down" then
      self.egg.x, self.egg.y, cols, len = self.world:move(
        self.egg, 
        self.egg.x, 
        self.egg.y + dt * self.egg.speed * 2,
        eggFilter
      )
    elseif self.direction == "right" then
      self.egg.x, self.egg.y, cols, len = self.world:move(
        self.egg, 
        self.egg.x + dt * self.egg.speed * 2, 
        self.egg.y,
        eggFilter
      )
    end
  end
end

function EggRollState:render()
  self.animation:draw(self.img[self.direction], self.egg.x, self.egg.y)

  -- If last frame, change state
  if self.animation.position == #self.animation.frames then
    self.animComplete = true
  end
end