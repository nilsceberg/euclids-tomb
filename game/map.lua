local assets = require "game.assets"
local coords = require "game.coords"
local graphics = require "game.graphics"
local entity = require "game.entity"

local coroutine = require "coroutine"

map = {}

function map.new(tiles)
    local room = {
        tiles = tiles,
        width = #tiles[1],
        height = #tiles,
        entities = entity.list()
    }

    for y=0,room.height-1 do
        for x=0,room.width-1 do
            local tileType = room.tiles[y + 1][x + 1]

            local asset = nil
            if tileType == 1 then
                asset = assets.tile
            elseif tileType == 2 then
                asset = assets.wall
            end

            if asset ~= nil then
                room.entities:add(entity.new(asset, x, y, 0))
            end
        end
    end

    room.entities:sort()

    function room:draw(camera)
        self.entities:draw(camera)
    end

    return room
end

return map
