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
local menuBackgroundImage = gfx.image.new("images/menu")
local fontStandardBold = playdate.graphics.font.new('fonts/StandardBold')
local fontStandard = playdate.graphics.font.new('fonts/Standard')
local fontLarge = playdate.graphics.font.new('fonts/Asheville-Mono-Light-24-px')
local shoot_target_Sound = playdate.sound.sampleplayer.new("sounds/shoot-target")
local shoot_no_target_Sound = playdate.sound.sampleplayer.new("sounds/shoot-no-target")
local scoreSound = playdate.sound.sampleplayer.new("sounds/arrive-score")
local startGameSound = playdate.sound.sampleplayer.new("sounds/dogs-start-game")
local gameSound = playdate.sound.sampleplayer.new("sounds/game")
local start_menu_Sound = playdate.sound.sampleplayer.new("sounds/start-menu")

start_menu_Sound:play();

local systemMenu = playdate.getSystemMenu()
local restartGameMenu = nil

local function stopGame()
    gameSound:stop()
    finalScore = duckAreaSprite.killCount
    playdate.graphics.sprite.removeAll()
    playdate.graphics.clear()
    gunSprite = nil
    targetSprite = nil
    duckAreaSprite = nil

    systemMenu:removeMenuItem(restartGameMenu)
end

local function startGame()
    start_menu_Sound:stop()
    gfx.getSystemFont(gfx.font.kVariantNormal)

    gunSprite = GunSprite(0, 0)
    gunSprite:add()

    targetSprite = TargetSprite(400 / 2 - 20, 240 / 2, 40, 40)
    targetSprite:add()

    duckAreaSprite = DuckAreaSprite()
    duckAreaSprite:add()

    gameTimerInitialValue = playdate.getCurrentTimeMilliseconds()
    startGameSound:play()
    gameSound:play(0)

    local menuItem, error = systemMenu:addMenuItem("Restart game", function()
        stopGame()
        startGame()
    end)
    restartGameMenu = menuItem
end

local function showScore()
    stopGame()

    gameStatus = GameStatusEnum.SCORE

    scoreSound:play()
end

local function updateMenu()
    if gameStatus == GameStatusEnum.MENU or gameStatus == GameStatusEnum.SCORE then

        gfx.setFont(fontStandardBold)
        menuBackgroundImage:draw(0, 0)

        local textsXPosition = 170

        if gameStatus == GameStatusEnum.SCORE then
            gfx.setFont(fontLarge)
            gfx.drawText("Score : " .. finalScore, textsXPosition, 130)
            gfx.setFont(fontStandardBold)
            gfx.drawText("Press A to restart.", textsXPosition, 200)
        else
            gfx.setFont(fontStandard)

            gfx.drawText("Shoot ducks with A and B.", textsXPosition, 120)
            gfx.drawText("The gun has only 2 bullets.", textsXPosition, 140)
            gfx.drawText("Use crank to reload.", textsXPosition, 160)

            gfx.setFont(fontStandardBold)
            gfx.drawText("Press A to start.", textsXPosition, 200)

        end

        if playdate.buttonJustPressed(playdate.kButtonA) and not playdate.isCrankDocked() then
            scoreSound:stop()
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
