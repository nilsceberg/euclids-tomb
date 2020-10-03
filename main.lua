local assets = require "game.assets"
local map = require "game.map"
local entity = require "game.entity"

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

local testRoom = map.createRoom({
    { 0, 0, 0, 0, 0, 0, 0 },
    { 0, 2, 2, 2, 2, 2, 0 },
    { 0, 2, 1, 1, 1, 1, 0 },
    { 0, 1, 1, 1, 1, 1, 0 },
    { 0, 2, 1, 1, 1, 1, 0 },
    { 0, 2, 1, 1, 2, 1, 0 },
    { 0, 2, 1, 1, 1, 1, 0 },
    { 0, 0, 0, 0, 1, 0, 0 },
})

local cube = entity.new(assets.cube, 11, 4)

local font = love.graphics.getFont()
local settings = love.graphics.newText(font, "Settings")

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "w" then
        cube.x = cube.x - 1
    elseif key == "s" then
        cube.x = cube.x + 1
    elseif key == "a" then
        cube.y = cube.y + 1
    elseif key == "d" then
        cube.y = cube.y - 1
    end
end

-- Draw a coloured rectangle.
function love.draw()
    love.graphics.scale(2, 2)
    map.drawRoom(testRoom)

    cube:draw()

    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle("fill", 10, 10, 64, 32)
    love.graphics.setColor(1.0, 1.0, 1.0)
    love.graphics.draw(settings, 20, 20)
end

function love.mousepressed(x, y, button)
    x = x / 2
    y = y / 2
    print(x, y)
    if x > 10 and x < 74 and y > 10 and y < 42 then
        (require "os").execute("gnome-terminal -- vim conf.lua")
    end
end
