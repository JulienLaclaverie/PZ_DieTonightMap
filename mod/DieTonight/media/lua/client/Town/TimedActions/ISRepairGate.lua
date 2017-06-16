-- ================================================
--           PZ Die2Nite Map & mod              
--           File created by Sylvain               
--           Date: 16/06/2017                         
--           Time: 11:58                         
-- ================================================

require "TimedActions/ISBaseTimedAction"

ISRepairGate = ISBaseTimedAction:derive("ISRepairGate");

-- This method is required by ISBaseTimedAction
-- but not by our algorithm
function ISRepairGate:isValid()
    return true;
end

-- Animation to open the gate
-- The gate opens from middle to each side
function ISRepairGate:update()
end

function ISRepairGate:start()
    self.character:faceThisObject(self.worldObject);
    self.worldObject:getSquare():playSound("unlockDoor", true);
end

function ISRepairGate:stop()
    if self.sound and self.sound:isPlaying() then
        self.sound:stop();
    end
    ISBaseTimedAction.stop(self);
end

function ISRepairGate:perform()
    -- on enlève les éléments requis de l'inventaire du joueur
    for i=1,TerminalHealthInfos.repairRequirements.electricWires do
        self.character:getInventory():Remove("ElectricWire");
    end
    for i=1,TerminalHealthInfos.repairRequirements.electricScraps do
        self.character:getInventory():Remove("ElectronicsScrap");
    end

    local repairedCondition = (TerminalHealthInfos.health / 2) + (5 * self.perkLevel);
    if repairedCondition > TerminalHealthInfos.health then
        repairedCondition = TerminalHealthInfos.health;
    end
    ISGate.setHealth(repairedCondition);

    ISBaseTimedAction.perform(self);
end

function ISRepairGate:new(character, worldObject)
    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o.character = character;
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.caloriesModifier = 1;
    o.perkLevel = character:getPerkLevel(Perks.Electricity);
    if o.perkLevel < 1 then
        o.perkLevel = 1;
    end
    o.worldObject = worldObject;
    o.maxTime = 1000 / o.perkLevel;
    return o
end