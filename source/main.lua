import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/crank"
import "CoreLibs/animation"
import "CoreLibs/frameTimer"

import "utils/Utils"
import "utils/CustomAnimation"

import "sprites/GunSprite"
import "sprites/TargetSprite"
import "models/BarrelEnum"

local pd <const> = playdate
local gfx <const> = pd.graphics

local gunSprite
local targetSprite

local function initialize()
    gunSprite = GunSprite(0, 0)
    gunSprite:add()

    targetSprite = TargetSprite(400 / 2, 240 / 2, 40, 40)
    targetSprite:add()
end

initialize()

function playdate.update()
    math.randomseed(playdate.getSecondsSinceEpoch())

    if gunSprite.pendingRefill and targetSprite:isVisible() then
        targetSprite:setVisible(false)
    elseif not gunSprite.pendingRefill and not targetSprite:isVisible() then
        targetSprite:setVisible(true)
    end

    gfx.sprite.update()

    playdate.timer.updateTimers()
    playdate.frameTimer.updateTimers()
end

function playdate.AButtonDown()
    gunSprite:fire(BarrelEnum.RIGHT)
end

function playdate.BButtonDown()
    gunSprite:fire(BarrelEnum.LEFT)
end
