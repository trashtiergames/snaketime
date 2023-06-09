-- Manage main game logic, passing update and render calls to items in world

PlayState = Class{__includes = BaseState}

function PlayState:init()
  -- Remember enemies for later
  self.eggs = {}
  self.bossBeaten = false

  -- Prep world (quad size was loaded in main.lua)
  self.world = bump.newWorld(quadSize)

  -- Load collision grid
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
        -- If the tile is in collision grid, set it to be a wall
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
        -- Some doors start out closed
        local isWall = true
        local isDoor = true
        
        -- Some doors start out open
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

    -- Prep door tops (rendered over player to create the illusion that the
    -- player is walking through a door)
    if instance["__identifier"] == "door_tops" then
      for i, line in pairs(instance.gridTiles) do
        local quadId = line.t
        local x, y = line.px[1], line.px[2]
        local cx, cy = x / quadSize, y / quadSize
        local tile = Tile(x, y, quadId)
        -- Set z over player.z (10), so it will render after player
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

        -- Most entities simply get an object that is added to bump.world
        -- They will be accessed later through bump collision or queries
        if entity["__identifier"] == "key" then
          self.world:add(Key(x, y), x, y, quadSize, quadSize)

        elseif entity["__identifier"] == "feather" then
          self.world:add(Feather(x, y), x, y, quadSize, quadSize)

        elseif entity["__identifier"] == "heart" then
          self.world:add(Heart(x, y), x, y, quadSize, quadSize)

        elseif entity["__identifier"] == "heart_container" then
          self.world:add(HeartContainer(x, y), x, y, quadSize, quadSize)

        elseif entity["__identifier"] == "key_check_zone" then
          self.world:add(KeyCheckZone("key"), x, y, width, height)

        elseif entity["__identifier"] == "feather_check_zone" then
          self.world:add(KeyCheckZone("feather"), x, y, width, height)

        elseif entity["__identifier"] == "post_combat_door_zone" then
          self.world:add(
            DoorOpenZone(x, y, width, height),
            x, y, width, height)

        elseif entity["__identifier"] == "enter_boss_trigger" then
          self.world:add(EnterTriggerZone(), x, y, width, height)

        elseif entity["__identifier"] == "dramatic_close_doors" then
          self.world:add(
            DramaticDoorCloseZone(x, y, width, height),
            x, y, width, height)

        elseif entity["__identifier"] == "egg" then
          local egg = Egg(x, y, self.world, self.eggs)
          self.world:add(egg, x, y, width, height)
          table.insert(self.eggs, egg)

        elseif entity["__identifier"] == "boss" then
          boss = Boss(x, y, self.world, self)
          self.world:add(boss, x, y, width, height)

        end
      end
    end
  end 

  -- Prep player, camera, UI
  self.player = Player(184, 968, self.world)
  self.world:add(self.player, self.player.x, self.player.y, quadSize, quadSize)
  self.camera = Camera(self.player)
  self.ui = UI(self.player)
end

function PlayState:update(dt)
  -- Sort by z to put player last, so deleted items such as eggs don't try to 
  -- access themselves in the bump world.
  for _, item in pairs(sortByZ(self.world:getItems())) do
    item:update(dt)
  end

  -- Open doors in main hall if all eggs are beaten
  if #self.eggs == 0 then
    sounds["bchh"]:play()
    local zonesToOpen = {}
    for _, item in pairs(sortByZ(self.world:getItems())) do
      if item.isDoorOpenZone then
        table.insert(zonesToOpen, item)
      end
    end
    for _, zone in pairs(zonesToOpen) do
      local items, _ = self.world:queryRect(zone.x, zone.y, zone.w, zone.h)
      for _, item in pairs(items) do
        if item.isWall then
          item.isWall = false
        end
        if item.quadId then
          if item.quadId == 84 then
            item.quadId = 9
          elseif item.quadId == 85 then
            item.quadId = 10
          elseif item.quadId == 87 then
            item.quadId = 12
          elseif item.quadId == 102 then
            item.quadId = 27
          end
        end
      end
    end
    -- Add something to table so this loop doesn't get called again
    table.insert(self.eggs, 1)
  end

  if self.bossBeaten then
    self.world:remove(self.player)
    stateStacc:push(WinState(self.player, self.camera))
  end

  -- Reload level on r press
  if love.keyboard.wasPressed("r") then
    stateStacc:pop()
    stateStacc:push(PlayState())
  end

  self.camera:update()
end

function PlayState:render()
  self.camera:render()
  -- Items get rendered from lowest to highest z-index
  for _, item in pairs(sortByZ(self.world:getItems())) do
    item:render()
  end
  self.ui:render()
end