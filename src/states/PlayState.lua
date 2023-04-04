-- Main game logic

PlayState = Class{__includes = BaseState}

function PlayState:init()
  -- Prep world
  self.world = bump.newWorld(quadSize)
  for _, instance in pairs(level.layerInstances) do
    if instance["__identifier"] == "collisions" then
      -- Setting these to local makes them TOO local
      collisions = instance.intGridCsv
      collisionGridWidth = instance["__cWid"]
      collisionGridHeight = instance["__cHei"]
    end
  end

  -- Prep tiles
  for _, instance in pairs(level.layerInstances) do
    if instance["__identifier"] == "tiles" then
      for i, line in pairs(instance.gridTiles) do
        local quadId = line.t
        local x, y = line.px[1], line.px[2]
        local cx, cy = x / quadSize, y / quadSize
        local collisionIndex = (cx + (cy * collisionGridWidth)) + 1
        local isWall = false
        if collisions[collisionIndex] == 1 then
          isWall = true
        else
          isWall = false
        end
        local tile = Tile(x, y, quadId, isWall)
        self.world:add(tile, x, y, quadSize, quadSize)
      end
    end

    -- For the future: you can save custom data to tilesets somehow
    local openDoorIds = {9, 10, 11, 12, 24, 25, 26, 27, 69, 70, 114, 115}

    -- Prep doors
    if instance["__identifier"] == "doors" then
      for i, line in pairs(instance.gridTiles) do
        local quadId = line.t
        local x, y = line.px[1], line.px[2]
        local cx, cy = x / quadSize, y / quadSize
        -- Remember to set all collided tiles' isWall to false on collision
        local isWall = true
        local isDoor = true
        
        for _, id in pairs(openDoorIds) do
          if quadId == id then
            isWall = false
            break
          end
        end

        local tile = Tile(x, y, quadId, isWall, isDoor)
        self.world:add(tile, x, y, quadSize, quadSize)
      end
    end

    -- Prep door tops
    if instance["__identifier"] == "door_tops" then
      for i, line in pairs(instance.gridTiles) do
        local quadId = line.t
        local x, y = line.px[1], line.px[2]
        local cx, cy = x / quadSize, y / quadSize
        local tile = Tile(x, y, quadId)
        tile.z = 11
        self.world:add(tile, x, y, quadSize, quadSize)
      end
    end
  end

  -- Prep entities
  for _, instance in pairs(level.layerInstances) do
    if instance["__identifier"] == "entities" then
      for _, entity in pairs(instance["entityInstances"]) do
        local x, y = entity.px[1], entity.px[2]
        local width = entity["width"]
        local height = entity["height"]
        if entity["__identifier"] == "key" then
          self.world:add(Key(x, y), x, y, quadSize, quadSize)
        elseif entity["__identifier"] == "feather" then
          self.world:add(Feather(x, y), x, y, quadSize, quadSize)
        elseif entity["__identifier"] == "key_check_zone" then
          self.world:add(KeyCheckZone("key"), x, y, width, height)
        elseif entity["__identifier"] == "feather_check_zone" then
          self.world:add(KeyCheckZone("feather"), x, y, width, height)
        elseif entity["__identifier"] == "egg" then
          self.world:add(Egg(x, y, self.world), x, y, width, height)
        end
      end
    end
  end 

  -- Prep player, camera, UI
  self.player = Player(184, 968, self.world)
  self.world:add(self.player, self.player.x, self.player.y, quadSize, quadSize)
  self.camera = Camera(self.player)
  self.ui = UI(self.player)

  -- Setting a background color doesn't work
  -- self.red, self.green, self.blue = hex2rgb(level["bgColor"])
  -- print(level["bgColor"])
  -- print(self.red, self.green, self.blue)
end

function PlayState:update(dt)
  -- Lots of stuff happening in here, see PlayerWalkState for the bulk of it
  self.player:update(dt)

  -- Game over placeholder
  if love.keyboard.wasPressed("y") then
    stateStacc:pop()
    stateStacc:push(PlayState())
    stateStacc:push(GameOverState())
  end

  if love.keyboard.wasPressed("r") then
    stateStacc:pop()
    stateStacc:push(PlayState())
  end

  self.camera:update()
end

function PlayState:render()
  -- Stays black for some reason
  -- love.graphics.setBackgroundColor(self.red, self.green, self.blue, 1)
  
  self.camera:render()
  -- Items get rendered from lowest to highest z-index
  for _, item in pairs(sortByZ(self.world:getItems())) do
    item:render()
  end
  self.ui:render()
end