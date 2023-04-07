Class = require "libraries/class"
push = require "libraries/push"
json = require "libraries/json"
bump = require "libraries/bump"
anim8 = require "libraries/anim8"
require "src/helpers"
require "src/Tile"
require "src/Key"
require "src/Feather"
require "src/Player"
require "src/Egg"
require "src/Camera"
require "src/UI"
require "src/filters"
require "src/KeyCheckZone"
require "src/Hitbox"
require "src/states/StateStack"
require "src/states/StateMachine"
require "src/states/BaseState"
require "src/states/PlayState"
require "src/states/TitleState"
require "src/states/GameOverState"
require "src/states/player/PlayerWalkState"
require "src/states/player/PlayerAttackState"
require "src/states/egg/EggIdleState"
require "src/states/egg/EggWalkState"
require "src/states/egg/EggRollState"

function love.load()
  math.randomseed(os.time())

  -- Prepare window
  love.window.setTitle('Game 3')
  love.graphics.setDefaultFilter('nearest', 'nearest')
  VIRTUAL_WIDTH = 256
  VIRTUAL_HEIGHT = 160
  windowWidth, windowHeight = love.window.getDesktopDimensions()

  push:setupScreen(
      VIRTUAL_WIDTH, 
      VIRTUAL_HEIGHT, 
      windowWidth, 
      windowHeight, 
      {fullscreen = true}
  )

  -- Load LDtk level data
  local ldtkFile = io.open("game-3.ldtk", "r")
  local ldtkJson = ldtkFile:read("a")
  ldtkFile:close()
  ldtk = json.decode(ldtkJson)
  level = ldtk.levels[1]

  -- Load art
  tilesetPath = ldtk.defs.tilesets[1].relPath
  tileset = love.graphics.newImage(tilesetPath, settings)
  quads = {}
  atlasGridWidth = ldtk.defs.tilesets[1]["__cWid"]
  atlasGridHeight = ldtk.defs.tilesets[1]["__cHei"]
  quadSize = ldtk.defs.tilesets[1].tileGridSize
  -- Should import quads to be loaded like so:
  -- quads[0] = top left tile in spritesheet
  quads = generateQuads(tileset, quadSize, quadSize)

  -- Load font
  silkscreen = love.graphics.newFont('fonts/Silkscreen-Regular.ttf', 8)
  basic = love.graphics.newFont('fonts/font.ttf', 8)
  love.graphics.setFont(basic)

  stateStacc = StateStack()
  stateStacc:push(PlayState())
  stateStacc:push(TitleState())

  DIRECTIONS = {"up", "down", "left", "right"}

  love.keyboard.keysPressed = {}
end

function love.keypressed(key)
  if key == 'escape' then
      love.event.quit()
  end

  love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
  return love.keyboard.keysPressed[key]
end

function love.update(dt)
  stateStacc:update(dt)
  love.keyboard.keysPressed = {}
end

function love.draw()
  push:start()
  stateStacc:render()
  push:finish()
end