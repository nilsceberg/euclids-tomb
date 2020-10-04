local graphics = require "game.graphics"

ASSET_PATH="out/assets/"

function loadImage(name, layer)
    local asset = {
        image = love.graphics.newImage(ASSET_PATH .. name .. ".png"),
        layer = layer,
    }

    asset.originX = asset.image:getWidth() / 2
    asset.originY = asset.image:getHeight() - graphics.TILE_HEIGHT / 2
    asset.image:setFilter("nearest", "nearest")

    return asset
end

return {
    tile = loadImage("tile", 0),
    trigger = loadImage("trigger", 0),
    wall = loadImage("wall", 1),
    pillar = loadImage("pillar", 1),
    cube = loadImage("cube", 1),

    backgroundMusic = love.audio.newSource(ASSET_PATH .. "ost.mp3", "static"),
}
