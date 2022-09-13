local pd <const> = playdate
local gfx <const> = pd.graphics

class('GunSprite').extends(gfx.sprite)

function GunSprite:init(x, y, r)
    GunSprite.super.init(self)

    self.firePicturesList = {}
    local fireImageList = gfx.imagetable.new("images/gun-fire")

    local firePicture = {}
    firePicture.image = fireImageList:getImage(1)
    firePicture.ajustX = 0
    firePicture.ajustY = 25

    table.insert(self.firePicturesList, firePicture)

    local firePicture = {}
    firePicture.image = fireImageList:getImage(2)
    firePicture.ajustX = -12
    firePicture.ajustY = 25

    table.insert(self.firePicturesList, firePicture)

    self.fireAnimation = nil

    self.standardPosition = gfx.sprite.new()
    self.gunReadyPositionImage = gfx.image.new("images/gun-standard-position")
    local w, h = self.gunReadyPositionImage:getSize()
    self.standardPosition:setSize(w, h)
    self.standardPosition:setImage(self.gunReadyPositionImage)
    self.standardPosition:setCenter(0, 0)
    self.standardPosition:moveTo(400 / 2 - w / 2, 240 - h)

    self.standardPosition:add()

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
        self.fireAnimation = gfx.animator.new(50, 1, 3)

        if barrel == BarrelEnum.LEFT then
            self.leftBarrelFilled = false
        elseif barrel == BarrelEnum.RIGHT then
            self.rightBarrelFilled = false
        end
    end
end

function GunSprite:drawFire()
    if self.fireAnimation ~= nil and not self.fireAnimation:ended() then

        local index = math.floor(self.fireAnimation:currentValue())

        if index <= #self.firePicturesList then

            local picture = self.firePicturesList[index]
            local w, h = picture.image:getSize()

            picture.image:draw(self.standardPosition.x + picture.ajustX,
                self.standardPosition.y - h + picture.ajustY)
        end
    end
end

function GunSprite:update()
    GunSprite.super.update(self)
end

function GunSprite:draw()
    self:drawFire()
end
