-- Background.lua
local Background = {}
Background.__index = Background

function Background:new(image_path)
    local self = setmetatable({}, Background)
    self.image = love.graphics.newImage("assets/backgrounds/level1.png")
    return self
end

function Background:draw()
    local windowWidth, windowHeight = love.graphics.getDimensions()
    local imgWidth = self.image:getWidth()
    local imgHeight = self.image:getHeight()

    local scaleX = windowWidth / imgWidth
    local scaleY = windowHeight / imgHeight

    love.graphics.draw(self.image, 0, 0, 0, scaleX, scaleY)
end

return Background