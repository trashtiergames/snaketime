<img alt="Title image" src="/readme-images/title.png?raw=true">

Link test:
[linktest](https://ldtk.io)

# Snaketime
Slither your way through a small dungeon and bettle the fearsome final boss in Snaketime. This top-down, Zelda-style LÖVE2D game is my final project for CS50’s Introduction to Game Development. If you want to play, get LÖVE2D, download this repo, and run the whole folder with “love snaketime”.

## Loading the game
<img alt="LDtk screenshot" src="/readme-images/ldtk-screen.png?raw=true">
Snaketime takes many of the concepts of week 5’s “Legend of Zelda” project, such as the basic state system for enemies, but my game also handles some aspect very differently, starting with the makeup of the levels. Snaketime is a single dungeon with pre-determined rooms, doors, enemies and items. Because this sort of level is difficult to design and create entirely in code, I opted to use [LDtk](https://ldtk.io), a 2D level editor. LDtk allows users to create levels based on tilemaps and export them to a single json file. The [structure](https://ldtk.io/json/#overview) looks something like this:   

<img alt="LDtk JSON chart" src="/readme-images/ldtk-json-chart.png?raw=true">
