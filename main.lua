require('gfx')
require('level')
require('camera')

rng = nil
level = nil
camera = nil

function love.load()
  gfx.init()
  
  rng = love.math.newRandomGenerator()
  level = Level.create(100, 100)
  camera = Camera.create()
end

function love.gamepadpressed(joystick, button)
  if button == "dpup" then
    camera:moveBy(0, -1)
  elseif button == "dpdown" then 
    camera:moveBy(0, 1)
  end
end

function love.draw()
  level:render(camera)
end
