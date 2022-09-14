local pd <const> = playdate
local gfx <const> = playdate.graphics

import "utils/Utils"

class('DuckAreaSprite').extends(gfx.sprite)

function DuckAreaSprite:init()
    DuckAreaSprite.super.init(self)
    self.killCount = 0
    self.previousLoopTime = 0
    self.previousRandomDirection = -1
    self.ducks = {}

    self:resetGenerationTimer()
end

function DuckAreaSprite:manageFire(sprites)

    for i = 1, #sprites, 1 do
        if not sprites[i].isDied then
            self.killCount = self.killCount + 1
            sprites[i]:die()
            -- Todo : add animation
        end
    end

    print(#sprites)
end

function DuckAreaSprite:removeUselessDucks()
    local newDuckList = {}

    for key, value in pairs(self.ducks) do
        if not value.isDied and value.x < 450 and value.x > -40 and value.y > -50 then
            table.insert(newDuckList, value)
        else
            gfx.sprite.removeSprite(value)
        end
    end

    self.ducks = newDuckList
end

function DuckAreaSprite:generateDuck()
    local count = self:duckGenerationTimer();

    if count > 1000 then

        local randomDirection = self:getRandomDirection()

        local startPositionX, startPositionY = self:getRandomStartPosition(randomDirection)

        local newDuck = DuckSprite(startPositionX, startPositionY, 40, 40, randomDirection)
        newDuck:add()
        table.insert(self.ducks, newDuck)

        self:resetGenerationTimer()
    end
end

function DuckAreaSprite:getRandomStartPosition(direction)
    math.randomseed(playdate.getSecondsSinceEpoch())
    local startPositionX = 0
    local startPositionY = 0

    if direction == DuckMovementDirectionEnum.TOP then
        startPositionX = math.random(5, 360)
        startPositionY = 240
    elseif direction == DuckMovementDirectionEnum.LEFT then
        startPositionX = 400
        startPositionY = math.random(0, 150)
    elseif direction == DuckMovementDirectionEnum.RIGHT then
        startPositionX = -40
        startPositionY = math.random(0, 150)
    elseif direction == DuckMovementDirectionEnum.DIAGONAL_LEFT then
        startPositionX = math.random(200, 360)
        startPositionY = 240
    elseif direction == DuckMovementDirectionEnum.DIAGONAL_RIGHT then
        startPositionX = math.random(5, 165)
        startPositionY = 240
    end

    return startPositionX, startPositionY
end

function DuckAreaSprite:getRandomDirection()
    math.randomseed(playdate.getSecondsSinceEpoch())
    local random = math.random(0, 4)

    if self.previousRandomDirection == random then
        random = math.random(0, 4)
    end

    return random
end

function DuckAreaSprite:update()
    DuckAreaSprite.super.update(self)

    self:removeUselessDucks()


    self:generateDuck()

end

function DuckAreaSprite:duckGenerationTimer()
    local currentTime = playdate.getCurrentTimeMilliseconds()
    local deltaTime = currentTime - self.previousLoopTime

    return deltaTime
end

function DuckAreaSprite:resetGenerationTimer()
    self.previousLoopTime = playdate.getCurrentTimeMilliseconds()
end
