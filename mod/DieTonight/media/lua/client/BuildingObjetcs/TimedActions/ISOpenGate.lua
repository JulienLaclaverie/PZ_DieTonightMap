--
-- Created by IntelliJ IDEA.
-- User: Sylvain
-- Date: 06/05/2017
-- Time: 11:09
-- To change this template use File | Settings | File Templates.
--

require "TimedActions/ISBaseTimedAction"

ISOpenGate = ISBaseTimedAction:derive("ISOpenGate");

function ISOpenGate:isValid()
    local opened = ISGate.isOpen(self.gate);
    print("ISOpenGate: isValid --> " .. tostring(opened))
    -- return not opened;
    return true;
end

function ISOpenGate:update()
    -- self.character:faceThisObject(self.terminalTile)
    print("ISOpenGate: update... o.timestampStart="..tostring(self.nbIteration))

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
        self.squareIndex = self.squareIndex+1;
    end
    self.nbIteration = self.nbIteration+1;

end

function ISOpenGate:start()
    print("ISOpenGate: starting action")
    -- TODO: find the most appropriated sound
    self.terminalTile:getSquare():playSound("shoveling", true);
end

function ISOpenGate:stop()
    print("ISOpenGate: stopping...")
    if self.sound and self.sound:isPlaying() then
        self.sound:stop();
    end
    ISBaseTimedAction.stop(self);
end

function ISOpenGate:perform()
    print("ISOpenGate: performing...")
    ISBaseTimedAction.perform(self);
end

function ISOpenGate:new(character, gate, terminalTile)
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

    o.squareIndex = 0; -- the index of the square to remove (start from 0)
    -- calculate and store the gate length
    o.gateLength = 0;
    if gate.startPos.x == gate.endPos.x then
        o.gateLength = gate.startPos.y - gate.endPos.y;
    elseif gate.startPos.y == gate.endPos.y then
        o.gateLength = gate.startPos.x - gate.endPos.x;
    end
    -- nb iterations by the method ISOpenGate.update()
    o.nbIteration = 0;
    -- nb iterations between 2 square update (open or close)
    o.intervalIteration = math.floor(o.maxTime/o.gateLength);

    return o
end

