-- Collision filters for use with the bump library

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

function hitboxFilter(hitbox, other)
  if      other.isKey             then return "cross"
  elseif  other.isFeather         then return "cross"
  elseif  other.isEgg             then return "cross"
  elseif  other.isBoss            then return "cross"
  elseif  other.isHeart           then return "cross"
  elseif  other.isHeartContainer  then return "cross"
  else                                 return nil 
  end
end

function eggFilter(egg, other)
  if      other.isWall  then return "slide"
  else                       return nil 
  end
end


function bossFilter(boss, other)
  if      other.isWall  then return "slide"
  else                       return nil 
  end
end

function boss1HitboxFilter(hitbox, other)
  if      other.isPlayer  then return "cross"
  else                         return nil 
  end
end

function bossSpinFilter(boss, other)
  if      other.isWall  then return "bounce"
  else                       return nil 
  end
end