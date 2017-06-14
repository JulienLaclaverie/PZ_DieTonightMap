--
-- Created by IntelliJ IDEA.
-- User: Sylvain
-- Date: 06/05/2017
-- Time: 11:09
-- To change this template use File | Settings | File Templates.
--

require "TimedActions/ISBaseTimedAction"

ISCloseGate = ISBaseTimedAction:derive("ISCloseGate");

-- This method is required by ISBaseTimedAction
-- but not by our algorithm
function ISCloseGate:isValid()
    return true;
end

-- Animation to close the gate
-- The gate is closing from each side to the middle
function ISCloseGate:update()
end

function ISCloseGate:start()
    self.character:faceThisObject(self.terminalTile);
    self.terminalTile:getSquare():playSound(GateProperties.soundPlayed, true);
end

function ISCloseGate:stop()
    if self.sound and self.sound:isPlaying() then
        self.sound:stop();
    end
    ISBaseTimedAction.stop(self);
end

function ISCloseGate:perform()
    -- On génère ici l'animation à partir de l'event Tick
    -- C'est le seul moyen d'obtenir un tempo multithreadé
    Events.OnTick.Add(ISCloseGate.OnTick);
    ISBaseTimedAction.perform(self);
end

function ISCloseGate:new(character, gate, terminalTile)
    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o.character = character;
    o.stopOnWalk = GateProperties.stopOnWalk;
    o.stopOnRun = GateProperties.stopOnRun;
    o.caloriesModifier = GateProperties.caloriesModifier;
    o.maxTime = GateProperties.maxTime;
    o.terminalTile = terminalTile;

    ISCloseGate.animationDuration = GateProperties.animationDuration*100;
    ISCloseGate.gate = gate;
    -- calculate and store the gate length
    ISCloseGate.gateLength = 0;
    -- animation left to right
    if gate.startPos.x == gate.endPos.x then
        ISCloseGate.gateLength = gate.startPos.y - gate.endPos.y;
    elseif gate.startPos.y == gate.endPos.y then
    -- animation right to left
        ISCloseGate.gateLength = gate.startPos.x - gate.endPos.x;
    end
    -- squares which will contain the first fences
    ISCloseGate.squareIndex = { bottom = 0, top = ISCloseGate.gateLength };
    -- nb iterations by the method ISCloseGate.update()
    ISCloseGate.nbIteration = 0;
    ISCloseGate.nbIterationTotale = 0;
    -- nb iterations between 2 square update (open or close)
    ISCloseGate.intervalIteration = math.ceil(ISCloseGate.animationDuration/ISCloseGate.gateLength);

    return o
end

ISCloseGate.OnTick = function()
    if type(ISCloseGate.squareIndex) == "table" then
        if (ISCloseGate.squareIndex.bottom < ISCloseGate.squareIndex.top) and (ISCloseGate.nbIteration == ISCloseGate.intervalIteration) then

            -- if gate direction to the south
            if ISCloseGate.gate.startPos.x == ISCloseGate.gate.endPos.x then
                local squares = {
                    top = getCell():getGridSquare(ISCloseGate.gate.startPos.x, ISCloseGate.gate.startPos.y-ISCloseGate.squareIndex.top, 0),
                    bottom = getCell():getGridSquare(ISCloseGate.gate.startPos.x, ISCloseGate.gate.startPos.y-ISCloseGate.squareIndex.bottom, 0)
                };
                ISGate.addFenceOnSquare(squares.top, ISCloseGate.gate.sprite, false);
                ISGate.addFenceOnSquare(squares.bottom, ISCloseGate.gate.sprite, false);
                -- if gate direction to the north
            elseif ISCloseGate.gate.startPos.y == ISCloseGate.gate.endPos.y then
                local squares = {
                    top = getCell():getGridSquare(ISCloseGate.gate.startPos.x-ISCloseGate.squareIndex.top, ISCloseGate.gate.startPos.y, 0),
                    bottom = getCell():getGridSquare(ISCloseGate.gate.startPos.x-ISCloseGate.squareIndex.bottom, ISCloseGate.gate.startPos.y, 0)
                };
                ISGate.addFenceOnSquare(squares.top, ISCloseGate.gate.sprite, true);
                ISGate.addFenceOnSquare(squares.bottom, ISCloseGate.gate.sprite, true);
            end
            ISCloseGate.squareIndex = { bottom = ISCloseGate.squareIndex.bottom+1, top = ISCloseGate.squareIndex.top-1 };
            -- On remet à zéro le nombre d'itérations servant d'intervales
            ISCloseGate.nbIteration = 0;

        elseif (ISCloseGate.squareIndex.top == math.floor(ISCloseGate.gateLength/2) and ISCloseGate.squareIndex.bottom == math.floor(ISCloseGate.gateLength/2)) and (ISCloseGate.nbIteration == ISCloseGate.intervalIteration) then

            ISCloseGate.squareIndex = math.floor(ISCloseGate.gateLength/2);
            -- if gate direction to the south
            if ISCloseGate.gate.startPos.x == ISCloseGate.gate.endPos.x then
                local sq = getCell():getGridSquare(ISCloseGate.gate.startPos.x, ISCloseGate.gate.startPos.y-ISCloseGate.squareIndex, 0);
                ISGate.addFenceOnSquare(sq, ISCloseGate.gate.sprite, false);
                -- if gate direction to the north
            elseif ISCloseGate.gate.startPos.y == ISCloseGate.gate.endPos.y then
                local sq = getCell():getGridSquare(ISCloseGate.gate.startPos.x-ISCloseGate.squareIndex, ISCloseGate.gate.startPos.y, 0);
                ISGate.addFenceOnSquare(sq, ISCloseGate.gate.sprite, true);
            end
            -- On remet à zéro le nombre d'itérations servant d'intervales
            ISCloseGate.nbIteration = 0;

        end
    end
    ISCloseGate.nbIteration = ISCloseGate.nbIteration+1; -- action timer
    ISCloseGate.nbIterationTotale = ISCloseGate.nbIterationTotale + 1;
    if ISCloseGate.nbIterationTotale > ISCloseGate.animationDuration then
        Events.OnTick.Remove(ISCloseGate.OnTick);
    end
end

