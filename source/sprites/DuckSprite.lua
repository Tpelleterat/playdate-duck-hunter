local pd <const> = playdate
local gfx <const> = playdate.graphics

import "utils/Utils"

class('DuckSprite').extends(gfx.sprite)

function DuckSprite:init(x, y, width, height, direction)
    DuckSprite.super.init(self)
    self.isDied = false
    self.isDying = false
    self.imageIndex = 0
    self.speed = 1
    self.incrementMovementX = 0
    self.incrementMovementY = 0
    self.dieTimer = nil

    self:setSize(40, 40)
    self:setCenter(0, 0)
    self:moveTo(x, y)

    local w, h = self:getSize()
    self:setCollideRect(5, 5, w - 10, h - 10)

    self.duckDieImage = gfx.image.new("assets/images/duck-die-simple")

    self:initAnimation(direction)
    self:initMovement(direction)
end

function DuckSprite:initAnimation(direction)
    local duckImages = self:loadImagetable(direction)

    local animDrawPositionCallback = function(w, h, ajustX, ajustY)
        local xPos = self.x
        local yPos = self.y

        return xPos, yPos
    end
    self.duckCustomAnimation = CustomAnimation(duckImages, 200, animDrawPositionCallback,
        0, 0, 0, 0, 0, 0)
    self.duckCustomAnimation:setZindex(-3)
    if direction == DuckMovementDirectionEnum.LEFT or direction == DuckMovementDirectionEnum.DIAGONAL_LEFT then
        self.duckCustomAnimation:revertImages()
    end
    --TODO : change repeat to use infinit loop
    self.duckCustomAnimation:start(20000)
end

function DuckSprite:loadImagetable(direction)

    if direction == DuckMovementDirectionEnum.TOP then
        return gfx.imagetable.new("assets/images/duck-t")
    elseif direction == DuckMovementDirectionEnum.LEFT or direction == DuckMovementDirectionEnum.RIGHT then
        return gfx.imagetable.new("assets/images/duck-h")
    elseif direction == DuckMovementDirectionEnum.DIAGONAL_LEFT or direction == DuckMovementDirectionEnum.DIAGONAL_RIGHT then
        return gfx.imagetable.new("assets/images/duck-d")
    end
end

function DuckSprite:initMovement(direction)
    if direction == DuckMovementDirectionEnum.TOP then
        self.incrementMovementY = -self.speed
    elseif direction == DuckMovementDirectionEnum.LEFT then
        self.incrementMovementX = -self.speed
    elseif direction == DuckMovementDirectionEnum.RIGHT then
        self.incrementMovementX = self.speed
    elseif direction == DuckMovementDirectionEnum.DIAGONAL_LEFT then
        self.incrementMovementY = -self.speed
        self.incrementMovementX = -self.speed
    elseif direction == DuckMovementDirectionEnum.DIAGONAL_RIGHT then
        self.incrementMovementY = -self.speed
        self.incrementMovementX = self.speed
    end
end

function DuckSprite:shoot()
    self:clearCollideRect()
    --self.isDied = true
    self.isDying = true
    self.duckCustomAnimation:stop()
    self:setImage(self.duckDieImage)
    self.dieTimer = playdate.timer.new(150, function()
        self.isDied = true
    end
    )
end

function DuckSprite:update()
    DuckSprite.super.update(self)

    if not self.isDying and not self.isDied then

        local newX = self.x + self.incrementMovementX
        local newY = self.y + self.incrementMovementY

        if newX ~= self.x or newY ~= self.y then
            self:moveTo(newX, newY)
        end

        self.duckCustomAnimation:draw()
    end

    -- refresh target view cause display bug :(
    if self:isVisible() then
        self:setVisible(false)
        self:setVisible(true)
    end
end
