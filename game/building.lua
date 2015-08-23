Building = Building or {}
Building.__index = Building

--
-- Building States
--
BUILDING_OKAY = 1
BUILDING_DAMAGE1 = 2
BUILDING_DAMAGE2 = 3
BUILDING_DESTROYED = 4

buildingGfx = {}

function initBuildingGfx()
  buildingGfx.image = gfx.tilesImage
  buildingGfx.quads = {}
  
  local frames = { 1, 19, 37, 55 }
  for i, x in pairs(frames) do
    local quad = love.graphics.newQuad(x, 55, TILE_WIDTH, TILE_HEIGHT * 2, buildingGfx.image:getWidth(), buildingGfx.image:getHeight())
    table.insert(buildingGfx.quads, quad)
  end
end

function Building.create()
	local self = setmetatable({}, Building)
	
  self.currentState = 1
  self.health = 40
  
	return self
end

function Building:render(x, y)
  local tmp = { image = buildingGfx.image, quad = buildingGfx.quads[self.currentState] }
  gfx.drawTile(tmp, x, y - TILE_HEIGHT)
end

function Building:damage()
  if self.health > 0 then
    self.health = self.health - 1
    
    if self.health <= 10 then
      self.currentState = BUILDING_DESTROYED
    elseif self.health <= 20 then
      self.currentState = BUILDING_DAMAGE2
    elseif self.health <= 30 then
      self.currentState = BUILDING_DAMAGE1
    else
      self.currentState = BUILDING_OKAY
    end
    
    return false
  else
    return true
  end
end