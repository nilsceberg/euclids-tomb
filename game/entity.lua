entity = {}

local uuid = require "uuid"

local coords = require "game.coords"

local entity = {}

function entity.new(asset, x, y, z, d, layer, autofade)
    local object = {
        asset = asset,
        x = x,
        y = y,
        z = z or 0,
        d = d or 0,
        layer = layer or 0,
        id = uuid.new(),
        instances = {},
        color = {1,1,1},
        autofade = autofade or false
    }

    setmetatable(object, {
        __tostring = function(self)
            return "Entity"
        end
    })

    function object:instantiate(rotation, ox, oy, oz, roomInstance)
        local instance = {
            id = uuid.new(),
            entity = object,
            roomInstance = roomInstance,
            rotation = rotation,
        }

        setmetatable(instance, {
            __tostring = function(self)
                return "EntityInstance"
            end
        })

        function instance:getX()
            local rx, ry = coords.rotate(object.x, object.y, rotation)
            return rx + ox
        end

        function instance:getY()
            local rx, ry = coords.rotate(object.x, object.y, rotation)
            return ry + oy
        end

        function instance:getZ()
            return object.z + oz
        end

        function instance:draw(camera, context)
            local r, g, b = unpack(self.entity.color)

            if self.roomInstance.id ~= context.player.currentRoomInstance.id then
                local fowDistance = math.sqrt((self.roomInstance.anchor.x - self.entity.x)^2 + (self.roomInstance.anchor.y - self.entity.y)^2)

                local FOW_RANGE = 2
                fowFactor = 1 - math.min(fowDistance, FOW_RANGE) / FOW_RANGE

                r = r * fowFactor
                g = g * fowFactor
                b = b * fowFactor
            end

            --if self.entity.autofade then
            --    local tx, ty = coords.tile(self:getX(), self.getY())
            --    local shadowed = context.entities:findAtTile(tx - 1, ty - 1)
            --    for i, entity in ipairs(shadowed) do
            --        if entity.roomInstance.active then
            --            return
            --        end
            --    end
            --end

            love.graphics.setColor(r, g, b)
            local cx, cy = camera:getOffset()
            local sx, sy = coords.worldToScreen(self:getX(), self:getY(), self:getZ())
            object.asset:draw(cx + sx - object.asset.originX, cy + sy - object.asset.originY, rotation)
            love.graphics.setColor(1, 1, 1)
        end

        table.insert(object.instances, instance)

        return instance
    end

    return object
end

function compareDepth(a, b)
    local sxa, sya = coords.worldToScreen(a:getX(), a:getY(), a:getZ())
    local sxb, syb = coords.worldToScreen(b:getX(), b:getY(), b:getZ())

    -- Priority: layer, screen y, world z, explicit depth, screen x
    if a.entity.layer ~= b.entity.layer then
        return a.entity.layer < b.entity.layer
    elseif sya ~= syb then
        return sya < syb
    elseif a:getZ() ~= b:getZ() then
        return a:getZ() < b:getZ()
    elseif a.entity.d ~= b.entity.d then
        return a.entity.d < b.entity.d
    elseif sxa ~= sxb then
        return sxa < sxb
    end

    return a.entity.id < b.entity.id
end

function entity.list()
    local list = {
        entities = {},
    }

    function list:clear()
        self.entities = {}
    end

    function list:sort()
        table.sort(self.entities, compareDepth)
    end

    function list:add(entity)
        table.insert(self.entities, entity)
    end

    function list:get(id)
        for i, v in ipairs(self.entities) do
            if v.id == id then
                return v, i
            end
        end
        return nil
    end

    function list:remove(id)
        local e, i = self:get(id)
        table.remove(self.entities, i)
    end

    function list:getInstanceByEntityId(id)
        for i, v in ipairs(self.entities) do
            if v.entity.id == id then
                return v, i
            end
        end
        return nil
    end

    function list:removeInstanceByEntityId(id)
        local e, i = self:getInstanceByEntityId(id)
        table.remove(self.entities, i)
    end

    function list:addMany(other)
        for i, v in ipairs(other.entities) do
            if self:get(v.id) == nil then
                table.insert(self.entities, v)
            end
        end
    end

    function list:show()
        for k, v in ipairs(self.entities) do
            print(k .. ": " .. tostring(v))
        end
    end

    function list:draw(camera, context)
        for k, v in ipairs(self.entities) do
            v:draw(camera, context)
        end
    end

    -- Assumes EntityInstances
    -- Why, oh why, do I use the same structure for both types?
    function list:findAtTile(x, y, excludeId)
        local results = {}
        for k, e in ipairs(self.entities) do
            local ex, ey = coords.tile(e:getX(), e:getY())
            if e.entity.id ~= excludeId and x == ex and y == ey then
                table.insert(results, e)
            end
        end
        return results
    end

    return list
end

return entity
