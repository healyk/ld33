require('gfx')
require('building')
require('level')
require('camera')
require('player')
require('game')
require('ui')

MAINMENU = 0
INGAME = 1
GAMEOVER = 2
HELP1 = 3

game = nil
gamestate = MAINMENU
gameoverDelay = 0

function love.load()
  gfx.init()
  ui.init()
  initBuildingGfx()
end

--
-- Update
--
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
  if gamestate == INGAME then
    checkJoystickInput()
    checkKeyboardInput()
    
    game:update(dt)
    
    if game:over() then
      triggerGameOver()
    end
  end
  
  if gamestate == GAMEOVER then
    if gameoverDelay > 0 then
      gameoverDelay = gameoverDelay - dt
    end
  end
end

--
-- Input
--
function love.gamepadpressed(joystick, button)
  if gamestate == MAINMENU then
    MainMenu.gamepadInput(button)
  elseif gamestate == GAMEOVER then
    gamestate = MAINMENU
    game = nil
  elseif gamestate == HELP1 then
    gamestate = MAINMENU
  end
end

function love.keypressed(key)
  if gamestate == MAINMENU then
    MainMenu.keyboardInput(key)
  elseif gamestate == GAMEOVER then
    gamestate = MAINMENU
    game = nil
   elseif gamestate == HELP1 then
    gamestate = MAINMENU
  end
end

--
-- Drawing
--
function love.draw()
  if gamestate == INGAME or gamestate == GAMEOVER then
    game.level:render(game.camera)
    game.player:render(game.camera)
  
    ui.render(game)
  end
  
  if gamestate == GAMEOVER then
    renderGameOver()
  end
  
  if gamestate == MAINMENU then
    MainMenu.render()
  end
  
  if gamestate == HELP1 then
    love.graphics.draw(gfx.help1, 0, 0, 0, SCALE_X, SCALE_Y)
  end
end

function renderGameOver()
  local width, height = love.window.getMode()
    
  width = (width / SCALE_X) - 200
  height = (height / SCALE_Y) - 200
  
  ui.renderBox(100, 100, width, height)
  
  ui.drawString(250, 110, 'Game Over!')
  ui.drawString(250, 130, 'Score: ' .. game.score)
  
  if gameoverDelay <= 0 then
    ui.drawString(250, 170, 'Press any key')
  end
end

--
-- Gamestates
--
function triggerGameOver()
  gamestate = GAMEOVER
  gameoverDelay = 2
end