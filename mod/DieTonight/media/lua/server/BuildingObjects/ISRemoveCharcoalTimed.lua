--***********************************************************
--**          Override remove coal timed action            **
--***********************************************************

require "TimedActions/ISBaseTimedAction"

ISRemoveCharcoalTimed = ISBaseTimedAction:derive("ISRemoveCharcoalTimed");

function ISRemoveCharcoalTimed:isValid()
	return true;
end

function ISRemoveCharcoalTimed:update()
end

function ISRemoveCharcoalTimed:start()
end

function ISRemoveCharcoalTimed:stop()
	ISBaseTimedAction.stop(self);
end

function ISRemoveCharcoalTimed:perform()
	ISBaseTimedAction.perform(self);
    ISMetalDrum.addCharcoal(self.metalDrum, false);
    self.character:getInventory():AddItem("Base.Charcoal");
end

function ISRemoveCharcoalTimed:new(character, metalDrum)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.stopOnWalk = true;
	o.stopOnRun = true;
	o.maxTime = 70;
    o.metalDrum = metalDrum;
	o.character  = character;
	return o;
end
