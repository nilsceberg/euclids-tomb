ASSET_PATH="out/assets/"

function loadImage(name)
    local asset = love.graphics.newImage(ASSET_PATH .. name .. ".png")
    asset:setFilter("nearest", "nearest")
    return asset
end

return {
    tile = loadImage("tile"),
    wall = loadImage("wall"),
}
