Level = Level or {}
Level.__index = Level

LEVEL_WIDTH = 100
LEVEL_HEIGHT = 100

function Level:shoreTile(value, x, y)
  -- Figure out if x or y is nearest to shore
  local mod = 0
  if x < 10 then
    mod = 10 - x
  elseif x > self.width - 10 then
    mod = 10 - (self.width - x)
    greater = true
  elseif y < 10 then
    mod = 10 - y
  else
    mod = 10 - (self.height - y)
  end
  
  mod = mod / 10
  
  if value - mod <= 0.25 then
    return 'shallowWater'
  else
    return 'sand'
  end
end

function landTile(value)
  if value <= 0.30 then
    return 'dirt'
  else
    return 'grass'
  end
end

function Level.create(rng, width, height)
  local self = setmetatable({}, Level)
  
  self.width = width
  self.height = height
  
  self.tiles = {}
  for x = 0, self.width do
    self.tiles[x] = {}
    for y = 0, self.height do
      value = love.math.noise(x, y)

      if x < 10 or y < 10 or x > (width - 10) or y > (height - 10) then
        self.tiles[x][y] = self:shoreTile(value, x, y)
      else
        self.tiles[x][y] = landTile(value)
      end
    end
  end
  
  return self
end

function Level:inBounds(x, y)
  return not (x < 0 or y < 0 or x > self.width or y > self.height)
end

-- Gets a tile from x, y.  If no tile exists (or it's out of bounds) deepWater will
-- be returned
function Level:getTileName(x, y)
  if not self:inBounds(x, y) then
    return "deepWater"
  else
    return self.tiles[x][y]
  end
end

function Level:render(camera)
  local cameraTileX = camera:getTileX()
  local cameraTileY = camera:getTileY()
  
  -- pad y
  local width, height = camera:getScreenTileResolution()
  cameraTileY = cameraTileY - math.floor(width / 4)

  for y = -10, self.height do
    for x = -10, self.width do
      local pixelX = (x * TILE_WIDTH) - (camera.x % TILE_WIDTH)
      local pixelY = (y * TILE_HEIGHT) - (camera.y % TILE_HEIGHT)
      local name = self:getTileName(x + cameraTileX, y + cameraTileY)
      
      if (cameraTileY + y) % 2 == 0 then
        pixelX = pixelX + (TILE_WIDTH / 2)
      end
      
      gfx.drawTile(gfx.tiles[name], pixelX, pixelY / 2)
    end
  end
end

function Level:destroyTile(x, y)
  if self:inBounds(x, y) then
    tile = self.tiles[x][y]

     if tile ~= "destroyed" and tile ~= 'shallowWater' and tile ~= 'deepWater' then
      self.tiles[x][y] = "destroyed"
      return true
    else
      return false
    end
  else
    return false
  end
end