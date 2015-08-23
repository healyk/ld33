gfx = gfx or {}

-- Scaling factors
SCALE_X = 2
SCALE_Y = 2

-- Raw pixel sizes for tiles (non-scaled)
TILE_WIDTH = 16
TILE_HEIGHT = 16

function gfx.init()
  love.graphics.setDefaultFilter('nearest', 'nearest', 1)
  
  gfx.tiles = {}
  gfx.tilesImage = love.graphics.newImage('tiles.png')
  
  gfx.addTile('grass', 1, 1)
  gfx.addTile('shallowWater', 19, 1)
  gfx.addTile('deepWater', 37, 1)
  gfx.addTile('road', 55, 1)
  gfx.addTile('dirt', 73, 1)
  gfx.addTile('forrest', 91, 1)
  gfx.addTile('sand', 109, 1)
  gfx.addTile('destroyedSkyscraper', 127, 1)
  gfx.addTile('destroyedHouse', 145, 1)
  gfx.addTile('field', 163, 1)
  
  gfx.help1 = love.graphics.newImage('help1.png')
  
  love.graphics.setBackgroundColor(20, 12, 28)
end

function gfx.addTile(name, x, y)
  local image = gfx.tilesImage
  local quad = love.graphics.newQuad(x, y, TILE_WIDTH, TILE_HEIGHT, image:getWidth(), image:getHeight())
  tile = {
    image = image,
    quad = quad
  }
  
  gfx.tiles[name] = tile
end

function gfx.drawTile(tile, x, y)
  love.graphics.draw(tile.image, tile.quad, x * SCALE_X, y * SCALE_Y, 0, SCALE_X, SCALE_Y, 0, 0)
end

--
-- Animation
--
Animation = Animation or {}
Animation.__index = Animation

function Animation.create(image, frameTime)
  local self = setmetatable({}, Animation)
  
  self.frames = {}
  self.current = 1
  self.frameTime = frameTime
  self.currentTime = 0
  self.image = image
  
  return self
end

function Animation:update(dt)
  self.currentTime = self.currentTime + dt

  if self.currentTime > self.frameTime then
    self.currentTime = 0

    self.current = self.current + 1
    if self.current > #self.frames then
      self.current = 1
    end
  end
end

function Animation:render(x, y)
  local quad = self.frames[self.current]
  love.graphics.draw(self.image, quad, x * SCALE_X, y * SCALE_Y, 0, SCALE_X, SCALE_Y)
end

function Animation:addFrame(x, y, width, height)
  local quad = love.graphics.newQuad(x, y, width, height, self.image:getWidth(), self.image:getHeight())
  table.insert(self.frames, quad)
end