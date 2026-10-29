-- Pong Game in Love2D
-- Complete implementation including Phase 1, Phase 2, and Phase 3 (Own Change: Ball speed-up)

-- Screen and game constants (avoiding magic numbers)
local SCREEN_WIDTH = 800
local SCREEN_HEIGHT = 600
local PADDLE_WIDTH = 20
local PADDLE_HEIGHT = 100
local BALL_SIZE = 20
local PADDLE_SPEED = 300

-- Ball speed tuning and limits
local BALL_BASE_SPEED = 200
local BALL_SPEED_UP_FACTOR = 1.05 -- OWN CHANGE: 5% speed acceleration per paddle hit
local BALL_MAX_SPEED = 600        -- OWN CHANGE: max speed cap to prevent tunneling

-- Game state tables
local player1 = {}
local player2 = {}
local ball = {}

-- Score variables
local score1 = 0
local score2 = 0
local scoreFont = nil

-- AABB (Axis-Aligned Bounding Box) collision detection between two rectangular objects
local function checkCollision(a, b)
    return a.x < b.x + b.width  and
           a.x + a.width  > b.x and
           a.y < b.y + b.height and
           a.y + a.height > b.y
end

-- Re-centers ball at the middle of the screen with randomized initial direction and reset speed
local function resetBall()
    ball.x = (SCREEN_WIDTH - ball.width) / 2
    ball.y = (SCREEN_HEIGHT - ball.height) / 2

    -- Random horizontal launch direction (-1 for left, +1 for right)
    local dirX = (math.random(2) == 1) and 1 or -1
    -- Random vertical launch direction (-1 for up, +1 for down)
    local dirY = (math.random(2) == 1) and 1 or -1

    -- Reset to baseline speed on serve
    ball.dx = BALL_BASE_SPEED * dirX
    ball.dy = BALL_BASE_SPEED * dirY
end

-- Called once on startup
function love.load()
    -- Seed random number generator for varied ball launch directions
    math.randomseed(os.time())

    -- Set window title and dimensions
    love.window.setTitle("Pong Game")
    love.window.setMode(SCREEN_WIDTH, SCREEN_HEIGHT)

    -- Dark background (0.1, 0.1, 0.1)
    love.graphics.setBackgroundColor(0.1, 0.1, 0.1)

    -- Create font for score display
    scoreFont = love.graphics.newFont(40)

    -- Initialize player 1 paddle (left)
    player1 = {
        x = 50,
        y = (SCREEN_HEIGHT - PADDLE_HEIGHT) / 2,
        width = PADDLE_WIDTH,
        height = PADDLE_HEIGHT,
        speed = PADDLE_SPEED
    }

    -- Initialize player 2 paddle (right)
    player2 = {
        x = SCREEN_WIDTH - 50 - PADDLE_WIDTH,
        y = (SCREEN_HEIGHT - PADDLE_HEIGHT) / 2,
        width = PADDLE_WIDTH,
        height = PADDLE_HEIGHT,
        speed = PADDLE_SPEED
    }

    -- Initialize ball table
    ball = {
        x = (SCREEN_WIDTH - BALL_SIZE) / 2,
        y = (SCREEN_HEIGHT - BALL_SIZE) / 2,
        width = BALL_SIZE,
        height = BALL_SIZE,
        size = BALL_SIZE,
        dx = BALL_BASE_SPEED,
        dy = BALL_BASE_SPEED
    }

    -- Initialize scores and center ball
    score1 = 0
    score2 = 0
    resetBall()
end

-- Called every frame with delta time (dt)
function love.update(dt)
    -- Movement speed is in pixels/second; multiplying by dt ensures frame-rate independent movement.

    -- Player 1 paddle input (W / S)
    if love.keyboard.isDown("w") then
        player1.y = player1.y - player1.speed * dt
    elseif love.keyboard.isDown("s") then
        player1.y = player1.y + player1.speed * dt
    end

    -- Player 2 paddle input (Up / Down)
    if love.keyboard.isDown("up") then
        player2.y = player2.y - player2.speed * dt
    elseif love.keyboard.isDown("down") then
        player2.y = player2.y + player2.speed * dt
    end

    -- Clamp paddles to top and bottom screen boundaries
    player1.y = math.max(0, math.min(player1.y, SCREEN_HEIGHT - player1.height))
    player2.y = math.max(0, math.min(player2.y, SCREEN_HEIGHT - player2.height))

    -- Update ball position based on velocity multiplied by dt
    ball.x = ball.x + ball.dx * dt
    ball.y = ball.y + ball.dy * dt

    -- Wall bounce: top boundary collision
    if ball.y < 0 then
        ball.y = 0
        ball.dy = -ball.dy
    -- Wall bounce: bottom boundary collision
    elseif ball.y + ball.height > SCREEN_HEIGHT then
        ball.y = SCREEN_HEIGHT - ball.height
        ball.dy = -ball.dy
    end

    -- Paddle collision: Left paddle (Player 1)
    if checkCollision(ball, player1) and ball.dx < 0 then
        -- Anti-stick: reposition ball flush with the front face of the paddle
        ball.x = player1.x + player1.width
        ball.dx = -ball.dx

        -- OWN CHANGE: ball speed-up on paddle hit (increases difficulty over rally)
        ball.dx = math.min(BALL_MAX_SPEED, ball.dx * BALL_SPEED_UP_FACTOR)
        ball.dy = math.min(BALL_MAX_SPEED, math.max(-BALL_MAX_SPEED, ball.dy * BALL_SPEED_UP_FACTOR))
    end

    -- Paddle collision: Right paddle (Player 2)
    if checkCollision(ball, player2) and ball.dx > 0 then
        -- Anti-stick: reposition ball flush with the front face of the paddle
        ball.x = player2.x - ball.width
        ball.dx = -ball.dx

        -- OWN CHANGE: ball speed-up on paddle hit (increases difficulty over rally)
        ball.dx = math.max(-BALL_MAX_SPEED, ball.dx * BALL_SPEED_UP_FACTOR)
        ball.dy = math.min(BALL_MAX_SPEED, math.max(-BALL_MAX_SPEED, ball.dy * BALL_SPEED_UP_FACTOR))
    end

    -- Scoring: ball passes left edge (Player 2 scores)
    if ball.x + ball.width < 0 then
        score2 = score2 + 1
        resetBall()
    -- Scoring: ball passes right edge (Player 1 scores)
    elseif ball.x > SCREEN_WIDTH then
        score1 = score1 + 1
        resetBall()
    end
end

-- Render game frame (pure drawing, no state mutation)
function love.draw()
    -- Draw dashed net center line in white
    love.graphics.setColor(1, 1, 1)
    for y = 0, SCREEN_HEIGHT, 30 do
        love.graphics.rectangle("fill", (SCREEN_WIDTH / 2) - 5, y, 10, 15)
    end

    -- Render scoreboard at top of screen
    love.graphics.setFont(scoreFont)
    love.graphics.print(score1, 350, 20)
    love.graphics.print(score2, 470, 20)

    -- Draw paddles
    love.graphics.rectangle("fill", player1.x, player1.y, player1.width, player1.height)
    love.graphics.rectangle("fill", player2.x, player2.y, player2.width, player2.height)

    -- Draw ball
    love.graphics.rectangle("fill", ball.x, ball.y, ball.width, ball.height)
end
