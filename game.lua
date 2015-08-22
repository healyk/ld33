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
  
  print('move')
  print(self.player.x)
  print(self.player.y)
end
