Game = Game or {}
Game.__index = Game

-- Starts a new game
function Game.create()
  local self = setmetatable({}, Game)
  
  self.rng = love.math.newRandomGenerator()
  self.level = Level.create(self.rng, 100, 100)
  self.camera = Camera.create()
  
  self.player = Player.create(5, 5)
  self.camera:setCenter(5, 5)
  
  return self
end

function Game:moveBy(x, y)
  self.camera:moveBy(x, y)
  self.player:moveBy(x, y)
end

function Game:calculatePlayerTouchTiles()
  local bounds = self.player:getBounds()
  
  local left = bounds.x - (bounds.x % TILE_WIDTH)
  local right = bounds.x + bounds.width
  right = right + (right % TILE_WIDTH)

  local top = bounds.y - (bounds.y % TILE_HEIGHT)
  local bottom = bounds.y + bounds.height
  bottom = bottom + (bottom % TILE_HEIGHT)
  
  results = {}
  for x = left, right, TILE_WIDTH do
    for y = top, bottom, TILE_HEIGHT do
      table.insert(results, { x / TILE_WIDTH, y / TILE_HEIGHT })
    end
  end
  
  return results
end