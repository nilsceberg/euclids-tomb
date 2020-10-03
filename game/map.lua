local assets = require "game.assets"
local coords = require "game.coords"
local graphics = require "game.graphics"

map = {}

function map.createRoom(tiles)
    return {
        tiles = tiles,
        width = #tiles[1],
        height = #tiles,
    }
end

function map.drawRoom(room)
    ox = 256 
    oy = 64

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
                local sx, sy = coords.worldToScreen(x, y)
                love.graphics.draw(
                    asset.image,
                    ox + sx - asset.originX,
                    oy + sy - asset.originY
                )
            end
        end
    end
end

return map
