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

    initialRoomInstance:enter(nil)

    function player:update(dt, cam, entities)
        -- Just pick one
        local playerInstance = player.currentRoomInstance.entities:getInstanceByEntityId(cube.id)

        movement.move(playerInstance, 3.0, dt)
        cam.x, cam.y = playerInstance:getX(), playerInstance:getY()

        local ntx, nty = coords.tile(playerInstance:getX(), playerInstance:getY())

        if not (ntx == player.currentTileX and nty == player.currentTileY) then
            player.currentTileX, player.currentTileY = ntx, nty
            print("Player moved to ", player.currentTileX, player.currentTileY)

            local es = entities:findAtTile(ntx, nty, cube.id)
            if #es > 0 and es[1].roomInstance.id ~= player.currentRoomInstance.id then
                local newRoom = es[1].roomInstance
                print("Moved to room ", newRoom.room)

                player.currentRoomInstance.room:removeEntity(cube)

                -- Recalculate coordinates relative to new room instance
                cube.x, cube.y = coords.mapRoom(player.currentRoomInstance, newRoom, cube.x, cube.y)

                newRoom.room:addEntity(cube)

                newRoom:enter(player.currentRoomInstance, player)
                player.currentRoomInstance = newRoom

                entities.rebuild = true
            end
        end

        self.currentRoomInstance:update(dt)
        for i, roomInstance in ipairs(self.currentRoomInstance.connectedInstances) do
            roomInstance:update(dt)
        end
    end

    function player:keyPress(key, entities)
        if key == "space" then
            tx, ty = coords.tile(cube.x, cube.y)
            local es = entities:findAtTile(tx, ty, cube.id)

            -- Change color on found tiles for testing
            for i, e in ipairs(es) do
                --e.entity.color = {1, 0, 0}
            end
        end
    end

    return player
end


return player
