local assets = require "game.assets"

local audio = {}

function audio.controller()
    local controller = {}

    local backgroundMusic = assets.backgroundMusic
    backgroundMusic:setLooping(true)
    backgroundMusic:play()

    return controller
end

return audio
