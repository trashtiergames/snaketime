PlayerAttackState = Class{__includes = BaseState}

function PlayerAttackState:init(player, world, direction)
  self.player = player
  self.world = world

  self.img = {
    ["up"] = love.graphics.newImage("art/player-attack-up.png"),
    ["down"] = love.graphics.newImage("art/player-attack-down.png"),
    ["left"] = love.graphics.newImage("art/player-attack-left.png"),
    ["right"] = love.graphics.newImage("art/player-attack-right.png")
  }
  local grids = {
    ["up"] = anim8.newGrid(
      16, 32, self.img.up:getWidth(), self.img.up:getHeight()),
    ["down"] = anim8.newGrid(
      16, 32, self.img.down:getWidth(), self.img.down:getHeight()),
    ["left"] = anim8.newGrid(
      32, 16, self.img.left:getWidth(), self.img.left:getHeight()),
    ["right"] = anim8.newGrid(
      32, 16, self.img.right:getWidth(), self.img.right:getHeight())
  }
  self.animations = {
    ["up"] = anim8.newAnimation(grids.up('1-4',1), 0.1),
    ["down"] = anim8.newAnimation(grids.down('1-4',1), 0.1),
    ["left"] = anim8.newAnimation(grids.left('1-4',1), 0.1),
    ["right"] = anim8.newAnimation(grids.right('1-4',1), 0.1)
  }
end

function PlayerAttackState:enter(direction)
  self.direction = direction
  self.animation = self.animations[self.direction]
  self.animation:gotoFrame(1)
end

function PlayerAttackState:update(dt)
  self.animation:update(dt)
end

function PlayerAttackState:render()
  local xOffset = {
    ["up"] = 0,
    ["down"] = 0,
    ["left"] = -16,
    ["right"] = 0
  }
  local yOffset = {
    ["up"] = -16,
    ["down"] = 0,
    ["left"] = 0,
    ["right"] = 0
  }

  -- If last frame, change state
  if self.animation.position == #self.animation.frames then
    local params = {self.player, self.world, self.direction}
    self.player.stateMachine:change("walk", params)
  end

  -- Add offset depending on direction
  local x = self.player.x + xOffset[self.direction]
  local y = self.player.y + yOffset[self.direction]
  self.animation:draw(self.img[self.direction], x, y)
end