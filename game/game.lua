Game = Game or {}
Game.__index = Game

-- Game time in seconds
GAME_TIME = 60

-- Starts a new game
function Game.create()
  local self = setmetatable({}, Game)
  
  local stime = love.timer.getTime()
  self.rng = love.math.newRandomGenerator(stime)
  
  -- Prime the rng
  for i = 0, 100 do
    self.rng:random()
  end
  
  self.level = Level.create(self.rng, 100, 100)
  self.camera = Camera.create()
  
  self.player = Player.create(300, 300)
  self.camera:setCenter(300, 300)
  
  self.score = 0
  self.damaging = false
  self.timeLeft = GAME_TIME
  
  return self
end

function Game:moveBy(x, y)
  self.player:moveBy(self, x, y)
  self.camera:setCenter(self.player.x, self.player.y)
  self.damaging = true
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
      table.insert(results, { math.floor(x / TILE_WIDTH), math.floor(y / TILE_HEIGHT) })
    end
  end
  
  return results
end

function Game:updateScore()
  if self.damaging then
    local tiles = game:calculatePlayerTouchTiles()
    local oldScore = self.score
  
    for k, v in pairs(tiles) do
      local damageScore, slowed = game.level:destroyTile(v[1], v[2])
      self.score = self.score + damageScore
      self.player.slowed = slowed
    end
    
    self.damaging = false
  end
end

function Game:update(dt)
  self.player:update(dt)
  self:updateScore()
  
  self.timeLeft = self.timeLeft - dt
  
  if self.timeLeft < 0 then
    self.timeLeft = 0
  end
end

function Game:over()
  return self.timeLeft <= 0
end