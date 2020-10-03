local coords = require "game.coords"
local graphics = require "game.graphics"

local camera = {}

function camera.new()
    local cam = {
        x = 0,
        y = 0,
    }

    function cam:getOffset()
        local sx, sy = coords.worldToScreen(-self.x, -self.y)
        local wsx, wsy = love.graphics.getDimensions()
        sx = sx + wsx / graphics.SCALE / 2
        sy = sy + wsy / graphics.SCALE / 2
        return sx, sy
    end

    return cam
end

return camera
