local entity = require "game.entity"
local movement = require "game.movement"
local assets = require "game.assets"
local coords = require "game.coords"

local player = {}

function player.new(initialRoomInstance)
    local player = {
        currentRoomInstance = initialRoomInstance,
        currentTileX = 3,
        currentTileY = 3,
    }

    local cube = entity.new(assets.cube, player.currentTileX, player.currentTileY, 0, 1, 1)
    initialRoomInstance.room:addEntity(cube)

    function player:update(dt, cam, entities)
        -- Just pick one
        local playerInstance = cube.instances[1]

        -- Maybe we actually want to control the instance of the cube
        -- and not sort of the object itself...? Doesn't really make
        -- a difference, I suppose.
        movement.move(cube, 2.0, dt)
        cam.x, cam.y = playerInstance:getX(), playerInstance:getY()
    end

    function player:keyPress(key, entities)
        if key == "space" then
            tx, ty = coords.tile(cube.x, cube.y)
            local es = entities:findAtTile(tx, ty, cube.id)

            -- Change color on found tiles for testing
            for i, e in ipairs(es) do
                e.color = {1, 0, 0}
            end
        end
    end

    return player
end


return player
