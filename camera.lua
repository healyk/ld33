Camera = Camera or {}
Camera.__index = Camera

function Camera.create()
  local self = setmetatable({}, Camera)
  
  self.x = 0
  self.y = 0
  
  return self
end

function Camera:moveBy(deltaX, deltaY)
  self.x = self.x + deltaX
  self.y = self.y + deltaY
end

function Camera:getTileX()
  return self.x
end

function Camera:getTileY()
  return self.y
end