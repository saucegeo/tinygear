-- Healthbar.lua
local Healthbar = {}
Healthbar.__index = Healthbar

function Healthbar.new(x, y, player)
    local self = setmetatable({}, Healthbar)
    self.x = x
    self.y = y
    self.width = 200
    self.height = 20
    self.player = player
    return self
end

function Healthbar:draw()
    local healthPercentage = self.player.health / self.player.maxHealth

    -- Draw background
    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)

    -- Draw health bar
    love.graphics.setColor(0, 1, 0)
    love.graphics.rectangle('fill', self.x, self.y, self.width * healthPercentage, self.height)
end

return Healthbar