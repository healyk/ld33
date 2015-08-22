gfx = gfx or {}

-- Scaling factors
SCALE_X = 2
SCALE_Y = 2

-- Raw pixel sizes for tiles (non-scaled)
TILE_WIDTH = 34
TILE_HEIGHT = 16

function gfx.init()
  love.graphics.setDefaultFilter("nearest", "nearest", 1)
  
  gfx.tiles = {}
  gfx.tilesImage = love.graphics.newImage('tiles.png')
  
  gfx.addTile("grass", 1, 1)
  gfx.addTile("shallowWater", 3 + TILE_WIDTH, 1)
  gfx.addTile("deepWater", 5 + (TILE_WIDTH * 2), 1)
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
  love.graphics.draw(tile.image, tile.quad, x, y, 0, SCALE_X, SCALE_Y, 0, 0)
end