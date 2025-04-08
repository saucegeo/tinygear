function love.load()
    player1 = {
        x = 100, y = 300,
        width = 50, height = 100,
        color = {1, 0, 0},
        speed = 200,
        isPunching = false,
        health = 100,
        maxHealth = 100,
        vy = 0,
        isJumping = false
    }

    player2 = {
        x = 600, y = 300,
        width = 50, height = 100,
        color = {0, 0, 1},
        speed = 200,
        isPunching = false,
        health = 100,
        maxHealth = 100,
        vy = 0,
        isJumping = false
    }

    gravity = 800
    groundY = 300
end

function love.update(dt)
    -- Player 1 controls (A/D to move)
    if love.keyboard.isDown('a') then
        player1.x = player1.x - player1.speed * dt
    elseif love.keyboard.isDown('d') then
        player1.x = player1.x + player1.speed * dt
    end

    -- Player 2 controls (Left/Right arrows to move)
    if love.keyboard.isDown('left') then
        player2.x = player2.x - player2.speed * dt
    elseif love.keyboard.isDown('right') then
        player2.x = player2.x + player2.speed * dt
    end

    -- Jumping physics
    for _, player in ipairs({player1, player2}) do
        if player.isJumping then
            player.vy = player.vy + gravity * dt
            player.y = player.y + player.vy * dt

            if player.y >= groundY then
                player.y = groundY
                player.vy = 0
                player.isJumping = false
            end
        end
    end

    -- Clamp positions to screen
    player1.x = math.max(0, math.min(player1.x, love.graphics.getWidth() - player1.width))
    player2.x = math.max(0, math.min(player2.x, love.graphics.getWidth() - player2.width))
end

function love.keypressed(key)
    if key == 'f' then
        player1.isPunching = true
        if checkCollision(player1, player2) then
            player2.health = math.max(player2.health - 10, 0)
        end
    elseif key == 'l' then
        player2.isPunching = true
        if checkCollision(player2, player1) then
            player1.health = math.max(player1.health - 10, 0)
        end
    elseif key == 'w' then
        if not player1.isJumping then
            player1.isJumping = true
            player1.vy = -400
        end
    elseif key == 'up' then
        if not player2.isJumping then
            player2.isJumping = true
            player2.vy = -400
        end
    end
end

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
        player1.isPunching = false
    end

    if player2.isPunching then
        love.graphics.setColor(1, 1, 0)
        love.graphics.rectangle('fill', player2.x - 20, player2.y + 30, 20, 20)
        player2.isPunching = false
    end

    -- Draw Health Bars
    drawHealthBar(player1, 50, 50)
    drawHealthBar(player2, 550, 50)

    love.graphics.setColor(1, 1, 1)
end

function drawHealthBar(player, x, y)
    local healthBarWidth = 200
    local healthBarHeight = 20
    local healthPercentage = player.health / player.maxHealth

    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle('fill', x, y, healthBarWidth, healthBarHeight)

    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle('fill', x, y, healthBarWidth * healthPercentage, healthBarHeight)
end

function checkCollision(p1, p2)
    return p1.x + p1.width >= p2.x and p1.x <= p2.x + p2.width and
           p1.y + p1.height >= p2.y and p1.y <= p2.y + p2.height
end