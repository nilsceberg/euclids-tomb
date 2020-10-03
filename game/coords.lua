local graphics = require "game.graphics"

local coords = {}

function coords.worldToScreen(x, y)
    return x * graphics.TILE_WIDTH / 2 - y * graphics.TILE_WIDTH / 2,
        y * graphics.TILE_HEIGHT / 2 + x * graphics.TILE_HEIGHT / 2
end

return coords
