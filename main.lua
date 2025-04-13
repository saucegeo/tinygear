local Player = require "Player"
local Healthbar = require "Healthbar"

function love.load()
    love.window.setTitle("THE POOKIES FIGHT")
    love.window.setMode(800, 600, {resizable=false, vsync=true})

    gravity = 1000

     -- Create players
     player1 = Player.new(100, 300, {1, 0, 0}, {}, {left = 'a', right = 'd', jump = 'w', punch = 'f'})
     player2 = Player.new(600, 300, {0, 0, 1}, {}, {left = 'left', right = 'right', jump = 'up', punch = 'l'})
 
     -- Create healthbars
     healthBar1 = Healthbar.new(50, 50, player1)
     healthBar2 = Healthbar.new(550, 50, player2)
end

-- Set up the game logic
function love.update(dt)
    -- Set groundY once (good)
    groundY = 300

    -- Update both players normally
    player1:update(dt)
    player2:update(dt)
end

 function love.keypressed(key)
    if key == player1.controls.jump and not player1.isJumping then
        player1.isJumping = true
        player1.vy = -300
    elseif key == player2.controls.jump and not player2.isJumping then
        player2.isJumping = true
        player2.vy = -300
    end

    -- Punching
    if key == player1.controls.punch then
        player1.isPunching = true
        if player1:checkCollision(player2) then
            player2.health = math.max(player2.health - 10, 0)
            player2.knockback = 600
        end
    elseif key == player2.controls.punch then
        player2.isPunching = true
        if player2:checkCollision(player1) then
            player1.health = math.max(player1.health - 10, 0)
            player1.knockback = -600
        end
    end
end

function love.draw()
    -- Draw players
    player1:draw()
    player2:draw()

    -- Draw healthbars
    healthBar1:draw()
    healthBar2:draw()

    -- Reset color to white
    love.graphics.setColor(1, 1, 1)
end
