local Player = require "Player"
local Healthbar = require "Healthbar"
local StartMenu = require "StartMenu"

local GameState = {
    MENU = "menu",
    PLAYING = "playing"
}

local gameState = GameState.MENU -- Game state: GameState.MENU or GameState.PLAYING
local menu = StartMenu.new()

function love.load()
    -- Set up the game window and title
    love.window.setTitle("THE POOKIE FIGHTER")
    love.window.setMode(800, 600, {resizable=false, vsync=true})

    gravity = 1000

     -- Create players
     player1 = Player.new(100, 300, {1, 0, 0}, {}, {left = 'a', right = 'd', jump = 'w', punch = 'f'})
     player2 = Player.new(600, 300, {0, 0, 1}, {}, {left = 'left', right = 'right', jump = 'up', punch = 'l'})
 
     -- Create healthbars
     healthBar1 = Healthbar.new(50, 50, player1)
     healthBar2 = Healthbar.new(550, 50, player2)
end

function love.update(dt)
    -- Set ground position
    groundY = 300
    if gameState == GameState.MENU then
        menu:update(dt)  -- Update menu
    elseif gameState == GameState.PLAYING then 
        player1:update(dt)
        player2:update(dt)
    end
end

function love.keypressed(key)
    if gameState == GameState.MENU then
        local newState = menu:keypressed(key)  -- Get the new state
        if newState then
            gameState = GameState.PLAYING  -- Update the game state if we got a return value
        end
    elseif gameState == GameState.PLAYING then
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
                if player1.x < player2.x then
                    player2.knockback = 600
                else
                    player2.knockback = -600
                end
            end
        elseif key == player2.controls.punch then
            player2.isPunching = true
            if player2:checkCollision(player1) then
                player1.health = math.max(player1.health - 10, 0)
                if player2.x < player1.x then
                    player1.knockback = 600
                else
                    player1.knockback = -600
                end
            end
        end
    end
end

function love.draw()
    -- Draw players

    if gameState == GameState.MENU then
        menu:draw()  -- Draw the menu
    elseif gameState == GameState.PLAYING then

    player1:draw()
    player2:draw()
    
    healthBar1:draw()
    healthBar2:draw()

    -- Reset color to white
    love.graphics.setColor(1, 1, 1)
    end
end
