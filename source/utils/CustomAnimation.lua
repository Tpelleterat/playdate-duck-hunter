local pd <const> = playdate
local gfx <const> = pd.graphics

class('CustomAnimation').extends(gfx.sprite)

function CustomAnimation:init(imagetable, delay, drawPositionCallBack, ...)
    CustomAnimation.super.init(self)

    local ajustes = { ... }
    self.animationPicturesList = {}
    self.delay = delay
    self.drawPositionCallBack = drawPositionCallBack
    self.animation = nil
    self.showIndex = nil
    self.infinitLoop = false

    local ajustIndex = 1
    for i = 1, imagetable:getLength(), 1 do
        local picture = {}
        picture.image = imagetable:getImage(i)

        picture.imageSprite = gfx.sprite.new()
        local w, h = picture.image:getSize()
        picture.imageSprite:setSize(w, h)
        picture.imageSprite:setImage(picture.image)
        picture.imageSprite:setCenter(0, 0)

        picture.ajustX = ajustes[ajustIndex]
        picture.ajustY = ajustes[ajustIndex + 1]

        table.insert(self.animationPicturesList, picture)
        ajustIndex = ajustIndex + 2
    end
end

function CustomAnimation:setInfinitLoot(infinitLoop)
    self.infinitLoop = infinitLoop
end

function CustomAnimation:revertImages()
    for key, value in pairs(self.animationPicturesList) do
        value.imageSprite:setImageFlip(playdate.graphics.kImageFlippedX)
    end
end

function CustomAnimation:setZindex(index)
    for key, value in pairs(self.animationPicturesList) do
        value.imageSprite:setZIndex(index)
    end
end

function CustomAnimation:start()
    self.animation = gfx.animator.new(self.delay, 1, #self.animationPicturesList + 1)
    -- add this sprint to use auto update loop method
    self:add()
end

function CustomAnimation:stop()
    if self.animation ~= nil then
        -- remove self to stop update
        gfx.sprite.removeSprite(self)
        self.animation = nil
        self:removeCurrentSprite()
    end
end

function CustomAnimation:update()
    CustomAnimation.super.update(self)

    local index = math.floor(self.animation:currentValue())

    if index <= #self.animationPicturesList then

        local picture = self.animationPicturesList[index]

        local w, h = picture.image:getSize()
        local xPos, yPos = self.drawPositionCallBack(w, h, picture.ajustX, picture.ajustY)

        picture.imageSprite:moveTo(xPos, yPos)

        if self.showIndex ~= index then

            if self.showIndex ~= nil then
                local previousPicture = self.animationPicturesList[self.showIndex]
                gfx.sprite.removeSprite(previousPicture.imageSprite)
            end

            picture.imageSprite:add()

            self.showIndex = index
        end
    end

    if self.animation:ended() then
        if self.infinitLoop then
            self.animation:reset()
        else
            self:stop()
        end
    end
end

function CustomAnimation:removeCurrentSprite()
    local previousPicture = self.animationPicturesList[self.showIndex]
    gfx.sprite.removeSprite(previousPicture.imageSprite)
    self.showIndex = nil
end
