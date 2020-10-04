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

function coords.rotate(x, y, rot)
    rot = rot % 4
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

function coords.tile(x, y)
    return math.floor(x + 0.5), math.floor(y + 0.5)
end

function coords.mapRoom(old, new, x, y)
    local wx, wy = coords.instanceToWorld(old, x, y)
    return coords.worldToInstance(new, wx, wy)
end

function coords.instanceToWorld(instance, x, y)
    if instance == nil then
        instance = {
            rotation = 0,
            offsetX = 0,
            offsetY = 0,
        }
    end
    x, y = coords.rotate(x, y, instance.rotation)
    return x + instance.offsetX, y + instance.offsetY
end

function coords.worldToInstance(instance, x, y)
    if instance == nil then
        instance = {
            rotation = 0,
            offsetX = 0,
            offsetY = 0,
        }
    end
    x, y = x - instance.offsetX, y - instance.offsetY
    return coords.rotate(x, y, -instance.rotation)
end

return coords
