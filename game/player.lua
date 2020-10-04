local entity = require "game.entity"
local movement = require "game.movement"
local assets = require "game.assets"

local player = {}

function player.new(initialRoomInstance)
    local player = {
        currentRoomInstance = initialRoomInstance
    }

    local cube = entity.new(assets.cube, 3, 3, 0, 1, 1)
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

    function player:keyPress(key)
        if key == "space" then

        end
    end

    return player
end


return player
