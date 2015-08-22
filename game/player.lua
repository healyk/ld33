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
  self.anims = {
    west = Animation.create(self.image, 0.1),
    east = Animation.create(self.image, 0.1),
    south = Animation.create(self.image, 0.1),
    north = Animation.create(self.image, 0.1),
  }
  
  self.anims.west:addFrame(1, 19, PLAYER_WIDTH, PLAYER_HEIGHT)
  self.anims.west:addFrame(73, 19, PLAYER_WIDTH, PLAYER_HEIGHT)
  
  self.anims.east:addFrame(1, 37, PLAYER_WIDTH, PLAYER_HEIGHT)
  self.anims.east:addFrame(73, 37, PLAYER_WIDTH, PLAYER_HEIGHT)
  
  self.anims.south:addFrame(37, 19, PLAYER_HEIGHT, PLAYER_WIDTH)
  self.anims.south:addFrame(109, 19, PLAYER_HEIGHT, PLAYER_WIDTH)
  
  self.anims.north:addFrame(55, 19, PLAYER_HEIGHT, PLAYER_WIDTH)
  self.anims.north:addFrame(127, 19, PLAYER_HEIGHT, PLAYER_WIDTH)
  
  self.x = x
  self.y = y
  self.facing = 'west'
  
  return self
end

function Player:render(camera) 
  local pixelX = self.x - camera.x
  local pixelY = self.y - camera.y + TILE_HEIGHT
 
  local anim = self.anims[self.facing]
  anim:render(pixelX, pixelY)
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

function Player:update(dt)
  local anim = self.anims[self.facing]
  anim:update(dt)
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
