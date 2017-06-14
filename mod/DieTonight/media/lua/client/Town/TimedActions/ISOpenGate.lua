--
-- Created by IntelliJ IDEA.
-- User: Sylvain
-- Date: 06/05/2017
-- Time: 11:09
-- To change this template use File | Settings | File Templates.
--

require "TimedActions/ISBaseTimedAction"

ISOpenGate = ISBaseTimedAction:derive("ISOpenGate");

-- This method is required by ISBaseTimedAction
-- but not by our algorithm
function ISOpenGate:isValid()
    return true;
end

-- Animation to open the gate
-- The gate opens from middle to each side
function ISOpenGate:update()
end

function ISOpenGate:start()
    self.character:faceThisObject(self.terminalTile);
    self.terminalTile:getSquare():playSound(GateProperties.soundPlayed, true);
end

function ISOpenGate:stop()
    if self.sound and self.sound:isPlaying() then
        self.sound:stop();
    end
    ISBaseTimedAction.stop(self);
end

function ISOpenGate:perform()
    -- On génère ici l'animation à partir de l'event Tick
    -- C'est le seul moyen d'obtenir un tempo multithreadé
    Events.OnTick.Add(ISOpenGate.OnTick);
    ISBaseTimedAction.perform(self);
end

function ISOpenGate:new(character, gate, terminalTile)
    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o.character = character;
    o.stopOnWalk = GateProperties.stopOnWalk;
    o.stopOnRun = GateProperties.stopOnRun;
    o.caloriesModifier = GateProperties.caloriesModifier;
    o.maxTime = GateProperties.maxTime;
    o.terminalTile = terminalTile;

    ISOpenGate.animationDuration = GateProperties.animationDuration*100;
    ISOpenGate.gate = gate;
    -- calculate and store the gate length
    ISOpenGate.gateLength = 0;
    -- animation left to right
    if gate.startPos.x == gate.endPos.x then
        ISOpenGate.gateLength = gate.startPos.y - gate.endPos.y;
    -- animation right to left
    elseif gate.startPos.y == gate.endPos.y then
        ISOpenGate.gateLength = gate.startPos.x - gate.endPos.x;
    end

    if ISOpenGate.gateLength%2 == 0 then
        ISOpenGate.squareIndex = math.floor(ISOpenGate.gateLength/2);
    else
        ISOpenGate.squareIndex = { bottom = math.floor(ISOpenGate.gateLength/2), top = math.floor(ISOpenGate.gateLength/2)+1 };
    end

    -- nb iterations by the method ISOpenGate.update()
    ISOpenGate.nbIteration = 0;
    ISOpenGate.nbIterationTotale = 0;
    -- nb iterations between 2 square update (open or close)
    ISOpenGate.intervalIteration = math.ceil(ISOpenGate.animationDuration/ISOpenGate.gateLength);

    return o
end

ISOpenGate.OnTick = function()
    if type(ISOpenGate.squareIndex) == "number" then
        if ISOpenGate.squareIndex <= ISOpenGate.gateLength and (ISOpenGate.nbIteration == ISOpenGate.intervalIteration) then

            -- if gate direction is on X axis
            if ISOpenGate.gate.startPos.x == ISOpenGate.gate.endPos.x then
                local sq = getCell():getGridSquare(ISOpenGate.gate.startPos.x, ISOpenGate.gate.startPos.y-ISOpenGate.squareIndex, 0);
                ISGate.removeFenceOnSquare(sq);
                -- if gate direction is on Y axis
            elseif ISOpenGate.gate.startPos.y == ISOpenGate.gate.endPos.y then
                local sq = getCell():getGridSquare(ISOpenGate.gate.startPos.x-ISOpenGate.squareIndex, ISOpenGate.gate.startPos.y, 0);
                ISGate.removeFenceOnSquare(sq);
            end
            ISOpenGate.squareIndex = { bottom = ISOpenGate.squareIndex-1, top = ISOpenGate.squareIndex+1 };
            ISOpenGate.nbIteration = 0;

        end
    else
        if (ISOpenGate.squareIndex.bottom >= 0 and ISOpenGate.squareIndex.top <= ISOpenGate.gateLength) and (ISOpenGate.nbIteration == ISOpenGate.intervalIteration) then

            -- if gate direction is on X axis
            if ISOpenGate.gate.startPos.x == ISOpenGate.gate.endPos.x then
                local squares = {
                    top = getCell():getGridSquare(ISOpenGate.gate.startPos.x, ISOpenGate.gate.startPos.y-ISOpenGate.squareIndex.top, 0),
                    bottom = getCell():getGridSquare(ISOpenGate.gate.startPos.x, ISOpenGate.gate.startPos.y-ISOpenGate.squareIndex.bottom, 0)
                };
                ISGate.removeFenceOnSquare(squares.top);
                ISGate.removeFenceOnSquare(squares.bottom);
                -- if gate direction is on Y axis
            elseif ISOpenGate.gate.startPos.y == ISOpenGate.gate.endPos.y then
                local squares = {
                    top = getCell():getGridSquare(ISOpenGate.gate.startPos.x-ISOpenGate.squareIndex.top, ISOpenGate.gate.startPos.y, 0),
                    bottom = getCell():getGridSquare(ISOpenGate.gate.startPos.x-ISOpenGate.squareIndex.bottom, ISOpenGate.gate.startPos.y, 0)
                };
                ISGate.removeFenceOnSquare(squares.top);
                ISGate.removeFenceOnSquare(squares.bottom);
            end
            ISOpenGate.squareIndex = { bottom = ISOpenGate.squareIndex.bottom-1, top = ISOpenGate.squareIndex.top+1 };
            ISOpenGate.nbIteration = 0;

        end
    end
    ISOpenGate.nbIteration = ISOpenGate.nbIteration+1; -- action timer
    ISOpenGate.nbIterationTotale = ISOpenGate.nbIterationTotale+1;
    if ISOpenGate.nbIterationTotale > ISOpenGate.animationDuration then
        Events.OnTick.Remove(ISOpenGate.OnTick);
    end
end
