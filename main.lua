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

function checkJoystickInput()
  local joysticks = love.joystick.getJoysticks()
  local joystick = joysticks[1]
  local deltaX = 0
  local deltaY = 0

  if joystick:isGamepadDown("dpup") then
    deltaY = -1
  end
  if joystick:isGamepadDown("dpdown") then 
    deltaY = 1
  end
  if joystick:isGamepadDown("dpright") then
    deltaX = 1
  end
  if joystick:isGamepadDown("dpleft") then
    deltaX = -1
  end
  
  camera:moveBy(deltaX, deltaY)
end

function love.update(dt)
  checkJoystickInput()
end

function love.draw()
  level:render(camera)
end
