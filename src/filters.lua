-- Collision filters for use with the bump library

function playerFilter(player, other)
  if      other.isWall          then return "slide"
  elseif  other.isKey           then return "cross"
  elseif  other.isFeather       then return "cross"
  elseif  other.isKeyCheckZone  then return "cross"
  elseif  other.isEgg           then return "cross"
  else                               return nil 
  end
end

function hitboxFilter(hitbox, other)
  if      other.isKey           then return "cross"
  elseif  other.isFeather       then return "cross"
  elseif  other.isEgg         then return "cross"
  else                               return nil 
  end
end