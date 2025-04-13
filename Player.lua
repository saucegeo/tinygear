local Player = {}
Player.__index = Player

function Player.new(x, y, color, abilities, controls)
    local self = setmetatable({}, Player)
    self.x = x
    self.y = y
    self.width = 50
    self.height = 100
    self.color = color or {1, 1, 1}
    self.speed = 400
    self.vy = 0
    self.isJumping = false
    self.knockback = 0
    self.health = 100
    self.maxHealth = 100

    -- Skills
    self.canDoubleJump = abilities and abilities.canDoubleJump or false
    self.canDash = abilities and abilities.canDash or false

    -- Controls
    self.controls = controls or {}

    return self
end


function Player:update(dt)
    if love.keyboard.isDown(self.controls.left) then 
        self.x = self.x - self.speed * dt
    elseif love.keyboard.isDown(self.controls.right) then
        self.x = self.x + self.speed * dt
    end

    if self.isJumping then
        self.vy = self.vy + gravity * dt
        self.y = self.y + self.vy * dt

        -- Check if player is on the ground
        if self.y >= groundY then
            self.y = groundY
            self.vy = 0
            self.isJumping = false
        end
    end

    -- Knockback
    if self.knockback ~= 0 then
        self.x = self.x + self.knockback * dt
        self.knockback = self.knockback * 0.9
        if math.abs(self.knockback) < 5 then
            self.knockback = 0
        end
        
    end
     -- Screen wrapping
    local windowWidth = love.graphics.getWidth()

    if self.x > windowWidth then
        self.x = -self.width
    elseif self.x + self.width < 0 then
        self.x = windowWidth
    end

    function Player:draw()
        love.graphics.setColor(self.color)
        love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    end 
end

function Player:checkCollision(otherPlayer)
    return self.x + self.width >= otherPlayer.x and self.x <= otherPlayer.x + otherPlayer.width and
           self.y + self.height >= otherPlayer.y and self.y <= otherPlayer.y + otherPlayer.height
end

return Player