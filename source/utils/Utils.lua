local gfx <const> = playdate.graphics

local previousLoopTime = 0
function getDeltaTime()
    local currentTime = playdate.getCurrentTimeMilliseconds()
    local deltaTime = currentTime - previousLoopTime
    previousLoopTime = currentTime

    return deltaTime
end

function createSprite(width, height, posX, posY, callback)
    local newSprite = gfx.sprite.new()

    newSprite:setSize(width, height)
    newSprite.draw = callback
    newSprite:setCenter(0, 0)
    newSprite:moveTo(posX, posY)

    return newSprite
end