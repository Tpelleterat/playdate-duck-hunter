local pd <const> = playdate
local gfx <const> = pd.graphics

class('GunSprite').extends(gfx.sprite)

function GunSprite:init(x, y, r)
    GunSprite.super.init(self)

    self.standardPosition = gfx.sprite.new()
    self.gunReadyPositionImage = gfx.image.new("images/gun-standard-position")
    local w, h = self.gunReadyPositionImage:getSize()
    self.standardPosition:setSize(w, h)
    self.standardPosition:setImage(self.gunReadyPositionImage)
    self.standardPosition:setCenter(0, 0)
    self.standardPosition:moveTo(400 / 2 - w / 2, 240 - h)

    self.standardPosition:add()

    local fireImageList = gfx.imagetable.new("images/gun-fire")
    local animDrawPositionCallback = function(w, h, ajustX, ajustY)
        local xPos = self.standardPosition.x + ajustX
        local yPos = self.standardPosition.y - h + ajustY

        return xPos, yPos
    end
    self.fireCustomAnimation = CustomAnimation(fireImageList, 50, animDrawPositionCallback, 0, 25, -12, 25)

    self.pendingRefill = false
    self.leftBarrelFilled = true
    self.rightBarrelFilled = true
end

function GunSprite:CanFire(barrel)
    if self.pendingRefill then
        return false
    end

    if barrel == BarrelEnum.LEFT and self.leftBarrelFilled then
        return true
    end

    if barrel == BarrelEnum.RIGHT and self.rightBarrelFilled then
        return true
    end
end

function GunSprite:fire(barrel)
    if self:CanFire(barrel) then
        self.fireCustomAnimation:start()

        if barrel == BarrelEnum.LEFT then
            --self.leftBarrelFilled = false
        elseif barrel == BarrelEnum.RIGHT then
            --self.rightBarrelFilled = false
        end
    end
end

function GunSprite:drawFire()
    if self.fireCustomAnimation.animation ~= nil and not self.fireCustomAnimation.animation:ended() then
        self.fireCustomAnimation:draw()
    end
end

function GunSprite:update()
    GunSprite.super.update(self)
end

function GunSprite:draw()
    self:drawFire()
end
