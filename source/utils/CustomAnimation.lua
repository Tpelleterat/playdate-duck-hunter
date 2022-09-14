local pd <const> = playdate
local gfx <const> = pd.graphics

class('CustomAnimation').extends()

function CustomAnimation:init(imagetable, delay, drawPositionCallBack, ...)
    CustomAnimation.super.init(self)

    local ajustes = { ... }
    self.animationPicturesList = {}
    self.delay = delay
    self.drawPositionCallBack = drawPositionCallBack
    self.animation = nil
    self.showIndex = nil

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

function CustomAnimation:start()
    self.animation = gfx.animator.new(self.delay, 1, #self.animationPicturesList + 1)
end

function CustomAnimation:draw()
    local index = math.floor(self.animation:currentValue())

    if index <= #self.animationPicturesList then

        if self.showIndex ~= index then

            if self.showIndex ~= nil then
                local previousPicture = self.animationPicturesList[self.showIndex]
                gfx.sprite.removeSprite(previousPicture.imageSprite)
            end

            local picture = self.animationPicturesList[index]

            local w, h = picture.image:getSize()
            local xPos, yPos = self.drawPositionCallBack(w, h, picture.ajustX, picture.ajustY)

            picture.imageSprite:moveTo(xPos, yPos)
            picture.imageSprite:add()

            self.showIndex = index
        end
    elseif self.showIndex ~= nil then
        local previousPicture = self.animationPicturesList[self.showIndex]
        gfx.sprite.removeSprite(previousPicture.imageSprite)
        self.showIndex = nil
    end
end
