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

But hold up, what world is the tile being added to? This is where bump [link] comes in, a library for simple AABB collision detection, which is a perfect fit for this game. To use it, we have to add everything in our game to a world object. Then, when e.g. moving the player object, bump will check if it collides with anything. What happens then depends on so-called filters that are written by the developer. Here is an example of the filter that the player object uses in Snaketime when moving around:

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
  else                                 return nil 
  end
end
```


<img alt="TODO" src="/readme-images/TODO.png?raw=true">

<img alt="TODO" src="/readme-images/TODO.png?raw=true">

<img alt="TODO" src="/readme-images/TODO.png?raw=true">

