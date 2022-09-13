import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "CoreLibs/animation"
import "CoreLibs/frameTimer"


import "sprites/GunSprite"
import "models/BarrelEnum"

local pd <const> = playdate
local gfx <const> = pd.graphics

local previousLoopTime = 0

local function getDeltaTime()
    local currentTime = playdate.getCurrentTimeMilliseconds()
    local deltaTime = currentTime - previousLoopTime
    previousLoopTime = currentTime

    return deltaTime
end

-- local gunImage = gfx.image.new("images/shutgun-sprite-modified-ditherlicious")
-- gunImage:draw(0, 0, gfx.kImageUnflipped, 0, 0, 50, 50)
-- local gunSprite = gfx.sprite.new(gunImage)
-- gunSprite:add()

local gunSprite

local function initialize()
    gunSprite = GunSprite(0, 0)
    gunSprite:add()
end

initialize()

function playdate.update()
    local dt = getDeltaTime()
    math.randomseed(playdate.getSecondsSinceEpoch())

    gfx.sprite.update()

    gunSprite:draw()

    playdate.timer.updateTimers()
    playdate.frameTimer.updateTimers()
end

function playdate.AButtonDown()
    gunSprite:fire(BarrelEnum.RIGHT)
end

function playdate.BButtonDown()
    gunSprite:fire(BarrelEnum.LEFT)
end
