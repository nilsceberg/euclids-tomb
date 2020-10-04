local graphics = require "game.graphics"

ASSET_PATH="out/assets/"

function loadImage(name)
    local asset = {
        image = love.graphics.newImage(ASSET_PATH .. name .. ".png"),
    }

    asset.originX = asset.image:getWidth() / 2
    asset.originY = asset.image:getHeight() - graphics.TILE_HEIGHT / 2
    asset.image:setFilter("nearest", "nearest")

    return asset
end

return {
    tile = loadImage("tile"),
    wall = loadImage("wall"),
    cube = loadImage("cube"),

    backgroundMusic = love.audio.newSource(ASSET_PATH .. "ost.mp3", "static"),
}
