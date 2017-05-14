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
    if type(self.squareIndex) == "table" then
        if (self.squareIndex.bottom < self.squareIndex.top) and (self.nbIteration == 0 or self.nbIteration%self.intervalIteration == 0) then

            -- if gate direction to the south
            if self.gate.startPos.x == self.gate.endPos.x then
                local squares = {
                    top = getCell():getGridSquare(self.gate.startPos.x, self.gate.startPos.y-self.squareIndex.top, 0),
                    bottom = getCell():getGridSquare(self.gate.startPos.x, self.gate.startPos.y-self.squareIndex.bottom, 0)
                };
                ISGate.addFenceOnSquare(squares.top, self.gate.sprite, false);
                ISGate.addFenceOnSquare(squares.bottom, self.gate.sprite, false);
            -- if gate direction to the north
            elseif self.gate.startPos.y == self.gate.endPos.y then
                local squares = {
                    top = getCell():getGridSquare(self.gate.startPos.x-self.squareIndex.top, self.gate.startPos.y, 0),
                    bottom = getCell():getGridSquare(self.gate.startPos.x-self.squareIndex.bottom, self.gate.startPos.y, 0)
                };
                ISGate.addFenceOnSquare(squares.top, self.gate.sprite, true);
                ISGate.addFenceOnSquare(squares.bottom, self.gate.sprite, true);
            end
            self.squareIndex = { bottom = self.squareIndex.bottom+1, top = self.squareIndex.top-1 };

        elseif (self.squareIndex.top == math.floor(self.gateLength/2) and self.squareIndex.bottom == math.floor(self.gateLength/2)) and (self.nbIteration == 0 or self.nbIteration%self.intervalIteration == 0) then

            self.squareIndex = math.floor(self.gateLength/2);
            -- if gate direction to the south
            if self.gate.startPos.x == self.gate.endPos.x then
                local sq = getCell():getGridSquare(self.gate.startPos.x, self.gate.startPos.y-self.squareIndex, 0);
                ISGate.addFenceOnSquare(sq, self.gate.sprite, false);
            -- if gate direction to the north
            elseif self.gate.startPos.y == self.gate.endPos.y then
                local sq = getCell():getGridSquare(self.gate.startPos.x-self.squareIndex, self.gate.startPos.y, 0);
                ISGate.addFenceOnSquare(sq, self.gate.sprite, true);
            end

        end
    end
    self.nbIteration = self.nbIteration+1; -- action timer
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
    print("[DT-INFO] ISCloseGate: Gate closed !")
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
    ---- it seems like update() is called 25 times more than self.maxTime
    ---- fixme: I wrote 20 because it can arrive that update() is triggered only 23 or 24 times more than self.maxTime... :'(
    o.intervalIteration = math.ceil((o.maxTime+20)*2/o.gateLength);

    return o
end

