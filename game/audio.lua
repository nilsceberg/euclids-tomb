local assets = require "game.assets"

local audio = {}

function audio.controller()
    local controller = {}
    print("Master volume: ", masterVolume)

    local backgroundMusic = assets.backgroundMusic
    backgroundMusic:setLooping(true)
    backgroundMusic:setVolume(masterVolume)
    backgroundMusic:play()

    return controller
end

return audio
