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
    -- self.character:faceThisObject(self.terminalTile)
    if type(self.squareIndex) == "number" then
        if self.squareIndex <= self.gateLength and (self.nbIteration == 0 or self.nbIteration%self.intervalIteration == 0) then

            -- if gate direction is on X axis
            if self.gate.startPos.x == self.gate.endPos.x then
                local sq = getCell():getGridSquare(self.gate.startPos.x, self.gate.startPos.y-self.squareIndex, 0);
                ISGate.removeFenceOnSquare(sq);
            -- if gate direction is on Y axis
            elseif self.gate.startPos.y == self.gate.endPos.y then
                local sq = getCell():getGridSquare(self.gate.startPos.x-self.squareIndex, self.gate.startPos.y, 0);
                ISGate.removeFenceOnSquare(sq);
            end
            self.squareIndex = { bottom = self.squareIndex-1, top = self.squareIndex+1 };

        end
    else
        if (self.squareIndex.bottom >= 0 and self.squareIndex.top <= self.gateLength) and (self.nbIteration == 0 or self.nbIteration%self.intervalIteration == 0) then

            -- if gate direction is on X axis
            if self.gate.startPos.x == self.gate.endPos.x then
                local squares = {
                    top = getCell():getGridSquare(self.gate.startPos.x, self.gate.startPos.y-self.squareIndex.top, 0),
                    bottom = getCell():getGridSquare(self.gate.startPos.x, self.gate.startPos.y-self.squareIndex.bottom, 0)
                };
                ISGate.removeFenceOnSquare(squares.top);
                ISGate.removeFenceOnSquare(squares.bottom);
            -- if gate direction is on Y axis
            elseif self.gate.startPos.y == self.gate.endPos.y then
                local squares = {
                    top = getCell():getGridSquare(self.gate.startPos.x-self.squareIndex.top, self.gate.startPos.y, 0),
                    bottom = getCell():getGridSquare(self.gate.startPos.x-self.squareIndex.bottom, self.gate.startPos.y, 0)
                };
                ISGate.removeFenceOnSquare(squares.top);
                ISGate.removeFenceOnSquare(squares.bottom);
            end
            self.squareIndex = { bottom = self.squareIndex.bottom-1, top = self.squareIndex.top+1 };

        end
    end
    self.nbIteration = self.nbIteration+1; -- action timer
end

function ISOpenGate:start()
    -- TODO: find the most appropriated sound
    self.terminalTile:getSquare():playSound(GateAnimationConf.soundPlayed, true);
end

function ISOpenGate:stop()
    if self.sound and self.sound:isPlaying() then
        self.sound:stop();
    end
    ISBaseTimedAction.stop(self);
end

function ISOpenGate:perform()
    print("[DT-INFO] ISOpenGate: Gate opened !")
    ISBaseTimedAction.perform(self);
end

function ISOpenGate:new(character, gate, terminalTile)
    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o.character = character;
    o.stopOnWalk = GateAnimationConf.stopOnWalk;
    o.stopOnRun = GateAnimationConf.stopOnRun;
    o.caloriesModifier = GateAnimationConf.caloriesModifier;
    o.maxTime = GateAnimationConf.maxTime;
    o.gate = gate;
    o.terminalTile = terminalTile;

    -- calculate and store the gate length
    o.gateLength = 0;
    -- animation left to right
    if gate.startPos.x == gate.endPos.x then
        o.gateLength = gate.startPos.y - gate.endPos.y;
    -- animation right to left
    elseif gate.startPos.y == gate.endPos.y then
        o.gateLength = gate.startPos.x - gate.endPos.x;
    end

    if o.gateLength%2 == 0 then
        o.squareIndex = math.floor(o.gateLength/2);
    else
        o.squareIndex = { bottom = math.floor(o.gateLength/2), top = math.floor(o.gateLength/2)+1 };
    end

    -- nb iterations by the method ISOpenGate.update()
    o.nbIteration = 0;
    -- nb iterations between 2 square update (open or close)
    o.intervalIteration = math.floor(o.maxTime/o.gateLength);

    return o
end

