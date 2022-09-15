local pd <const> = playdate
local gfx <const> = playdate.graphics

import "utils/Utils"

class('TargetSprite').extends(gfx.sprite)

function TargetSprite:init(x, y, width, height)
    TargetSprite.super.init(self)
    self:moveTo(x, y)
    self:setSize(width, height)
    self:setZIndex(-1)

    self.draw = function(s, x, y, w, h)

        local linesHeight = h / 12
        local linesWidth = (w / 8) * 2

        gfx.fillRect(w / 8, h / 2 - linesHeight / 2, linesWidth, linesHeight)

        gfx.fillRect(w - w / 8 * 3, h / 2 - linesHeight / 2, linesWidth, linesHeight)

        gfx.fillRect(h / 2 - linesHeight / 2, w / 8, linesHeight, linesWidth)
        gfx.fillRect(h / 2 - linesHeight / 2, w - w / 8 * 3, linesHeight, linesWidth)

    end

    self:setCenter(0, 0)

    self.speed = 10
    local w, h = self:getSize()
    self:setCollideRect(w / 3, h / 3, w / 3, h / 3)
end

function TargetSprite:GetX()
    return self.x + self.width / 2
end

function TargetSprite:GetY()
    return self.y + self.height / 2
end

function TargetSprite:update()
    TargetSprite.super.update(self)

    if self:isVisible() then

        local newX = self.x
        local newY = self.y

        if playdate.buttonIsPressed(playdate.kButtonUp) then
            newY = newY - self.speed
            if newY < 0 then
                newY = 0
            end
        end
        if playdate.buttonIsPressed(playdate.kButtonRight) then
            newX = newX + self.speed
            if newX > 400 - self.width then
                newX = 400 - self.width
            end
        end
        if playdate.buttonIsPressed(playdate.kButtonDown) then
            newY = newY + self.speed
            if newY > 240 - self.height then
                newY = 240 - self.height
            end
        end
        if playdate.buttonIsPressed(playdate.kButtonLeft) then
            newX = newX - self.speed
            if newX < 0 then
                newX = 0
            end
        end

        if newX ~= self.x or newY ~= self.y then
            self:moveTo(newX, newY)
        end

        -- refresh target view cause display bug :(
        self:setVisible(false)
        self:setVisible(true)
    end
end
