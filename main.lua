local assets = require "game.assets"
local map = require "game.map"
local entity = require "game.entity"
local graphics = require "game.graphics"
local camera = require "game.camera"
local movement = require "game.movement"

local coroutine = require "coroutine"

print(ASSETS)

local t = 0
local N = 0

-- Load some default values for our rectangle.
function love.load()
    x, y, w, h = 20, 20, 60, 20
end
 
local testRoom = map.new({
    { 0, 2, 2, 2, 0, 0, 0 },
    { 0, 2, 1, 2, 2, 2, 2 },
    { 0, 0, 1, 1, 1, 1, 0 },
    { 0, 1, 1, 1, 1, 1, 0 },
    { 0, 2, 1, 1, 1, 1, 0 },
    { 0, 2, 1, 1, 2, 1, 0 },
    { 0, 2, 1, 1, 1, 1, 0 },
    { 0, 2, 0, 0, 1, 0, 0 },
})

local cube = entity.new(assets.cube, 3, 3, 0, 1, 1)
local cam = camera.new()

local font = love.graphics.getFont()
local settings = love.graphics.newText(font, "Settings")

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

-- Increase the size of the rectangle every frame.
function love.update(dt)
    w = w + 1
    h = h + 1
    t = t + dt

    -- Maybe we actually want to control the instance of the cube
    -- and not sort of the object itself...? Doesn't really make
    -- a difference, I suppose.
    movement.move(cube, 2.0, dt)
    cam.x, cam.y = cube.x, cube.y
end

local entities = entity.list()
--entities:add(cube:instantiate(0, 0, 0, 0))

testRoom.entities:add(cube)

local room1 = testRoom:instantiate(map.anchor(0, 0, 0, 0), 0)
entities:addMany(room1.entities)

local room2 = testRoom:instantiate(map.anchor(1, 3, 4, 8), 1)
entities:addMany(room2.entities)

local room3 = testRoom:instantiate(map.anchor(1, 3, -1, 11), 2)
entities:addMany(room3.entities)

local room4 = testRoom:instantiate(map.anchor(1, 3, -4, 6), 3)
entities:addMany(room4.entities)


-- Draw a coloured rectangle.
function love.draw()
    love.graphics.scale(graphics.SCALE, graphics.SCALE)

    entities:sort()
    entities:draw(cam)

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
