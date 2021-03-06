local assets = require "game.assets"
local coords = require "game.coords"
local graphics = require "game.graphics"
local entity = require "game.entity"

local uuid = require "uuid"
local io = require "io"

map = {}

function printMap(tiles)
    print("{")
    for y=1,#tiles do
        io.write("{ ")
        for x=1,#tiles[y] do
            if type(tiles[y][x]) == "table" then
                io.write("{ ")
                for d=1,#tiles[y][x] do
                    io.write(tostring(tiles[y][x][d]))
                    if d ~= #tiles[y][x] then
                        io.write(", ")
                    end
                end
                io.write(" }")
            else
                io.write(tostring(tiles[y][x]))
            end
            if x ~= #tiles[y] then
                io.write(", ")
            end
        end
        print(" },")
    end
    print("}")
end

function map.anchor(x, y, gx, gy, instance)
    return {
        x = x,
        y = y,
        gx = gx,
        gy = gy,
        instance = instance,
    }
end

function map.connection(outX, outY, inX, inY, intoRoom, relativeRotation)
    return {
        outX = outX,
        outY = outY,
        inX = inX,
        inY = inY,
        intoRoom = intoRoom,
        relativeRotation = relativeRotation,
    }
end

function isWall(tileType)
    return tileType == 2 or tileType == 5
end

function addMapEntity(x, y, depth, tileType, room, rotation)
    local asset = nil
    if tileType == 1 then
        asset = assets.tile
    elseif tileType == 2 then
        asset = assets.wall
        if y == 0 and isWall(room.tiles[y+1][x+1 - 1]) and isWall(room.tiles[y+1][x+1 + 1]) then
            asset = assets.wallNorth
        elseif x == room.width-1  and isWall(room.tiles[y+1 - 1][x+1]) and isWall(room.tiles[y+1 + 1][x+1])then
            asset = assets.wallEast
        elseif y == room.height-1 and isWall(room.tiles[y+1][x+1 - 1]) and isWall(room.tiles[y+1][x+1 + 1]) then
            asset = assets.wallSouth
        elseif x == 0 and isWall(room.tiles[y+1 - 1][x+1]) and isWall(room.tiles[y+1 + 1][x+1]) then
            asset = assets.wallWest
        end
    elseif tileType == 3 then
        asset = assets.pillar
    elseif tileType == 4 then
        asset = assets.trigger
    elseif tileType == 5 then
        asset = assets.backWall
    elseif tileType == 6 then
        asset = assets.lever
    end

    if asset ~= nil then
        local e = entity.new(asset, x, y, 0, depth, asset.layer, tileType == 2, true, rotation)
        room:addEntity(e)
    end
end

function map.new(tiles, name, onEnter)
    local room = {
        tiles = tiles,
        width = #tiles[1],
        height = #tiles,
        entities = entity.list(),
        instances = {},
        name = name,
        connections = {},
        onEnter = onEnter or function () end,
    }

    function room:instantiate(anchor, rotation)
        local instance = {
            id = uuid.new(),
            room = room,
            anchor = anchor or map.anchor(0, 0, 0, 0),
            rotation = rotation or 0,
            entities = entity.list(),
            connectedInstances = {},
            active = false,
            fow = true,
            fowRange = 0
        }

        local rax, ray = coords.rotate(anchor.x, anchor.y, rotation)
        local gx, gy = coords.instanceToWorld(anchor.instance, anchor.gx, anchor.gy)
        local ox, oy = gx - rax, gy - ray
        
        -- avoid memory leak
        anchor.instance = nil

        print(gx, gy)
        print(ox, oy)

        instance.offsetX = ox
        instance.offsetY = oy

        function instance:update(dt)
            if self.active then
                self.fowRange = self.fowRange + 10 * dt --* (1 + 2 * dt)
            end
            if self.fowRange > 100.0 then
                self.fow = false
            end
        end

        function instance:addEntity(entity)
            self.entities:add(
                entity:instantiate(rotation, ox, oy, 0, instance)
            )
        end

        function instance:removeEntity(entity)
            self.entities:removeInstanceByEntityId(entity.id)
        end

        function instance:connect(c)
            if not self.active then
                return
            end

            -- if another room is connected here, remove it
            for i, connected in ipairs(self.connectedInstances) do
                if connected.anchor.gx == c.outX and connected.anchor.gy == c.outY then
                    table.remove(self.connectedInstances, i)
                    break
                end
            end

            local instance = c.intoRoom:instantiate(
                map.anchor(c.inX, c.inY, c.outX, c.outY, self),
                (c.relativeRotation + rotation) % 4 -- technically unnecessary but let's do it
            )
            table.insert(self.connectedInstances, instance)
        end
        
        function instance:enter(from, player)
            if from ~= nil then
                from.active = false
                from.connectedInstances = {}

                local keepSelf = false
                for i, instance in ipairs(from.connectedInstances) do
                    instance.room.instances = {}
                end

                from.room.instances = {}

                self.room.instances = { self }
            end

            self.active = true

            self.fowRange = player.visionRange
            self.room.onEnter(player, self, from)

            for k, conn in ipairs(room.connections) do
                instance:connect(conn)
            end
        end

        function instance:setTile(wx, wy, tileType, entities, rotation)
            local rx, ry = coords.worldToInstance(self, wx, wy)
            if rx < 0 or ry < 0 or rx >= self.room.width or ry >= self.room.height then
                return
            end

            local oldTiles = entities:findAtTile(wx, wy)
            for i, e in ipairs(oldTiles) do
                if e.entity.map then
                    print("Removing ", e)
                    self.room:removeEntity(e.entity)
                end
            end

            if tileType ~= 0 then
                addMapEntity(rx, ry, 0, tileType, self.room, rotation)
            end
            self.room.tiles[ry + 1][rx + 1] = tileType
            printMap(self.room.tiles)
            
            print(rx, ry)

            entities.rebuild = true
        end

        --print("Copying entities from parent room")
        for k, v in ipairs(room.entities.entities) do
            --print("Adding " .. k)
            instance:addEntity(v)
        end

        --print("Adding self to parent")
        table.insert(room.instances, instance)

        return instance
    end

    function room:connect(connection)
        -- if another room is connected here, remove it
        for i, c in ipairs(self.connections) do
            if connection.outX == c.outX and connection.outY == c.outY then
                table.remove(self.connections, i)
                break
            end
        end
        table.insert(self.connections, connection)
        for i, instance in ipairs(self.instances) do
            instance:connect(connection)
        end
    end

    function room:addEntity(entity)
        self.entities:add(entity)
        for i, instance in ipairs(self.instances) do
            instance:addEntity(entity)
        end
    end

    function room:removeEntity(entity)
        self.entities:remove(entity.id)
        for i, instance in ipairs(self.instances) do
            instance:removeEntity(entity)
        end

    end

    function room:addAllEntityInstancesTo(list)
        for i, instance in ipairs(self.instances) do
            list:addMany(instance.entities)
        end
    end

    for y=0,room.height-1 do
        for x=0,room.width-1 do
            local tileTypes = room.tiles[y + 1][x + 1]
            if type(tileTypes) ~= "table" then
                tileTypes = {tileTypes}
            end

            for depth, tileType in ipairs(tileTypes) do
                local rotation = 0
                if type(tileType) == "table" then
                    rotation = tileType[2]
                    tileType = tileType[1]
                end

                addMapEntity(x, y, depth, tileType, room, rotation)
            end
        end
    end

    return room
end

return map
