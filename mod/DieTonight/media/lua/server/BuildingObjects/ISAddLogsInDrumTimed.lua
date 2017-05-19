--***********************************************************
--**             Override add logs timed action            **
--***********************************************************

require "TimedActions/ISBaseTimedAction"

ISAddLogsInDrumTimed = ISBaseTimedAction:derive("ISAddLogsInDrumTimed");

function ISAddLogsInDrumTimed:isValid()
    return true;
end

function ISAddLogsInDrumTimed:update()
end

function ISAddLogsInDrumTimed:start()
end

function ISAddLogsInDrum:stop()
    ISBaseTimedAction.stop(self);
end

function ISAddLogsInDrumTimed:perform()
    ISBaseTimedAction.perform(self);
    if self.add then
        for i=0,1 do
            self.character:getInventory():Remove("Log");
        end
        ISMetalDrum.addLogs(self.metalDrum, true);
    else
        for i=0,1 do
            self.character:getInventory():AddItem("Base.Log");
        end
        ISMetalDrum.addLogs(self.metalDrum, false);
    end
end

function ISAddLogsInDrumTimed:new(character, metalDrum, add)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.maxTime = 30;
    o.metalDrum = metalDrum;
    o.character  = character;
    o.add = add;
    return o;
end
