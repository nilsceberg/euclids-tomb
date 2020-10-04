local coords = require "game.coords"

local movement = {}

function movement.move(instance, speed, dt)
    local vx = 0
    local vy = 0

    if love.keyboard.isDown("w") then
        vy = vy - 1
    end
    if love.keyboard.isDown("s") then
        vy = vy + 1
    end
    if love.keyboard.isDown("a") then
        vx = vx - 1
    end
    if love.keyboard.isDown("d") then
        vx = vx + 1
    end

    if vx == 0 and vy == 0 then
        return false
    end

    vy = vy / 2

    vx, vy = coords.screenToWorld(vx, vy)

    l = math.sqrt(vx^2 + vy^2)
    vx = vx / l
    vy = vy / l

    -- rotate movement vector in opposite direction from room rotation
    -- so that screen directions are preserved
    vx, vy = coords.rotate(vx, vy, -instance.roomInstance.rotation)

    instance.entity.x = instance.entity.x + speed * vx * dt
    instance.entity.y = instance.entity.y + speed * vy * dt

    return true
end

return movement