local gfx <const> = playdate.graphics

function createSprite(width, height, posX, posY, callback)
    local newSprite = gfx.sprite.new()

    newSprite:setSize(width, height)
    newSprite.draw = callback
    newSprite:setCenter(0, 0)
    newSprite:moveTo(posX, posY)

    return newSprite
end
