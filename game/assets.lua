local graphics = require "game.graphics"

ASSET_PATH="out/assets/"

function loadImage(name_or_rot0, layer_or_rot1, rot2, rot3, layer)
    local asymmetric = type(layer_or_rot1) == "string"
    layer = asymmetric and layer or layer_or_rot1

    local images = {}
    if not asymmetric then
        local image = love.graphics.newImage(ASSET_PATH .. name_or_rot0 .. ".png")
        table.insert(images, image)
        table.insert(images, image)
        table.insert(images, image)
        table.insert(images, image)
    else
        table.insert(images, love.graphics.newImage(ASSET_PATH .. name_or_rot0 .. ".png"))
        table.insert(images, love.graphics.newImage(ASSET_PATH .. layer_or_rot1 .. ".png"))
        table.insert(images, love.graphics.newImage(ASSET_PATH .. rot2 .. ".png"))
        table.insert(images, love.graphics.newImage(ASSET_PATH .. rot3 .. ".png"))
    end

    for i, image in ipairs(images) do
        image:setFilter("nearest", "nearest")
    end

    local asset = {
        images = images,
        layer = layer,
    }

    -- Assume they're all the same size
    asset.originX = asset.images[1]:getWidth() / 2
    asset.originY = asset.images[1]:getHeight() - graphics.TILE_HEIGHT / 2

    function asset:draw(x, y, r)
        love.graphics.draw(asset.images[r + 1], x, y)
    end

    return asset
end

return {
    tile = loadImage("tile", 0),
    trigger = loadImage("trigger", 0),
    wall = loadImage("wall", 1),
    pillar = loadImage("pillar", 1),
    cube = loadImage("cube", 1),
    compass = loadImage("compass-0", "compass-1", "compass-2", "compass-3", 1),

    backgroundMusic = love.audio.newSource(ASSET_PATH .. "ost.mp3", "static"),
}
