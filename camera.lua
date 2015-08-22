Camera = Camera or {}
Camera.__index = Camera

function Camera.create()
  local self = setmetatable({}, Camera)
  
  self.x = 0
  self.y = 0
  
  return self
end

function Camera:moveBy(deltaX, deltaY)
  self.x = self.x + deltaX
  self.y = self.y + deltaY
end

function Camera:getTileX()
  local x, y = self:pixelToTiles(self.x, self.y)
  return x
end

function Camera:getTileY()
  local x, y = self:pixelToTiles(self.x, self.y)
  return y
end

function Camera:pixelToTiles(x, y)
  local tileX, tileY = math.floor(x / TILE_WIDTH), math.floor(y / TILE_HEIGHT)
  
  return tileX, tileY
end

function Camera:setCenter(x, y)
  local width, height, fullscreen, vsync, fsaa = love.window.getMode()
  
  width = width / SCALE_X
  height = height / SCALE_Y
  
  self.x = math.floor(x - (width / 2))
  self.y = math.floor(y - (height / 2))
end

function Camera:getScreenTileResolution()
  local width, height, fullscreen, vsync, fsaa = love.window.getMode()
  return width / TILE_WIDTH, height / TILE_HEIGHT
end