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
    -- self.character:faceThisObject(self.terminalTile)

    if type(self.squareIndex) == "table" then
        if (self.squareIndex.bottom < self.squareIndex.top) and (self.nbIteration == 0 or self.nbIteration%self.intervalIteration == 0) then

            -- if gate direction is on X axis
            if self.gate.startPos.x == self.gate.endPos.x then
                local squares = {
                    top = getCell():getGridSquare(self.gate.startPos.x, self.gate.startPos.y-self.squareIndex.top, 0),
                    bottom = getCell():getGridSquare(self.gate.startPos.x, self.gate.startPos.y-self.squareIndex.bottom, 0)
                };
                ISGate.addFenceOnSquare(squares.top, self.gate.sprite);
                ISGate.addFenceOnSquare(squares.bottom, self.gate.sprite);
            -- if gate direction is on Y axis
            elseif self.gate.startPos.y == self.gate.endPos.y then
                local squares = {
                    top = getCell():getGridSquare(self.gate.startPos.x-self.squareIndex.top, self.gate.startPos.y, 0),
                    bottom = getCell():getGridSquare(self.gate.startPos.x-self.squareIndex.bottom, self.gate.startPos.y, 0)
                };
                ISGate.addFenceOnSquare(squares.top, self.gate.sprite);
                ISGate.addFenceOnSquare(squares.bottom, self.gate.sprite);
            end
            self.squareIndex = { bottom = self.squareIndex.bottom+1, top = self.squareIndex.top-1 };

        elseif (self.squareIndex.top == math.floor(self.gateLength/2) and self.squareIndex.bottom == math.floor(self.gateLength/2)) and (self.nbIteration == 0 or self.nbIteration%self.intervalIteration == 0) then

            self.squareIndex = math.floor(self.gateLength/2);
            -- if gate direction is on X axis
            if self.gate.startPos.x == self.gate.endPos.x then
                local sq = getCell():getGridSquare(self.gate.startPos.x, self.gate.startPos.y-self.squareIndex, 0);
                ISGate.addFenceOnSquare(sq, self.gate.sprite);
            -- if gate direction is on Y axis
            elseif self.gate.startPos.y == self.gate.endPos.y then
                local sq = getCell():getGridSquare(self.gate.startPos.x-self.squareIndex, self.gate.startPos.y, 0);
                ISGate.addFenceOnSquare(sq, self.gate.sprite);
            end

        end
    end
    self.nbIteration = self.nbIteration+1; -- action timer
end

function ISCloseGate:start()
    -- TODO: find the most appropriated sound
    self.terminalTile:getSquare():playSound(GateAnimationConf.soundPlayed, true);
end

function ISCloseGate:stop()
    if self.sound and self.sound:isPlaying() then
        self.sound:stop();
    end
    ISBaseTimedAction.stop(self);
end

function ISCloseGate:perform()
    print("ISCloseGate: Gate closed !")
    ISBaseTimedAction.perform(self);
end

function ISCloseGate:new(character, gate, terminalTile)
    local o = {}
    setmetatable(o, self)
    self.__index = self
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
    elseif gate.startPos.y == gate.endPos.y then
    -- animation right to left
        o.gateLength = gate.startPos.x - gate.endPos.x;
    end
    -- squares which will contain the first fences
    o.squareIndex = { bottom = 0, top = o.gateLength };
    -- nb iterations by the method ISCloseGate.update()
    o.nbIteration = 0;
    -- nb iterations between 2 square update (open or close)
    o.intervalIteration = math.floor(o.maxTime/o.gateLength);

    return o
end

