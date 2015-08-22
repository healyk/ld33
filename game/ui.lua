ui = ui or {}

function ui.init()
  ui.image = love.graphics.newImage('ui.png')
  
  -- Build the font.  First the alphabet
  ui.font = {}
  for x = 0, 26 do
    ui.font[x + 65] = love.graphics.newQuad((x * 12) + 1, 1, 10, 10, ui.image:getWidth(), ui.image:getHeight())
  end
  
  -- Now numbers
  for x = 0, 10 do
    ui.font[x + 48] = love.graphics.newQuad((x * 12) + 1, 13, 10, 10, ui.image:getWidth(), ui.image:getHeight())
  end
  
  -- Space
  ui.font[32] = love.graphics.newQuad(313, 1, 10, 10, ui.image:getWidth(), ui.image:getHeight())
end

function ui.render(game)
  local width, height, flags = love.window.getMode( )
  love.graphics.setColor(0, 0, 0, 255)
  love.graphics.rectangle("fill", 0, 0, width, 50)
  love.graphics.setColor(255, 255, 255, 255)
  
  ui.drawString(4, 0, "SCORE: " .. game.score)
end

function ui.drawString(x, y, str)
  str = string.upper(str)
  for i = 1, string.len(str) do
    local chr = string.byte(str, i)
    local quad = ui.font[chr]
    print(chr, quad)
    love.graphics.draw(ui.image, quad, x + (i * 10 * SCALE_X), y, 0, SCALE_X, SCALE_Y)
  end
end