local graphics = require "game.graphics"

local coords = {}

function coords.worldToScreen(x, y, z, rotation)
    rotation = rotation or 0
    z = z or 0
    return x * graphics.TILE_WIDTH / 2 - y * graphics.TILE_WIDTH / 2,
        y * graphics.TILE_HEIGHT / 2 + x * graphics.TILE_HEIGHT / 2 - z * graphics.TILE_HEIGHT
end

function coords.screenToWorld(x, y, zw, rotation)
    rotation = rotation or 0
    local yw = y / graphics.TILE_HEIGHT - x / graphics.TILE_WIDTH
    local xw = x / graphics.TILE_WIDTH + y / graphics.TILE_HEIGHT
    return xw, yw, zw or 0
end

return coords
