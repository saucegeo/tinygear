love.graphics.setDefaultFilter("nearest", "nearest")
local Player = {}
Player.__index = Player

function Player.new(x, y, color, skills, controls,spritePath)
    local self = setmetatable({}, Player)
    self.x = x
    self.y = y
    self.width = 80
    self.height = 100
    self.color = color or {1, 1, 1}
    self.speed = 300
    self.vy = 0
    self.isJumping = false
    self.knockback = 0
    self.health = 100
    self.maxHealth = 100

    -- Skills
    self.skills = skills or {}

    -- Controls
    self.controls = controls or {}

    self.sprite = love.graphics.newImage(spritePath)
    self.frameWidth = 64
    self.frameHeight = 64
    self.totalFrames = 1
    self.currentFrame = 1
    self.timer = 0
    self.frameDuration = 0.1

    self.frames = {}
    for i = 0, self.totalFrames - 1 do
        self.frames[i + 1] = love.graphics.newQuad(
            i * self.frameWidth, 0,
            self.frameWidth, self.frameHeight,
            self.sprite:getDimensions()
        )
    end

    self.facing = "right"
    return self
end


function Player:update(dt)
    -- Handle frame animation
    self.timer = self.timer + dt
    if self.timer > self.frameDuration then
        self.currentFrame = self.currentFrame % self.totalFrames + 1
        self.timer = 0
    end

    local wasFacing = self.facing

    -- Handle horizontal movement
    if love.keyboard.isDown(self.controls.left) then 
        self.x = self.x - self.speed * dt
        self.facing = "left"
    elseif love.keyboard.isDown(self.controls.right) then
        self.x = self.x + self.speed * dt
        self.facing = "right"
    end

    if self.facing ~= wasFacing then
        self.turnTimer = 0.05  -- short delay to show turn transition
        self.currentFrame = 1 -- assuming frame 1 is a neutral turn frame
    end

    if self.turnTimer then
        self.turnTimer = self.turnTimer - dt
        if self.turnTimer <= 0 then
            self.turnTimer = nil
        end
    end

    -- Handle jumping
    if self.isJumping then
        self.vy = self.vy + gravity * dt
        self.y = self.y + self.vy * dt

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
end

function Player:draw()
    love.graphics.setColor(1, 1, 1)
    local scaleX = self.facing == "left" and -4 or 4 -- scale horizontally, also flip if facing left
    local offsetX = self.facing == "left" and self.frameWidth or 0
    love.graphics.draw(
        self.sprite,
        self.frames[self.currentFrame],
        self.x + offsetX,
        self.y,
        0,
        scaleX,
        4 -- vertical scale
    )
    
    -- -- Draw hitbox for debugging
    local hitbox = self:getHitbox()
    love.graphics.setColor(1, 0, 0, 0.5)
    love.graphics.rectangle("fill", hitbox.x, hitbox.y, hitbox.width, hitbox.height)
    love.graphics.setColor(1, 1, 1)
end 

function Player:getHitbox()
    local hitWidth = 80  -- how far the punch reaches
    local hitHeight = self.height  -- half the character's height
    local hitY = self.y + self.height * 0.25  -- vertically centered
    local hitX

    if self.facing == "right" then
        hitX = self.x + self.width
    else
        hitX = self.x - hitWidth
    end

    return {
        x = hitX,
        y = hitY,
        width = hitWidth,
        height = hitHeight
    }
end

function Player:checkCollision(otherPlayer)
    local a = self:getHitbox()
    local b = otherPlayer:getHitbox()
    return a.x < b.x + b.width and
           a.x + a.width > b.x and
           a.y < b.y + b.height and
           a.y + a.height > b.y
end

return Player