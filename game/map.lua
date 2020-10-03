local assets = require "game.assets"
local coords = require "game.coords"
local graphics = require "game.graphics"
local entity = require "game.entity"

local coroutine = require "coroutine"

map = {}

function map.anchor(x, y, gx, gy)
    return {
        x = x,
        y = y,
        gx = gx,
        gy = gy,
    }
end

function rotateCoords(x, y, rot)
    if rot == 0 then
        return x, y
    elseif rot == 1 then
        return -y, x
    elseif rot == 2 then
        return -x, -y
    else
        return y, -x
    end
end

function map.new(tiles)
    local room = {
        tiles = tiles,
        width = #tiles[1],
        height = #tiles,
        entities = entity.list(),
    }

    function room:instantiate(anchor, rotation)
        local instance = {
            room = room,
            anchor = anchor or map.anchor(0, 0, 0, 0),
            rotation = rotation or 0,
            entities = entity.list(),
        }

        local rax, ray = rotateCoords(instance.anchor.x, instance.anchor.y, rotation)
        local ox, oy = instance.anchor.gx - rax, instance.anchor.gy - ray

        for y=0,room.height-1 do
            for x=0,room.width-1 do
                local tileType = room.tiles[y + 1][x + 1]

                local asset = nil
                if tileType == 1 then
                    asset = assets.tile
                elseif tileType == 2 then
                    asset = assets.wall
                end

                local layer = 0
                if tileType == 2 then
                    layer = 1
                end

                local rx, ry = rotateCoords(x, y, rotation)

                if asset ~= nil then
                    -- TODO: use the same entities
                    local e = entity.new(asset, rx + ox, ry + oy, 0, depth, layer)
                    instance.entities:add(e)
                end
            end
        end

        return instance
    end

    return room
end

return map
