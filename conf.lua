local version = _VERSION:match("%d+%.%d+")
package.path = 'lua_modules/share/lua/5.4/?.lua;lua_modules/share/lua/' .. version .. '/?/init.lua;' .. package.path
package.cpath = 'lua_modules/lib/lua/5.4/?.so;' .. package.cpath

devMode = false

function love.conf(t)
    t.window.title = "Euclid's Tomb"
    --t.window.width = 1280
    --t.window.height = 780
    t.window.fullscreen = true
end