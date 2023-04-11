<img alt="Title image" src="/readme-images/title.png?raw=true">

# Snaketime
Slither your way through a small dungeon and bettle the fearsome final boss in Snaketime. This top-down, Zelda-style LÖVE2D game is my final project for CS50’s Introduction to Game Development. If you want to play, get LÖVE2D, download this repo, and run the whole folder with “love snaketime”.

## Loading the game
<img alt="LDtk screenshot" src="/readme-images/ldtk-screen.png?raw=true">

Snaketime takes many of the concepts of week 5’s “Legend of Zelda” project, such as the basic state system for enemies, but my game also handles some aspect very differently, starting with the makeup of the levels. Snaketime is a single dungeon with pre-determined rooms, doors, enemies and items. Because this sort of level is difficult to design and create entirely in code, I opted to use [LDtk](https://ldtk.io), a 2D level editor. LDtk allows users to create levels based on tilemaps and export them to a single json file. The [structure](https://ldtk.io/json/#overview) looks something like this:   

<img alt="LDtk JSON chart" src="/readme-images/ldtk-json-chart.png?raw=true">

First, we need to open the json file (which happens to have a .ldtk ending) using a json library and extract the level, which is the first and only one in the file in this case.
```
local ldtkFile = io.open("snaketime/game-3.ldtk", "r")
local ldtkJson = ldtkFile:read("a")
ldtkFile:close()
ldtk = json.decode(ldtkJson)
level = ldtk.levels[1]
```

Then, the game can load e.g. tiles as follows:
```
-- Load collisions
for _, instance in pairs(level.layerInstances) do
  if instance["__identifier"] == "collisions" then
    collisions = instance.intGridCsv
    collisionGridWidth = instance["__cWid"]
    collisionGridHeight = instance["__cHei"]
  end
end

-- Load tiles
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
end
```
It first loads a layer of collisions, which looks like this in LDtk: 

<img alt="LDtk screenshot showing collision layer" src="/readme-images/ldtk-collisions.png?raw=true">

And looks like this in the json file:

```
"levels": [
		{
			...,
      "layerInstances": [
        {...},
        {...},
        {
          "__identifier": "collisions",
          "__type": "IntGrid",
          "__cWid": 35,
          "__cHei": 65,
          "__gridSize": 16,
          "__opacity": 0.5,
          "__pxTotalOffsetX": 0,
          "__pxTotalOffsetY": 0,
          "__tilesetDefUid": null,
          "__tilesetRelPath": null,
          "iid": "9eb185e0-9f30-11ed-a5e0-a708b3201cba",
          "levelId": 0,
          "layerDefUid": 3,
          "pxOffsetX": 0,
          "pxOffsetY": 0,
          "visible": true,
          "optionalRules": [],
          "intGridCsv": [
            0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
            0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
            0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,
            0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,
            0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,
            0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,
            0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,
            0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,
            
            ...
```

And then it iterates over the list of tiles of the level, which look like this in LDtk:

<img alt="LDtk screenshot showing tiles layer" src="/readme-images/ldtk-tiles.png?raw=true">

And like this in code:

```
"levels": [
		{
			...,
      "layerInstances": [
        {...},
        {...},
        {...},
        {
					"__identifier": "tiles",
					"__type": "Tiles",
					"__cWid": 35,
					"__cHei": 65,
					"__gridSize": 16,
					...,
					"gridTiles": [
						{ "px": [288,16], "src": [0,0], "f": 0, "t": 0, "d": [53] },
						{ "px": [304,16], "src": [16,0], "f": 0, "t": 1, "d": [54] },
						{ "px": [320,16], "src": [16,0], "f": 0, "t": 1, "d": [55] },
						{ "px": [336,16], "src": [16,0], "f": 0, "t": 1, "d": [56] },
						{ "px": [352,16], "src": [16,0], "f": 0, "t": 1, "d": [57] },
						{ "px": [368,16], "src": [16,0], "f": 0, "t": 1, "d": [58] },

            ...
```

But hold up, what world is the tile being added to? This is where bump [bump](https://github.com/kikito/bump.lua) comes in, a library for simple AABB collision detection, which is a perfect fit for this game. To use it, we have to add everything in our game to a world object. Then, when e.g. moving the player object, bump will check if it collides with anything. What happens then depends on so-called filters that are written by the developer. Here is an example of the filter that the player object uses in Snaketime when moving around:

```
function playerFilter(player, other)
  if      other.isWall              then return "slide"
  elseif  other.isKey               then return "cross"
  elseif  other.isFeather           then return "cross"
  elseif  other.isKeyCheckZone      then return "cross"
  elseif  other.isEnterTriggerZone  then return "cross"
  elseif  other.isEgg               then return "cross"
  elseif  other.isBoss              then return "cross"
  elseif  other.isHeart             then return "cross"
  elseif  other.isHeartContainer    then return "cross"
  else                                   return nil 
  end
end
```

If it returns “slide”, it means that the player will not be able to pass through the object. If it returns “cross” the player will move through the object. If it return nil, moving through this object will not cause a collision.

Most tiles do not cause any collisions. Setting our wall tiles to “isWall” automatically ensures that player cannot pass through any walls, as specified in our LDtk collision map. Most interactable objects return a “cross” collision, which then has to be processed further, for example like this in PlayerWalkState:

```
if other.isKey then
  self.player.keys = self.player.keys + 1
  self.world:remove(other)
  sounds["ding"]:play()

elseif other.isBoss then
  self.player:takeDamage(1)
```

By the way, sounds upon being hit are handled by each entity's takeDamage method:
```
function Player:takeDamage(amount)
  if self.invulnerable then
    return
  end
  self.hp = self.hp - amount
  sounds["hurt"]:play()
  self:goInvulnerable(1)
  if self.hp < 1 then
    stateStacc:pop()
    stateStacc:push(PlayState())
    stateStacc:push(GameOverState())
  end
end
```


## Doors
<img alt="Doors" src="/readme-images/door-banner.png?raw=true">

This bring us to a classic challenge to game developers, [doors](https://www.theverge.com/22328169/game-development-doors-design-difficult). Much as the PlayerWalkState checks for objects, it also checks for two zones related to doors. These zones are loaded into the world the same way as the other objects as well.

### KeyCheckZone
<img alt="KeyCheckZone screenshot" src="/readme-images/key-check-zone.png?raw=true">

If the player collides with this zone, it checks if the player has a key (or a feather, in the case of the door to the final boss). If so, it removes “isWall” status from all tiles inside the zone, and changes tile IDs from closed to open. Thus, it opens locked doors if the player approaches them and has the appropriate key.

### EnterTriggerZone
<img alt="EnterTriggerZone screenshot" src="/readme-images/enter-trigger-zones.png?raw=true">

Three of these zones wait for the player just past the last door to the final room, where the boss is waiting (inactively). When the player collides with one of these zones, the game finds two different objects called DramaticDoorCloseZones, which lie over the entrance doors. As the name suggests, these doors will close dramatically when they player enters the boss room fully. The method for this is essentially the inverse of the KeyCheckZones. At the same time, the EnterTriggerZone will set the boss’s status to active, causing it to start making update() calls.

### Door Tops
<img alt="Door tops as seen in LDtk" src="/readme-images/ldtk-door-top.png?raw=true">

Early on, I also noticed that if the player is drawn on top of other tiles, it will look like it’s slithering over the doors rather than through them. To solve this, I took the tiles I drew and created additional tiles that were transparent and only contained the top part of the door. Then, I created a separate “door top” layer in LDtk, loaded it into the game, and added separate door top objects to the game world at the same locations as the doors. I created a z-index property for each rendered object, setting them as follows:
- Tile: 1
- Door: 2
- Player: 10
- Door top: 11

Using this system, doors are rendered over tiles (such as walls). Then, the player moves over door tiles, but the door top is always rendered over the player, thus making it look like the player is passing through the door.

<img alt="Player going through door" src="/readme-images/snake-door-top.png?raw=true">

## Art, animation and audio
<img alt="Doodle collage" src="/readme-images/doodle-collage.png?raw=true">

I attempted to create my own art and aniomations for this game. To import and manage the animations, I used anim8 [link]. Each animation was exported as a row of images and then assigned to different states using the library. The WinState shows a simple example of a single animation:

```
function WinState:init(player, camera)
  self.player = player
  self.camera = camera
  
  -- Initialize anim8 animation
  self.img = love.graphics.newImage("art/player-walk-right.png")
  local grid = anim8.newGrid(16, 16, self.img:getWidth(), self.img:getHeight())
  self.animation = anim8.newAnimation(grid("1-4",1), 0.1)
end

function WinState:update(dt)
  -- Now, it just needs a simple update call..
  self.animation:update(dt)
  self.camera:update()
end

function WinState:render()
  self.camera:render()
  -- ...and a simple draw call
  self.animation:draw(self.img, self.player.x, self.player.y)
  
  love.graphics.origin()
  love.graphics.setColor(237/255, 239/255, 226/255, 1)
  love.graphics.printf(
    "YOU WIN!", 
    0, 
    VIRTUAL_HEIGHT * 0.75, 
    VIRTUAL_WIDTH, 
    "center")
  love.graphics.setColor(1, 1, 1, 1)
end
```

For the attack animations, I had to dig a little deeper into the library to be able to end the animations after their last frames. First I handled this as follows:

```
function PlayerAttackState:update(dt)
  self.animation:update(dt)
  [...]
end


function PlayerAttackState:render()
  [...]
  self.animation:draw(self.img[self.direction], x, y)

  -- If last frame, change state
  if self.animation.position == #self.animation.frames then
    self.player.stateMachine:change("walk", self.direction)
  end
end
```

But I noticed that the animation would end as soon as it encountered the last frame for the first time, while it should display the final frame as long as it does the other frames. To achieve this, I changed the code to this pattern:

```
function PlayerAttackState:update(dt)
  self.animation:update(dt)
  
  if self.animation.position == 1 and self.animComplete then
    self.player.stateMachine:change("walk", self.direction)
  end
  [...]
end


function PlayerAttackState:render()
  [...]
  self.animation:draw(self.img[self.direction], x, y)

  -- If last frame, change state
  if self.animation.position == #self.animation.frames then
    self.animComplete = true
  end
end
```

This way, the state changes only when the last animation frame has fully elapsed and the animation is about to loop.

The sound effects were created with bfxr, and the little intro tune was made using Logic Pro X and the magical8bit plug-in.


## Final boss
<img alt="Boss transformation frames" src="/readme-images/boss-transform-demo.png?raw=true">

A considerable amount of work went into building the choreography of the final boss, which has a whopping 9 states. It has two phases with 5 HP each, starting in the form of a simple goose. It makes use of an attack similar to the egg enemies. It scans for the player around its location and strikes in the direction where the polayer is, playing the animation once and adding a hitbox. Otherwise, it cycles between idle and walk animations. The increased size as compared to the egg enemies makes the final boss dangerous as well, because it will damage the player if the two collide.

After it loses 5 HP, the boss will enter a transformation animation during which it is invulnerable, not collidable, and does not scan for enemies. Narratively, the boss grows additional heads, like a hydra of Herculean myth. Once the animation is done, it regains 5 HP and enters phase 2 idle state, which cycles with the phase 2 walk state. Programmatically, the two are similar to the corresponding phase 1 states, except that the boss is not scanning for the player to launch attacks.

Instead, the boss has a new and more dangerous attack. When it ends an idle phase, it has a chance to enter a wind-up state, getting ready for an attack and playing a wind-up animation. Once the wind-up ends, it launches a vast attack that moevs across the screen fast and bounces off of walls using bump’s “bounce” filter. This caused some bugs at first, and I had to make sure to move the boss away from walls before it launches its attack. Without this, the boss would be thrown off the screen because it caused “bounce” collisions with high velocities, as a result of the sprite changing size and it getting positioned far into a wall.

After the boss completes its attack phase, it enters a wind-down state with a corresponding animation. Then it transitions back into an idle state smoothly. Here is a page from my notes about the state system:

<img alt="State machine notes" src="/readme-images/states.jpeg?raw=true">

