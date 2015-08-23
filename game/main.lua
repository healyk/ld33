require('gfx')
require('building')
require('level')
require('camera')
require('player')
require('game')
require('ui')

GAMESTATE_INGAME = 0
GAMESTATE_GAMEOVER = 1

game = nil
gamestate = GAMESTATE_INGAME

function love.load()
  gfx.init()
  ui.init()
  initBuildingGfx()
  game = Game.create()
end

KEY_MAPPINGS = {
  { { joy = 'dpup', key = 'up' },      { 'move', 0, -3 } },
  { { joy = 'dpdown', key = 'down' },  { 'move', 0, 3 } },
  { { joy = 'dpleft', key = 'left' },  { 'move', -3, 0 } },
  { { joy = 'dpright', key = 'right' }, { 'move', 3, 0 } }
}

function checkJoystickInput()
  local joysticks = love.joystick.getJoysticks()
  
  if #joysticks > 0 then
    local joystick = joysticks[1]
    local deltaX = 0
    local deltaY = 0
    
    for i = 1, #KEY_MAPPINGS do
      local keyname = KEY_MAPPINGS[i][1]['joy']

      if joystick:isGamepadDown(keyname) then
        local action = KEY_MAPPINGS[i][2]
        
        if action[1] == 'move' then
          deltaX = deltaX + action[2]
          deltaY = deltaY + action[3]
        end
      end
    end
    
    if deltaX ~= 0 or deltaY ~= 0 then
      game:moveBy(deltaX, deltaY)
    end
  end
end


function checkKeyboardInput() 
  local deltaX = 0
  local deltaY = 0
  
  for i = 1, #KEY_MAPPINGS do
    local keyname = KEY_MAPPINGS[i][1]['key']

    if love.keyboard.isDown(keyname) then
      local action = KEY_MAPPINGS[i][2]
      
      if action[1] == 'move' then
        deltaX = deltaX + action[2]
        deltaY = deltaY + action[3]
      end
    end
  end
    
  if deltaX ~= 0 or deltaY ~= 0 then
    game:moveBy(deltaX, deltaY)
  end
end

function love.update(dt)
  if gamestate == GAMESTATE_INGAME then
    checkJoystickInput()
    checkKeyboardInput()
    
    game:update(dt)
    
    if game:over() then
      gamestate = GAMESTATE_GAMEOVER
    end
  end
end

function love.draw()
  game.level:render(game.camera)
  game.player:render(game.camera)
  
  ui.render(game)
  
  if gamestate == GAMESTATE_GAMEOVER then
    renderGameOver()
  end
end

function renderGameOver()
  local width, height = love.window.getMode()
    
  width = (width / SCALE_X) - 200
  height = (height / SCALE_Y) - 200
  
  ui.renderBox(100, 100, width, height)
  
  ui.drawString(250, 110, 'Game Over!')
  ui.drawString(250, 130, 'Score: ' .. game.score)
end