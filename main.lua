local assets = require "game.assets"
local map = require "game.map"
local entity = require "game.entity"
local graphics = require "game.graphics"
local camera = require "game.camera"
local movement = require "game.movement"
local audio = require "game.audio"
local player = require "game.player"
local coords = require "game.coords"
local rooms = require "game.rooms"

local t = 0
local N = 0

-- Load some default values for our rectangle.
function love.load()
end

local audioController = audio.controller()

local cam = camera.new()

local font = love.graphics.getFont()
local settings = love.graphics.newText(font, "Settings")

local entities = entity.list()
entities.rebuild = true

print("Instantiating room 1")
local startRoom = rooms.intro:instantiate(map.anchor(0, 0, 0, 0, nil), 0)

print("Creating player")
local player = player.new(startRoom)

local editTile = 1

local globalContext = {
    player = player,
    entities = entities,
}

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif tonumber(key) ~= nil then
        editTile = tonumber(key)
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

        entities:addMany(player.currentRoomInstance.entities)
        for i, connected in ipairs(player.currentRoomInstance.connectedInstances) do
            entities:addMany(connected.entities)
        end

        --player.currentRoomInstance.room:addAllEntityInstancesTo(entities)
        entities.rebuild = false
    end

    if love.mouse.isDown(1) then
        handleMouseDown(love.mouse.getX(), love.mouse.getY())
    end
end

function love.draw()
    love.graphics.scale(graphics.SCALE, graphics.SCALE)

    entities:sort()
    entities:draw(cam, globalContext)

    if devMode then
        local editTileImage = nil
        if editTile == 1 then
            editTileImage = assets.tile.images[1]
        elseif editTile == 2 then
            editTileImage = assets.wall.images[1]
        elseif editTile == 3 then
            editTileImage = assets.pillar.images[1]
        end
        if editTileImage then
            love.graphics.draw(editTileImage, 10, 10)
        end

        love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
    end

--    love.graphics.setColor(0.3, 0.3, 0.3)
--    love.graphics.rectangle("fill", 10, 10, 64, 32)
--    love.graphics.setColor(1.0, 1.0, 1.0)
--    love.graphics.draw(settings, 20, 20)
end

function love.mousepressed(x, y, button)
end

function handleMouseDown(x, y)
    x = x / 2
    y = y / 2

    cx, cy = cam:getOffset()
    wx, wy = coords.screenToWorld(x - cx, y - cy)
    tx, ty = coords.tile(wx, wy)

    if devMode then
        player.currentRoomInstance:setTile(tx, ty, editTile, entities)
    end

    --if x > 10 and x < 74 and y > 10 and y < 42 then
    --    (require "os").execute("gnome-terminal -- vim conf.lua")
    --end
end
