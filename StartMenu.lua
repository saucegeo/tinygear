-- StartMenu.lua
local StartMenu = {}
StartMenu.__index = StartMenu

function StartMenu.new()
    local self = setmetatable({}, StartMenu)
    self.title = "Welcome to TinyGear!"
    self.buttonStart = "Press ENTER to Start"
    self.selected = 1 -- Track selected option
    return self
end

function StartMenu:update(dt)
    -- Update logic for start menu (e.g., handling button selection)
end

function StartMenu:draw()
    love.graphics.setColor(1, 1, 1) -- White color for text
    love.graphics.print(self.title, love.graphics.getWidth() / 2 - 100, love.graphics.getHeight() / 2 - 50)
    love.graphics.print(self.buttonStart, love.graphics.getWidth() / 2 - 100, love.graphics.getHeight() / 2)
end

function StartMenu:keypressed(key)
    if key == 'enter' or key == 'return' then
        -- Return the new state instead of trying to set it directly
        return "playing"
    end
    return nil -- No state change
end

return StartMenu