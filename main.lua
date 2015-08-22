require('gfx')
require('level')
require('camera')
require('player')
require('game')

game = nil

function love.load()
  gfx.init()
  game = Game.create()
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
  
  if deltaX ~= 0 or deltaY ~= 0 then
    game:moveBy(deltaX, deltaY)
  end
end

dtotal = 0

function love.update(dt)
  checkJoystickInput()
end

function love.draw()
  game.level:render(game.camera)
  game.player:render(game.camera)
end
