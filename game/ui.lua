ui = ui or {}

ui.white = { 222, 238, 214 }
ui.black = { 20, 12, 28 }

function ui.init()
  ui.image = love.graphics.newImage('ui.png')
  
  -- Build the font.  First the alphabet
  ui.font = {}
  for x = 0, 26 do
    ui.addChar(x + 65, (x * 12) + 1, 1)
  end
  
  -- Now numbers
  for x = 0, 10 do
    ui.addChar(x + 48, (x * 12) + 1, 13)
  end
  
  ui.addChar(' ', 313, 1)
  ui.addChar(':', 1, 25)
  ui.addChar('!', 13, 25)
end

function ui.addChar(chr, x, y)
  if type(chr) == 'string' then
    chr = string.byte(chr, 1)
  end

  ui.font[chr] = love.graphics.newQuad(x, y, 10, 10, ui.image:getWidth(), ui.image:getHeight())
end

function ui.render(game)
  local width, height, flags = love.window.getMode( )
  love.graphics.setColor(ui.black)
  love.graphics.rectangle("fill", 0, 0, width, 50)
  love.graphics.setColor(255, 255, 255, 255)
  
  ui.drawString(4, 0, 'SCORE: ' .. game.score)
  
  ui.renderTime(game)
end

function ui.renderTime(game)
  local minutes = '0' .. math.floor(game.timeLeft / 60)
  local seconds = math.floor(game.timeLeft % 60)
  
  if seconds < 10 then
    seconds = '0' .. seconds
  end
  
  ui.drawString(300, 0, 'TIME ' .. minutes .. ':' .. seconds)
end

function ui.drawString(x, y, str)
  str = string.upper(str)
  for i = 1, string.len(str) do
    local chr = string.byte(str, i)
    local quad = ui.font[chr]

    love.graphics.draw(ui.image, quad, x + (i * 10 * SCALE_X), y * SCALE_Y, 0, SCALE_X, SCALE_Y)
  end
end

function ui.renderBox(x, y, width, height)
  love.graphics.setColor(ui.white)
  love.graphics.rectangle("fill", x * SCALE_X, y * SCALE_Y, width * SCALE_X, height * SCALE_Y)
  love.graphics.setColor(ui.black)
  love.graphics.rectangle("fill", (x + 3) * SCALE_X, (y + 3) * SCALE_Y, (width - 6) * SCALE_X, (height - 6) * SCALE_Y)
  love.graphics.setColor(255, 255, 255)
end
