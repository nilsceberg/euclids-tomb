local graphics = require "game.graphics"

ASSET_PATH="out/assets/"

function loadImage(name_or_rot0, layer_or_rot1, rot2, rot3, layer)
    local asymmetric = type(layer_or_rot1) ~= "number"
    layer = asymmetric and layer or layer_or_rot1

    local images = {}
    if not asymmetric then
        local image = love.graphics.newImage(ASSET_PATH .. name_or_rot0 .. ".png")
        table.insert(images, image)
        table.insert(images, image)
        table.insert(images, image)
        table.insert(images, image)
    else
        table.insert(images, name_or_rot0 and love.graphics.newImage(ASSET_PATH .. name_or_rot0 .. ".png") or 0)
        table.insert(images, layer_or_rot1 and love.graphics.newImage(ASSET_PATH .. layer_or_rot1 .. ".png") or 0)
        table.insert(images, rot2 and love.graphics.newImage(ASSET_PATH .. rot2 .. ".png") or 0)
        table.insert(images, rot3 and love.graphics.newImage(ASSET_PATH .. rot3 .. ".png") or 0)
    end

    for i, image in ipairs(images) do
        if image ~= 0 then
            image:setFilter("nearest", "nearest")
        end
    end

    local asset = {
        images = images,
        layer = layer,
    }

    -- Assume they're all the same size
    asset.originX = 0
    asset.originY = 0
    for i, image in ipairs(asset.images) do
        if image ~= 0 then
            asset.originX = image:getWidth() / 2
            asset.originY = image:getHeight() - graphics.TILE_HEIGHT / 2
            break
        end
    end

    function asset:draw(x, y, r)
        if asset.images[r + 1] ~= 0 then
            love.graphics.draw(asset.images[r + 1], x, y)
        end
    end

    return asset
end

return {
    tile = loadImage("tile", 0),
    trigger = loadImage("trigger", 0),

    wall = loadImage("wall", 1),
    wallNorth = loadImage("wall", nil, nil, "wall", 1),
    wallEast = loadImage(nil, nil, "wall", "wall", 1),
    wallSouth = loadImage(nil, "wall", "wall", nil, 1),
    wallWest = loadImage("wall", "wall", nil, nil, 1),

    pillar = loadImage("pillar", 1),
    cube = loadImage("cube", 1),
    compass = loadImage("compass-0", "compass-1", "compass-2", "compass-3", 1),

    backgroundMusic = love.audio.newSource(ASSET_PATH .. "ost.mp3", "static"),
}
