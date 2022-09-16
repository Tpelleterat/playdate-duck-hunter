import "CoreLibs/ui"
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
import "models/GameStatusEnum"

local pd <const> = playdate
local gfx <const> = pd.graphics

local gameStatus = GameStatusEnum.MENU
local gunSprite
local targetSprite
local duckAreaSprite
local gameTimerInitialValue = 0
local gameDuration = 60 * 1000 -- In miliseconds
local finalScore = 0

playdate.ui.crankIndicator:start()
local menu = gfx.image.new("images/menu")
local font = playdate.graphics.font.new('fonts/Test')
local font2 = playdate.graphics.font.new('fonts/Test2')
local shoot_target_Sound = playdate.sound.sampleplayer.new("sounds/shoot-target")
local shoot_no_target_Sound = playdate.sound.sampleplayer.new("sounds/shoot-no-target")

local function startGame()
    gfx.getSystemFont(gfx.font.kVariantNormal)

    gunSprite = GunSprite(0, 0)
    gunSprite:add()

    targetSprite = TargetSprite(400 / 2, 240 / 2, 40, 40)
    targetSprite:add()

    duckAreaSprite = DuckAreaSprite()
    duckAreaSprite:add()

    gameTimerInitialValue = playdate.getCurrentTimeMilliseconds()
end

local function showScore()
    finalScore = duckAreaSprite.killCount

    gameStatus = GameStatusEnum.SCORE
    playdate.graphics.sprite.removeAll()
    playdate.graphics.clear()
    gunSprite = nil
    targetSprite = nil
    duckAreaSprite = nil
end

local function updateMenu()
    if gameStatus == GameStatusEnum.MENU or gameStatus == GameStatusEnum.SCORE then

        gfx.setFont(font)
        menu:draw(0, 0)

        local textsXPosition = 170

        if gameStatus == GameStatusEnum.SCORE then
            gfx.setFont(font)
            gfx.drawText("Score : " .. finalScore, textsXPosition + 50, 140)
            gfx.drawText("Press A to restart.", textsXPosition, 200)
        else
            gfx.setFont(font2)

            gfx.drawText("Shoot ducks with A and B.", textsXPosition, 120)
            gfx.drawText("The gun has only 2 bullets.", textsXPosition, 140)
            gfx.drawText("Use crank to reload.", textsXPosition, 160)

            gfx.setFont(font)
            gfx.drawText("Press A to start.", textsXPosition, 200)

        end

        if playdate.buttonJustPressed(playdate.kButtonA) and not playdate.isCrankDocked() then
            playdate.graphics.clear()
            gameStatus = GameStatusEnum.GAME
            startGame()
        end
    end
end

local function updateGame()
    if gameStatus == GameStatusEnum.GAME then

        local gametime = playdate.getCurrentTimeMilliseconds() - gameTimerInitialValue

        if gametime > gameDuration then
            showScore();
        else
            if gunSprite.pendingRefill and targetSprite:isVisible() then
                targetSprite:setVisible(false)
            elseif not gunSprite.pendingRefill and not targetSprite:isVisible() then
                targetSprite:setVisible(true)
            end

            gfx.drawText("Score : " .. duckAreaSprite.killCount, 310, 210)

            gfx.drawText("Time: " .. math.ceil((gameDuration - gametime) / 1000), 240, 210)
        end
    end
end

function playdate.update()
    math.randomseed(playdate.getSecondsSinceEpoch())

    gfx.sprite.update()

    updateMenu()

    updateGame()

    if playdate.isCrankDocked() then
        playdate.ui.crankIndicator:update()
    end

    playdate.timer.updateTimers()
end

local function fire(barrel)
    if gunSprite:fire(barrel) then
        local touch = duckAreaSprite:manageFire(targetSprite:overlappingSprites())

        if touch then
            shoot_target_Sound:play()
        else
            shoot_no_target_Sound:play()
        end
    end
end

function playdate.AButtonDown()
    if gameStatus == GameStatusEnum.GAME then
        fire(BarrelEnum.RIGHT)
    end
end

function playdate.BButtonDown()
    if gameStatus == GameStatusEnum.GAME then
        fire(BarrelEnum.LEFT)
    end
end
