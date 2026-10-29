-- Love2D Window and Application Configuration
function love.conf(t)
    t.window.title = "Pong Game"
    t.window.width = 800
    t.window.height = 600
    t.window.resizable = false
    t.window.vsync = 1
    t.modules.audio = true
    t.modules.keyboard = true
    t.modules.timer = true
end
