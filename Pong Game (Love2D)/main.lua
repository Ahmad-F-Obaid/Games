-- Pong Game in Love2D - Part 1
-- Window, paddles, and movement setup

-- Game constants (avoid magic numbers)
local SCREEN_WIDTH = 800
local SCREEN_HEIGHT = 600
local PADDLE_WIDTH = 20
local PADDLE_HEIGHT = 100
local BALL_SIZE = 20
local PADDLE_SPEED = 300

-- Game state tables
local player1 = {}
local player2 = {}
local ball = {}

-- Called once on game startup
function love.load()
    -- Set window title and dimensions
    love.window.setTitle("Pong Game")
    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)

    -- Near-black dark background (0.1, 0.1, 0.1)
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

    -- Initialize left paddle (Player 1)
    player1 = {
        x = 50,
        y = (SCREEN_HEIGHT - PADDLE_HEIGHT) / 2,
        width = PADDLE_WIDTH,
        height = PADDLE_HEIGHT,
        speed = PADDLE_SPEED
    }

    -- Initialize right paddle (Player 2)
    player2 = {
        x = SCREEN_WIDTH - 50 - PADDLE_WIDTH,
        y = (SCREEN_HEIGHT - PADDLE_HEIGHT) / 2,
        width = PADDLE_WIDTH,
        height = PADDLE_HEIGHT,
        speed = PADDLE_SPEED
    }

    -- Initialize ball at the center of the screen
    ball = {
        x = (SCREEN_WIDTH - BALL_SIZE) / 2,
        y = (SCREEN_HEIGHT - BALL_SIZE) / 2,
        width = BALL_SIZE,
        height = BALL_SIZE,
        size = BALL_SIZE
    }
end

-- Called every frame with delta time (dt in seconds)
function love.update(dt)
    -- Movement speed is in pixels/second.
    -- Multiplying by dt ensures frame-rate independence so the game runs consistently across fast and slow machines.

    -- Player 1 movement (W: Up, S: Down)
    if love.keyboard.isDown("w") then
        player1.y = player1.y - player1.speed * dt
    elseif love.keyboard.isDown("s") then
        player1.y = player1.y + player1.speed * dt
    end

    -- Player 2 movement (Up Arrow: Up, Down Arrow: Down)
    if love.keyboard.isDown("up") then
        player2.y = player2.y - player2.speed * dt
    elseif love.keyboard.isDown("down") then
        player2.y = player2.y + player2.speed * dt
    end

    -- Clamp paddles to the screen boundaries so they cannot move out of bounds
    player1.y = math.max(0, math.min(player1.y, SCREEN_HEIGHT - player1.height))
    player2.y = math.max(0, math.min(player2.y, SCREEN_HEIGHT - player2.height))
end

-- Called every frame to render game objects (pure rendering, no state mutation)
function love.draw()
    -- Draw dashed net center line in white
    love.graphics.setColor(1, 1, 1)
    for y = 0, SCREEN_HEIGHT, 30 do
        love.graphics.rectangle("fill", (SCREEN_WIDTH / 2) - 5, y, 10, 15)
    end

    -- Draw Player 1 paddle (left)
    love.graphics.rectangle("fill", player1.x, player1.y, player1.width, player1.height)

    -- Draw Player 2 paddle (right)
    love.graphics.rectangle("fill", player2.x, player2.y, player2.width, player2.height)

    -- Draw static centered ball
    love.graphics.rectangle("fill", ball.x, ball.y, ball.width, ball.height)
end
