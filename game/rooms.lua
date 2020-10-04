local map = require "game.map"

local rooms = {}

rooms.intro = map.new({
    { 2, 2, 2, 2, 2, 2, 2, 2, 2 },
    { 2, 1, 1, 1, 1, 1, 1, 1, 2 },
    { 2, 1, {1, 3}, 1, {1, 3}, 1, {1, 3}, 1, 2 },
    { 1, 1, 1, 1, 1, 1, 1, 1, 2 },
    { 1, 1, 1, 1, 1, 1, {1, 3}, 1, 2 },
    { 1, 1, 1, 1, 1, 1, 1, 1, 2 },
    { 2, 1, {1, 3}, 1, 1, 1, {1, 3}, 1, 2 },
    { 2, 1, 1, 1, 1, 1, 1, 1, 2 },
    { 2, 1, {1, 3}, 1, 1, 1, {1, 3}, 1, 2 },
    { 2, 1, 1, 1, 1, 1, 1, 1, 2 },
    { 2, 1, {1, 3}, 1, 1, 1, {1, 3}, 1, 2 },
    { 2, 1, 1, 1, 1, 1, 1, 1, 2 },
    { 2, 2, 2, 1, 1, 1, 2, 2, 2 },
}, "intro", function(player, to, from)
    if from == nil then return end

    if (to.rotation - from.rotation) % 4 == 1 then
        rooms.intro.laps = rooms.intro.laps + 1
    elseif (to.rotation - from.rotation) % 4 == 3 then
        rooms.intro.laps = math.max(0, rooms.intro.laps - 1)
    end

    if rooms.intro.laps == 8 then
        rooms.intro:connect(map.connection(
            5, 13, 0, 4, rooms.hall, 1
        ))
    end

    print("Laps: ", rooms.intro.laps)
end)
rooms.intro.laps = 0

rooms.hall = map.new({
    { 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2 },
    { 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2 },
    { 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2 },
    { 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2 },
    { 1, 1, 1, 1, {1, 3}, 2, {1, 3}, 1, 1, 1, 2 },
    { 1, 1, 1, 1, 2, 2, 2, 1, 1, 1, 1 },
    { 1, 1, 1, 1, {1, 3}, 2, {1, 3}, 1, 1, 1, 2 },
    { 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2 },
    { 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2 },
    { 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2 },
    { 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2 },
})

rooms.grave = map.new({
    { 2, 2, 2, 2, 1, 2, 2, 2, 2 },
    { 2, 1, 1, 1, 1, 1, 1, 1, 2 },
    { 2, 1, {1, 3}, 1, 1, 1, {1, 3}, 1, 2 },
    { 2, 1, 1, 1, 1, 1, 1, 1, 2 },
    { 2, 1, 1, 1, 1, 1, 1, 1, 2 },
    { 2, 1, {1, 3}, 1, 1, 1, {1, 3}, 1, 2 },
    { 2, 1, 1, 1, 1, 1, 1, 1, 2 },
    { 2, 1, 1, 1, 2, 1, 1, 1, 2 },
    { 2, 1, {1, 3}, 1, 2, 1, {1, 3}, 1, 2 },
    { 2, 1, 1, 1, 1, 1, 1, 1, 2 },
    { 2, 2, 2, 2, 2, 2, 2, 2, 2 },
})

-- Change to this when loop taken
--rooms.intro:connect(map.connection(
--    5, 13, 0, 4, rooms.hall, 1
--))
rooms.intro:connect(map.connection(
    5, 13, 0, 3, rooms.intro, 1
))
rooms.intro:connect(map.connection(
    0, 3, 5, 13, rooms.intro, -1
))

rooms.hall:connect(map.connection(
    5, 11, 5, 10, rooms.hall, 2
))
rooms.hall:connect(map.connection(
    5, -1, 5, 0, rooms.hall, 2
))
rooms.hall:connect(map.connection(
    0, 5, 4, 13, rooms.intro, -1
))
rooms.hall:connect(map.connection(
    11, 5, 5, 10, rooms.hall, 1
))

rooms.grave:connect(map.connection(
    4, 0, 5, 11, rooms.hall, 0
))

return rooms
