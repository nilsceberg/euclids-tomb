ASSETS = require "game.assets"

TILE_WIDTH = 64
TILE_HEIGHT = 32

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
                love.graphics.draw(
                    asset,
                    ox + x * TILE_WIDTH / 2 - y * TILE_WIDTH / 2,
                    oy + y * TILE_HEIGHT / 2 + x * TILE_HEIGHT / 2
                )
            end
        end
    end
end

return map
