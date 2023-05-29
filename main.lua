-- This main script for the game snaketime loads all the assets as well as 
-- the level, and initializes the game with play and title states.

require "src/dependencies"

function love.load()
  math.randomseed(os.time())

  -- Prepare window
  love.window.setTitle("Snaketime")
  love.graphics.setDefaultFilter("nearest", "nearest")
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
  local ldtkJson = love.filesystem.read("game-3.ldtk")
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
  basic = love.graphics.newFont("fonts/font.ttf", 8)
  love.graphics.setFont(basic)

  -- Load audio
  titleTheme = love.audio.newSource("audio/title.wav", "static")
  sounds = {
    ["bchh"] = love.audio.newSource("audio/bchh.wav", "static"),
    ["bchuich"] = love.audio.newSource("audio/bchuich.wav", "static"),
    ["blooip"] = love.audio.newSource("audio/blooip.wav", "static"),
    ["ding"] = love.audio.newSource("audio/ding.wav", "static"),
    ["hit"] = love.audio.newSource("audio/hit.wav", "static"),
    ["honk"] = love.audio.newSource("audio/honk.mp3", "static"),
    ["hurt"] = love.audio.newSource("audio/hurt.wav", "static")
  }

  stateStacc = StateStack()
  stateStacc:push(PlayState())
  stateStacc:push(TitleState())

  DIRECTIONS = {"up", "down", "left", "right"}

  love.keyboard.keysPressed = {}
end

function love.keypressed(key)
  if key == "escape" then
      love.event.quit()
  end

  love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
  -- This allows us to check in update() if a key was pressed last frame
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