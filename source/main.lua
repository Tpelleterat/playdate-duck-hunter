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
import "sprites/DuckAreaSprite"
import "sprites/DuckSprite"
import "models/BarrelEnum"
import "models/DuckMovementDirectionEnum"

local pd <const> = playdate
local gfx <const> = pd.graphics

local gunSprite
local targetSprite
local duckAreaSprite
local playTimer = nil
local playTime = 30 * 1000

local function resetTimer()
    playTimer = playdate.timer.new(playTime, playTime, 0, playdate.easingFunctions.linear)
end

local function initialize()
    gfx.getSystemFont(gfx.font.kVariantNormal)

    gunSprite = GunSprite(0, 0)
    gunSprite:add()

    targetSprite = TargetSprite(400 / 2, 240 / 2, 40, 40)
    targetSprite:add()

    duckAreaSprite = DuckAreaSprite()
    duckAreaSprite:add()

    resetTimer()
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

    gfx.drawText("Score : " .. duckAreaSprite.killCount, 310, 210)

    gfx.drawText("Time: " .. math.ceil(playTimer.value / 1000), 240, 210)

end

local function fire(barrel)
    if gunSprite:fire(barrel) then
        duckAreaSprite:manageFire(targetSprite:overlappingSprites())
    end
end

function playdate.AButtonDown()
    fire(BarrelEnum.RIGHT)
end

function playdate.BButtonDown()
    fire(BarrelEnum.LEFT)
end
