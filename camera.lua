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
  return math.floor(self.x / TILE_WIDTH)
end

function Camera:getTileY()
  return math.floor(self.y / TILE_HEIGHT)
end

function Camera:pixelToTiles(x, y)
  return math.floor(x / TILE_WIDTH), math.floor(y / TILE_HEIGHT)
end

function Camera:setCenter(x, y)
  local width, height, fullscreen, vsync, fsaa = love.window.getMode()
  
  self.x, self.y = math.floor(x - (width / 2 / SCALE_X)), math.floor(y - (height / 2 / SCALE_Y))
end

function Camera:getScreenTileResolution()
  local width, height, fullscreen, vsync, fsaa = love.window.getMode()
  return width / TILE_WIDTH, height / TILE_HEIGHT
end