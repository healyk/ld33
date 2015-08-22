Player = Player or {}
Player.__index = Player

PLAYER_WIDTH = 34
PLAYER_HEIGHT = 16

PLAYER_SIZES = {
  west = { width = 34, height = 16 },
  east = { width = 34, height = 16 },
  south = { width = 16, height = 34 },
  north = { width = 16, height = 34 }
}

function Player.create(x, y)
  local self = setmetatable({}, Player)
  
  self.image = gfx.tilesImage
  self.quads = {
    west = love.graphics.newQuad(1, 19, PLAYER_WIDTH, PLAYER_HEIGHT, self.image:getWidth(), self.image:getHeight()),
    east = love.graphics.newQuad(1, 37, PLAYER_WIDTH, PLAYER_HEIGHT, self.image:getWidth(), self.image:getHeight()),
    south = love.graphics.newQuad(37, 19, PLAYER_HEIGHT, PLAYER_WIDTH, self.image:getWidth(), self.image:getHeight()),
    north = love.graphics.newQuad(55, 19, PLAYER_HEIGHT, PLAYER_WIDTH, self.image:getWidth(), self.image:getHeight())
  }
  
  self.x = x
  self.y = y
  self.facing = 'west'
  
  return self
end

function Player:render(camera) 
  local pixelX = self.x - camera.x
  local pixelY = self.y - camera.y + TILE_HEIGHT
 
  local quad = self.quads[self.facing]
  love.graphics.draw(self.image, quad, pixelX * SCALE_X, pixelY * SCALE_Y, 0, SCALE_X, SCALE_Y)
end

function Player:moveBy(x, y)
  self.x = self.x + x
  
  if x == 0 then
    y = y * 2
  end
  
  self.y = self.y + y
  
  if x < 0 then
    self.facing = 'west'
  elseif x > 0 then
    self.facing = 'east'
  elseif y < 0 then
    self.facing = 'south'
  elseif y > 0 then
    self.facing = 'north'
  end
end

function Player:getBounds()
  local bounds = {
    x = self.x,
    y = self.y,
    width = 16,
    height = 8
  }
  
  -- Swap width and height if the facing is north or south
  if self.facing == 'south' or self.facing == 'north' then
    local tmp = bounds.width
    bounds.width = bounds.height
    bounds.height = tmp
  end
  
  return bounds
end
