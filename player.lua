Player = Player or {}
Player.__index = Player

PLAYER_WIDTH = 34
PLAYER_HEIGHT = 16

function Player.create(x, y)
  local self = setmetatable({}, Player)
  
  self.image = gfx.tilesImage
  self.quad = love.graphics.newQuad(1, 19, PLAYER_WIDTH, PLAYER_HEIGHT, self.image:getWidth(), self.image:getHeight())
  
  self.x = x
  self.y = y
  
  return self
end

function Player:render(camera) 
  local pixelX = self.x - camera.x
  local pixelY = self.y - camera.y + TILE_HEIGHT
 
  love.graphics.draw(self.image, self.quad, pixelX * SCALE_X, pixelY * SCALE_Y, 0, SCALE_X, SCALE_Y)
end

function Player:moveBy(x, y)
  self.x = self.x + x
  self.y = self.y + y
end

function Player:getBounds()
  return {
    x = self.x,
    y = self.y,
    width = 16,
    height = 8
  }
end
