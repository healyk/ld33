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
  
  self.score = 0
  
  return self
end

function Game:moveBy(x, y)
  self.player:moveBy(x, y)
  self.camera:setCenter(self.player.x, self.player.y)
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

function Game:updateScore()
  local tiles = game:calculatePlayerTouchTiles()
  local oldScore = self.score
  
  for k, v in pairs(tiles) do
    if game.level:destroyTile(v[1], v[2]) then
      self.score = self.score + 1
    end
  end
  
  if oldScore ~= self.score then
    print("New score: " .. self.score)
  end
end