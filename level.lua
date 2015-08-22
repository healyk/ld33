Level = Level or {}
Level.__index = Level

LEVEL_WIDTH = 100
LEVEL_HEIGHT = 100

function randomTile(rng)
  number = rng:random(4)
  
  if number == 1 then
    return "grass"
  elseif number == 2 then
    return "shallowWater"
  elseif number == 3 then
    return "road"
  elseif number == 4 then
    return "dirt"
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
      self.tiles[x][y] = randomTile(rng)
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
  local width, height = camera:getScreenTileResolution()
  local cameraTileX = camera:getTileX()
  local cameraTileY = camera:getTileY()

  for y = -10, 100 do
    for x = -10, 100 do
      local pixelX = (x * TILE_WIDTH) - (camera.x % TILE_WIDTH)
      local pixelY = (y * TILE_HEIGHT) - (camera.y % TILE_HEIGHT)
      local name = self:getTileName(x + cameraTileX, y + cameraTileY)
      
      if (cameraTileY + y) % 2 == 0 then
        pixelX = pixelX + (TILE_WIDTH / 2)
      end
      
      gfx.drawTile(gfx.tiles[name], pixelX, pixelY)
    end
  end
end

function Level:destroyTile(x, y)
  if self:inBounds(x, y) then
    self.tiles[x][y] = "destroyed"
  end
end