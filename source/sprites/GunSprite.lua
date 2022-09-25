local gfx <const> = playdate.graphics

class('GunSprite').extends(gfx.sprite)

function GunSprite:init(x, y, r)
    GunSprite.super.init(self)
    self.pendingRefill = false
    self.leftBarrelFilled = true
    self.rightBarrelFilled = true

    self.reloadSound = playdate.sound.sampleplayer.new("assets/sounds/reload")
    self.emptyTriggerSound = playdate.sound.sampleplayer.new("assets/sounds/empty-trigger")
    self.emptyTriggerSound:setVolume(0.4)

    self:initGunImage()
    self:initFireAnimation()
    self:initReloadAnimation()
end

function GunSprite:initGunImage()
    self.standardPosition = gfx.sprite.new()
    self.gunReadyPositionImage = gfx.image.new("assets/images/gun-standard-position")
    local w, h = self.gunReadyPositionImage:getSize()
    self.standardPosition:setSize(w, h)
    self.standardPosition:setImage(self.gunReadyPositionImage)
    self.standardPosition:setCenter(0, 0)
    self.standardPosition:moveTo(400 / 2 - w / 2, 240 - h)
    self.standardPosition:add()
end

function GunSprite:initFireAnimation()
    local fireImageList = gfx.imagetable.new("assets/images/gun-fire")
    local animDrawPositionCallback = function(w, h, ajustX, ajustY)
        local xPos = self.standardPosition.x + ajustX
        local yPos = self.standardPosition.y - h + ajustY

        return xPos, yPos
    end
    self.fireCustomAnimation = CustomAnimation(fireImageList, 50, animDrawPositionCallback, 0, 25, -12, 25)
end

function GunSprite:initReloadAnimation()
    local fireImageList = gfx.imagetable.new("assets/images/gun-reload")

    local animDrawPositionCallback = function(w, h, ajustX, ajustY)
        local xPos = 400 / 2 - w / 2 + ajustX
        local yPos = 240 - h + ajustY

        return xPos, yPos
    end
    self.reloadCustomAnimation = CustomAnimation(fireImageList, 1500, animDrawPositionCallback,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)
end

function GunSprite:canFire(barrel)
    if self.pendingRefill then
        return false
    end

    if barrel == BarrelEnum.LEFT then
        if self.leftBarrelFilled then
            return true
        else
            self.emptyTriggerSound:play()
        end
    end


    if barrel == BarrelEnum.RIGHT then
        if self.rightBarrelFilled then
            return true
        else
            self.emptyTriggerSound:play()
        end
    end

    return false
end

function GunSprite:fire(barrel)
    if self:canFire(barrel) then
        self.fireCustomAnimation:start()

        if barrel == BarrelEnum.LEFT then
            self.leftBarrelFilled = false
        elseif barrel == BarrelEnum.RIGHT then
            self.rightBarrelFilled = false
        end

        return true
    end

    return false
end

function GunSprite:checkShouldReload()
    local degreesChanged = playdate.getCrankChange()

    if not self.pendingRefill and degreesChanged > 30 then
        self.reloadSound:play()
        self:reload()
    end
end

function GunSprite:reload()
    self.pendingRefill = true
    self.reloadCustomAnimation:start()
end

function GunSprite:updateReload()
    if self.pendingRefill and
        (self.reloadCustomAnimation.animation == nil or self.reloadCustomAnimation.animation:ended()) then
        self.reloadSound:stop()
        self.leftBarrelFilled = true
        self.rightBarrelFilled = true
        self.pendingRefill = false
    end
end

function GunSprite:manageGunVisibility()
    if self.pendingRefill and self.standardPosition:isVisible() then
        self.standardPosition:setVisible(false)
    elseif not self.pendingRefill and not self.standardPosition:isVisible() then
        self.standardPosition:setVisible(true)
    end
end

function GunSprite:update()
    GunSprite.super.update(self)

    self:manageGunVisibility()

    self:checkShouldReload()

    self:updateReload()

end
