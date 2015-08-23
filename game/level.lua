Level = Level or {}
Level.__index = Level

LEVEL_WIDTH = 100
LEVEL_HEIGHT = 100

function Level.create(rng, width, height)
  local self = setmetatable({}, Level)
  
  self.width = width
  self.height = height
  
  self.tiles = {}
  for x = 0, self.width do
    self.tiles[x] = {}
    for y = 0, self.height do
      value = love.math.noise(x, y)
      self.tiles[x][y] = {}

      if x < 10 or y < 10 or x > (width - 10) or y > (height - 10) then
        self.tiles[x][y] = self:shoreTile(value, x, y)
      else
        self.tiles[x][y] = landTile(value)
      end
    end
  end
  
  -- Add some random buildings
  for i = 0, 10 do
    local x = rng:random(12, self.width - 10)
    local y = rng:random(12, self.height - 12)
    
    self.tiles[x][y].building = Building.create()
    self.tiles[x][y].name = 'destroyedBuilding'
  end
  
  return self
end

function Level:inBounds(x, y)
  return not (x < 0 or y < 0 or x > self.width or y > self.height)
end

DEEP_WATER_TILE = {
  name = 'deepWater'
}

-- Gets a tile from x, y.  If no tile exists (or it's out of bounds) deepWater will
-- be returned
function Level:getTile(x, y)
  if not self:inBounds(x, y) then
    return DEEP_WATER_TILE
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
  
  local buildings = {}

  for y = -10, self.height do
    for x = -10, self.width do
      local pixelX = (x * TILE_WIDTH) - (camera.x % TILE_WIDTH)
      local pixelY = (y * TILE_HEIGHT) - (camera.y % TILE_HEIGHT)
      local tile = self:getTile(x + cameraTileX, y + cameraTileY)
      
      if (cameraTileY + y) % 2 == 0 then
        pixelX = pixelX + (TILE_WIDTH / 2)
      end
      
      gfx.drawTile(gfx.tiles[tile.name], pixelX, pixelY / 2)
      
      if tile.building ~= nil then
        table.insert(buildings, { tile.building, pixelX, pixelY })
      end
    end
  end
  
  -- Second sweep for buildings
  for index, data in pairs(buildings) do
    local building = data[1]
    building:render(data[2], data[3] / 2)
  end
end

function Level:destroyTile(x, y)
  if self:inBounds(x, y) then
    tile = self.tiles[x][y]
    
    if tile.building ~= nil then
      if tile.building:damage() then
        tile.building = nil
      end
      
      return 10
    elseif tileDestroyable(tile.name) then
      tile.name = "destroyed"
      return 1
    else
      return 0
    end
  else
    return 0
  end
end

function tileDestroyable(name)
  return name ~= 'destroyed' and name ~= 'shallowWater' and name ~= 'deepWater' and name ~= 'destroyedBuilding'
end

function tileEnterable(name)
  return name ~= 'deepWater'
end

--
-- Level Gen
--
function Level:shoreDistance(x, y)
  local xdistance = 0
  local ydistance = 0

  if x < 10 then
    xdistance = 10 - x
  elseif x > self.width - 10 then
    xdistance = 10 - (self.width - x)
  end
  
  if y < 10 then
    ydistance = 10 - y
  elseif y > self.height - 10 then
    ydistance = 10 - (self.height - y)
  end
  
  return math.max(xdistance, ydistance)
end

function Level:shoreTile(value, x, y)
  -- Figure out if x or y is nearest to shore
  local mod = self:shoreDistance(x, y)  
  value = value - (mod / 10)
  
  if mod <= 2 then
    return { name = 'sand' }
  elseif mod <= 6 then
    if value <= 0.05 then
      return {
        name = 'deepWater'
      }
    elseif value <= 0.40 then
      return {
        name = 'shallowWater',
      }
    else
      return {
        name = 'sand'
      }
    end
  else
    if value < 0.70 then
      return {
        name = 'deepWater'
      }
    else
      return {
        name = 'shallowWater',
      }
    end
  end
end

function landTile(value)
  if value <= 0.30 then
    return {
      name = 'dirt'
    }
  else
    return {
      name = 'grass'
    }
  end
end