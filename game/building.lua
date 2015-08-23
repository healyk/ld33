buildingGfx = buildingGfx or {}

function initBuildingGfx()
  buildingGfx.image = gfx.tilesImage
  buildingGfx.skyscraperQuads = {}
  
  local frames = { 1, 19, 37, 55 }
  for i, x in pairs(frames) do
    local quad = love.graphics.newQuad(x, 55, TILE_WIDTH, TILE_HEIGHT * 2, buildingGfx.image:getWidth(), buildingGfx.image:getHeight())
    table.insert(buildingGfx.skyscraperQuads, quad)
  end
  
  buildingGfx.houseQuads = {
    love.graphics.newQuad(73, 55, TILE_WIDTH, TILE_HEIGHT * 2, buildingGfx.image:getWidth(), buildingGfx.image:getHeight()),
    love.graphics.newQuad(91, 55, TILE_WIDTH, TILE_HEIGHT * 2, buildingGfx.image:getWidth(), buildingGfx.image:getHeight())
  }
end

--
-- Skyscraper
--
Skyscraper = Skyscraper or {}
Skyscraper.__index = Skyscraper

SKYSCRAPER_OKAY = 1
SKYSCRAPER_DAMAGE1 = 2
SKYSCRAPER_DAMAGE2 = 3
SKYSCRAPER_DESTROYED = 4

function Skyscraper.create()
	local self = setmetatable({}, Skyscraper)
	
  self.currentState = 1
  self.health = 40
  
	return self
end

function Skyscraper:render(x, y)
  local tmp = { image = buildingGfx.image, quad = buildingGfx.skyscraperQuads[self.currentState] }
  gfx.drawTile(tmp, x, y - TILE_HEIGHT)
end

function Skyscraper:damage()
  if self.health > 0 then
    self.health = self.health - 1
    local currentState = self.currentState
    
    if self.health <= 10 then
      self.currentState = SKYSCRAPER_DESTROYED
    elseif self.health <= 20 then
      self.currentState = SKYSCRAPER_DAMAGE2
    elseif self.health <= 30 then
      self.currentState = SKYSCRAPER_DAMAGE1
    else
      self.currentState = SKYSCRAPER_OKAY
    end
    
    local score = 1
    if currentState ~= self.currentState then
      score = 100
    end
    
    return false, score
  else
    return true, 0
  end
end

--
-- House
--
House = House or {}
House.__index = House

HOUSE_OKAY = 1
HOUSE_DESTROYED = 2

function House.create()
	local self = setmetatable({}, House)
	
  self.currentState = 1
  self.health = 20
  
	return self
end

function House:render(x, y)
  local tmp = { image = buildingGfx.image, quad = buildingGfx.houseQuads[self.currentState] }
  gfx.drawTile(tmp, x, y - TILE_HEIGHT)
end

function House:damage()
  if self.health > 0 then
    self.health = self.health - 1
    local currentState = self.currentState
    
    if self.health <= 10 then
      self.currentState = HOUSE_DESTROYED
    else
      self.currentState = HOUSE_OKAY
    end
    
    local score = 1
    if currentState ~= self.currentState then
      score = 50
    end
    
    return false, score
  else
    return true, 0
  end
end