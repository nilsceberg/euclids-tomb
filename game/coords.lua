local graphics = require "game.graphics"

local coords = {}

function coords.worldToScreen(x, y, z)
    z = z or 0
    return x * graphics.TILE_WIDTH / 2 - y * graphics.TILE_WIDTH / 2,
        y * graphics.TILE_HEIGHT / 2 + x * graphics.TILE_HEIGHT / 2 + z * graphics.TILE_HEIGHT
end

return coords
