assets = require "game.assets"
map = require "game.map"

print(ASSETS)

local t = 0
local N = 0

-- Load some default values for our rectangle.
function love.load()
    x, y, w, h = 20, 20, 60, 20
end
 
-- Increase the size of the rectangle every frame.
function love.update(dt)
    w = w + 1
    h = h + 1
    t = t + dt

    if t > 0.2 then
        t = 0
        N = N + 1
    end
end

function love.keypressed(key)
    -- Quit on escape
    if key == "escape" then
        love.event.quit()
    end
end

testRoom = map.createRoom({
    { 0, 0, 0, 0, 0, 0, 0 },
    { 0, 2, 2, 2, 2, 2, 0 },
    { 0, 2, 1, 1, 1, 1, 0 },
    { 0, 2, 1, 1, 1, 1, 0 },
    { 0, 0, 0, 0, 0, 0, 0 },
})
 
-- Draw a coloured rectangle.
function love.draw()
    map.drawRoom(testRoom)
end
