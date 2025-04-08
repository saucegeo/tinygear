-- Simple 2D Fighting Game Example

-- Load player data
function love.load()
    player1 = {
        x = 100, y = 300,
        width = 50, height = 100,
        color = {1, 0, 0},
        speed = 200,
        isPunching = false
    }

    player2 = {
        x = 600, y = 300,
        width = 50, height = 100,
        color = {0, 0, 1},
        speed = 200,
        isPunching = false
    }
end

-- Update movement and logic
function love.update(dt)
    -- Player 1 controls (A/D to move, F to punch)
    if love.keyboard.isDown('a') then
        player1.x = player1.x - player1.speed * dt
    elseif love.keyboard.isDown('d') then
        player1.x = player1.x + player1.speed * dt
    end

    -- Player 2 controls (Left/Right arrows to move, L to punch)
    if love.keyboard.isDown('left') then
        player2.x = player2.x - player2.speed * dt
    elseif love.keyboard.isDown('right') then
        player2.x = player2.x + player2.speed * dt
    end
end

-- Handle punch button presses
function love.keypressed(key)
    if key == 'f' then
        player1.isPunching = true
    elseif key == 'l' then
        player2.isPunching = true
    end
end

-- Draw players and punches
function love.draw()
    -- Draw Player 1
    love.graphics.setColor(player1.color)
    love.graphics.rectangle('fill', player1.x, player1.y, player1.width, player1.height)

    -- Draw Player 2
    love.graphics.setColor(player2.color)
    love.graphics.rectangle('fill', player2.x, player2.y, player2.width, player2.height)

    -- Draw Punches
    if player1.isPunching then
        love.graphics.setColor(1, 1, 0)
        love.graphics.rectangle('fill', player1.x + player1.width, player1.y + 30, 20, 20)
    end

    if player2.isPunching then
        love.graphics.setColor(1, 1, 0)
        love.graphics.rectangle('fill', player2.x - 20, player2.y + 30, 20, 20)
    end

    -- Reset color
    love.graphics.setColor(1, 1, 1)
end