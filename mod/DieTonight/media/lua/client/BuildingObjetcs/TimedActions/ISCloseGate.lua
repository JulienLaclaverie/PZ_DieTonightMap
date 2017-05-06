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

function ISCloseGate:update()
    -- self.character:faceThisObject(self.terminalTile)
    if self.squareIndex >= 0 and (self.nbIteration == 0 or self.nbIteration%self.intervalIteration == 0) then

        -- if gate direction is on X axis
        if self.gate.startPos.x == self.gate.endPos.x then
            local sq = getCell():getGridSquare(self.gate.startPos.x, self.gate.startPos.y-self.squareIndex, 0);
            ISGate.addFenceOnSquare(sq, self.gate.sprite);
        -- if gate direction is on Y axis
        elseif self.gate.startPos.y == self.gate.endPos.y then
            local sq = getCell():getGridSquare(self.gate.startPos.x-self.squareIndex, self.gate.startPos.y, 0);
            ISGate.addFenceOnSquare(sq, self.gate.sprite);
        end
        self.squareIndex = self.squareIndex-1;

    end
    self.nbIteration = self.nbIteration+1;
end

function ISCloseGate:start()
    -- TODO: find the most appropriated sound
    self.terminalTile:getSquare():playSound("shoveling", true);
end

function ISCloseGate:stop()
    if self.sound and self.sound:isPlaying() then
        self.sound:stop();
    end
    ISBaseTimedAction.stop(self);
end

function ISCloseGate:perform()
    print("ISCloseGate: Gate close !")
    ISBaseTimedAction.perform(self);
end

function ISCloseGate:new(character, gate, terminalTile)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.character = character;
    o.stopOnWalk = false;
    o.stopOnRun = false;
    o.caloriesModifier = 1;
    o.maxTime = 100; -- 100=2sec , 250=6sec
    o.gate = gate;
    o.terminalTile = terminalTile;

    -- calculate and store the gate length
    o.gateLength = 0;
    if gate.startPos.x == gate.endPos.x then
        o.gateLength = gate.startPos.y - gate.endPos.y;
    elseif gate.startPos.y == gate.endPos.y then
        o.gateLength = gate.startPos.x - gate.endPos.x;
    end
    o.squareIndex = o.gateLength; -- the index of the square to remove (start from the last square)
    -- nb iterations by the method ISCloseGate.update()
    o.nbIteration = 0;
    -- nb iterations between 2 square update (open or close)
    o.intervalIteration = math.floor(o.maxTime/o.gateLength);

    return o
end

