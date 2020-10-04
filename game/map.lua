local assets = require "game.assets"
local coords = require "game.coords"
local graphics = require "game.graphics"
local entity = require "game.entity"

local uuid = require "uuid"

map = {}

function map.anchor(x, y, gx, gy)
    return {
        x = x,
        y = y,
        gx = gx,
        gy = gy,
    }
end

function map.new(tiles)
    local room = {
        tiles = tiles,
        width = #tiles[1],
        height = #tiles,
        entities = entity.list(),
        instances = {}
    }

    for y=0,room.height-1 do
        for x=0,room.width-1 do
            local tileTypes = room.tiles[y + 1][x + 1]
            if type(tileTypes) ~= "table" then
                tileTypes = {tileTypes}
            end

            for depth, tileType in ipairs(tileTypes) do
                local asset = nil
                if tileType == 1 then
                    asset = assets.tile
                elseif tileType == 2 then
                    asset = assets.wall
                elseif tileType == 3 then
                    asset = assets.pillar
                elseif tileType == 4 then
                    asset = assets.trigger
                end

                --local rx, ry = rotateCoords(x, y, rotation)

                if asset ~= nil then
                    -- TODO: use the same entities
                    --local e = entity.new(asset, rx + ox, ry + oy, 0, depth, layer)
                    local e = entity.new(asset, x, y, 0, depth, asset.layer)
                    room.entities:add(e)
                end
            end
        end
    end

    function room:instantiate(anchor, rotation)
        local instance = {
            uuid = uuid.new(),
            room = room,
            anchor = anchor or map.anchor(0, 0, 0, 0),
            rotation = rotation or 0,
            entities = entity.list(),
        }

        local rax, ray = coords.rotate(instance.anchor.x, instance.anchor.y, rotation)
        local ox, oy = instance.anchor.gx - rax, instance.anchor.gy - ray

        function instance:addEntity(entity)
            self.entities:add(
                entity:instantiate(rotation, ox, oy, 0, instance)
            )
        end

        print("Copying entities from parent room")
        for k, v in ipairs(room.entities.entities) do
            print("Adding " .. k)
            instance:addEntity(v)
        end

        print("Adding self to parent")
        table.insert(room.instances, instance)

        return instance
    end

    function room:addEntity(entity)
        self.entities:add(entity)
        for i, instance in ipairs(self.instances) do
            instance:addEntity(entity)
        end
    end

    function room:addAllEntityInstancesTo(list)
        for i, instance in ipairs(self.instances) do
            list:addMany(instance.entities)
        end
    end

    return room
end

return map
