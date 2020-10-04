local assets = require "game.assets"
local map = require "game.map"
local entity = require "game.entity"
local graphics = require "game.graphics"
local camera = require "game.camera"
local movement = require "game.movement"
local audio = require "game.audio"
local player = require "game.player"

local t = 0
local N = 0

-- Load some default values for our rectangle.
function love.load()
end

local audioController = audio.controller()
 
local testRoom = map.new({
    { 0, 2, 2, 2, 0, 0, 0 },
    { 0, 2, 1, 2, 2, 2, 2 },
    { 0, 0, 1, 1, 1, 1, 0 },
    { 0, {1}, 1, {1, 5}, 1, 1, 0 },
    { 0, 2, 1, 1, 1, 1, 0 },
    { 0, 2, 1, 1, {1, 3}, 1, 0 },
    { 0, 2, 1, 1, 1, 1, 0 },
    { 0, 2, 0, 0, {1}, 0, 0 },
})

local cam = camera.new()

local font = love.graphics.getFont()
local settings = love.graphics.newText(font, "Settings")

local entities = entity.list()
entities.rebuild = true

print("Instantiating room 1")
local room1 = testRoom:instantiate(map.anchor(0, 0, 0, 0, nil), 0)

print("Creating player")
local player = player.new(room1)

testRoom:connect(map.connection(
    4, 8, 1, 3, testRoom, 1
))
testRoom:connect(map.connection(
    1, 3, 4, 8, testRoom, -1
))

local globalContext = {
    player = player
}

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    else
        player:keyPress(key, entities)
    end
end

function love.update(dt)
    t = t + dt
    player:update(dt, cam, entities)

    if entities.rebuild then
        print("Rebuilding main entity list")
        entities:clear()
        testRoom:addAllEntityInstancesTo(entities)
        entities.rebuild = false
    end
end

function love.draw()
    love.graphics.scale(graphics.SCALE, graphics.SCALE)

    entities:sort()
    entities:draw(cam, globalContext)

--    love.graphics.setColor(0.3, 0.3, 0.3)
--    love.graphics.rectangle("fill", 10, 10, 64, 32)
--    love.graphics.setColor(1.0, 1.0, 1.0)
--    love.graphics.draw(settings, 20, 20)
end

function love.mousepressed(x, y, button)
    x = x / 2
    y = y / 2
    print(x, y)
    if x > 10 and x < 74 and y > 10 and y < 42 then
        (require "os").execute("gnome-terminal -- vim conf.lua")
    end
end
