-- Smaller functions that are used throughout the main code

function sortByZ(itemsTable)
  -- Send items from bump.world with a higher z-index to the back
  -- This helps draw items in the right order, and enables us to know in which
  -- order items will be updated, so we don't call update() on removed items
  table.sort(itemsTable, function(a,b) return a.z < b.z end)
  return itemsTable
end

function pprint(t)
  -- Recursive table printing function (link to source was broken)
  local print_r_cache={}
  local function sub_print_r(t,indent)
    if (print_r_cache[tostring(t)]) then
      print(indent.."*"..tostring(t))
    else
      print_r_cache[tostring(t)]=true
      if (type(t)=="table") then
          for pos,val in pairs(t) do
            if (type(val)=="table") then
                print(indent.."["..pos.."] => "..tostring(t).." {")
                sub_print_r(val,indent..string.rep(" ",string.len(pos)+8))
                print(indent..string.rep(" ",string.len(pos)+6).."}")
            elseif (type(val)=="string") then
                print(indent.."["..pos..'] => "'..val..'"')
            else
                print(indent.."["..pos.."] => "..tostring(val))
            end
          end
      else
          print(indent..tostring(t))
      end
    end
  end
  if (type(t)=="table") then
    print(tostring(t).." {")
    sub_print_r(t,"  ")
    print("}")
  else
    sub_print_r(t,"  ")
  end
  print()
end

function generateQuads(atlas, tilewidth, tileheight)
  --[[
      Author: Colton Ogden
      cogden@cs50.harvard.edu
      License: Attribution-NonCommercial-ShareAlike 4.0 International 
      https://creativecommons.org/licenses/by-nc-sa/4.0/legalcode
  ]]
  -- How many tiles wide and high is the atlas
  local sheetWidth = atlas:getWidth() / tilewidth
  local sheetHeight = atlas:getHeight() / tileheight

  local sheetCounter = 0
  local spritesheet = {}

  for y = 0, sheetHeight - 1 do
    for x = 0, sheetWidth - 1 do
      spritesheet[sheetCounter] =
        love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
        tileheight, atlas:getDimensions())
      sheetCounter = sheetCounter + 1
    end
  end

  -- One long flat table with number keys (starting at 1) and Quad values
  return spritesheet
end

function hex2rgb(color)
  -- Converts LDtk hex color to löve2d format
  -- By HamdyElzonqali on Github under the MIT license
  local r = load("return {0x" .. color:sub(2, 3) .. ",0x" .. color:sub(4, 5) .. 
              ",0x" .. color:sub(6, 7) .. "}")()
  return r[1] / 255, r[2] / 255, r[3] / 255
end