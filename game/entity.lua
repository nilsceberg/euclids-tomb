entity = {}

local uuid = require "uuid"

local coords = require "game.coords"

local entity = {}

function entity.new(asset, x, y, z, d)
    local object = {
        asset = asset,
        x = x,
        y = y,
        z = z or 0,
        d = d or 0,
        uuid = uuid.new()
    }

    setmetatable(object, {
        __tostring = function(self)
            return (self.x .. ", " .. self.y)
        end
    })

    function object:draw(ox, oy)
        local sx, sy = coords.worldToScreen(self.x, self.y, self.z)
        love.graphics.draw(self.asset.image, ox + sx - self.asset.originX, oy + sy - self.asset.originY)
    end

    return object
end

function compareDepth(a, b)
    local sxa, sya = coords.worldToScreen(a.x, a.y, a.z)
    local sxb, syb = coords.worldToScreen(b.x, b.y, b.z)

    -- Priority: screen y, world z, explicit depth, screen x
    if sya ~= syb then
        return sya < syb
    elseif a.z ~= b.z then
        return a.z < b.z
    elseif a.d ~= b.d then
        return a.d < b.d
    elseif sxa ~= sxb then
        return sxa < sxb
    end

    return a.uuid < b.uuid
end

function entity.list()
    local list = {
        entities = {},
    }

    function list:sort()
        table.sort(self.entities, compareDepth)
    end

    function list:add(entity)
        table.insert(self.entities, entity)
    end

    function list:addMany(other)
        for i, v in ipairs(other.entities) do
            table.insert(self.entities, v)
        end
    end

    function list:show()
        for k, v in ipairs(self.entities) do
            print(k .. ": " .. tostring(v))
        end
    end

    function list:draw(ox, oy)
        for k, v in ipairs(self.entities) do
            v:draw(ox, oy)
        end
    end

    return list
end

return entity
