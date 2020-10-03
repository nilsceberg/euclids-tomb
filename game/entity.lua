entity = {}

local map = require "game.map"
local coords = require "game.coords"

function entity.new(asset, x, y)
    local object = {
        asset = asset,
        x = x,
        y = y,
    }

    function object:draw()
        local sx, sy = coords.worldToScreen(self.x, self.y)
        love.graphics.draw(self.asset.image, sx - self.asset.originX, sy - self.asset.originY)
    end

    return object
end

return entity
