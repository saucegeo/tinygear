local PauseMenu = {}
PauseMenu.__index = PauseMenu

-- create a new PauseMenu instance
function PauseMenu.new()
    local self = setmetatable({}, PauseMenu) -- metatable are used to create object-oriented behavior in Lua
    self.title = "Game Paused"
    self.buttonResume = "Press P to Resume"
    return self
end

-- update the pause menu
function PauseMenu:update(dt)
    -- Update logic for pause menu (if any)
end

-- draw the pause menu
function PauseMenu:draw()
    love.graphics.setColor(1,1,1) -- set color to white for text
    love.graphics.print(self.title, love.graphics.getWidth()/2-100, love.graphics.getHeight()/ 2-50) --
    love.graphics.print(self.buttonResume, love.graphics.getWidth()/2-100, love.graphics.getHeight()/ 2)
end

-- resume game if 'p' is pressed
function PauseMenu:keypressed(key)
    if key == "p" then
        return "playing" -- resume the game if 'p' is pressed
    end
    return nil -- no state change
end

return PauseMenu