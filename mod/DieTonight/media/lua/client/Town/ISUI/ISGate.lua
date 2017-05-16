--
-- Created by IntelliJ IDEA.
-- User: Sylvain
-- Date: 05/05/2017
-- Time: 12:36
-- To change this template use File | Settings | File Templates.
--


--
-- Properties
--

ISGate = {
    fenceSpriteName = "fencing_01",

    gates = {
        northGate = {
            startPos = { x = 7944, y = 6384 },
            endPos = { x = 7934, y = 6384 },
            sprite = "fencing_01_57"
        },
        southGate = {
            startPos = { x = 7948, y = 6464 },
            endPos = { x = 7938, y = 6464 },
            sprite = "fencing_01_57"
        },
        westGate = {
            startPos = { x = 7918, y = 6426 },
            endPos = { x = 7918, y = 6416 },
            sprite = "fencing_01_58"
        },
        eastGate = {
            startPos = { x = 7971, y = 6429 },
            endPos = { x = 7971, y = 6419 },
            sprite = "fencing_01_58"
        }
    }
};


--
-- Methods
--

ISGate.toggle = function(target, player, terminal, terminalTile)
    local gate = ISGate.gates[terminal.gate];
    -- We check if the player hasn't moved after the Toggle Gate option showed up
    if gate and ISGateInteractionMenu.isOnInteractionZone(terminal, player) then
        if ISGate.isOpen(gate) then
            print( "[DT-INFO] ISGate: " .. terminal.gate .. " is opened ! Closing..." );
            ISTimedActionQueue.add(ISCloseGate:new(player, gate, terminalTile));
        else
            print( "[DT-INFO] ISGate: " .. terminal.gate .. " is closed ! Opening..." );
            ISTimedActionQueue.add(ISOpenGate:new(player, gate, terminalTile));
        end
    else
        print( "[DT-INFO] ISGate: No gate found for this security terminal ! The gate registered for this terminal is " .. terminal.gate );
    end
end

-- Check if the gate passed in parameter is open
ISGate.isOpen = function(gate)
    local isOpened = true;

    -- if gate direction is on X axis
    if gate.startPos.x == gate.endPos.x then
        local gateLength = gate.startPos.y - gate.endPos.y;
        for i=0,gateLength do
            local sq = getCell():getGridSquare(gate.startPos.x, gate.startPos.y-i, 0);
            isOpened = not ISGate.squareHasFence(sq);
        end
    -- if gate direction is on Y axis
    elseif gate.startPos.y == gate.endPos.y then
        local gateLength = gate.startPos.x - gate.endPos.x;
        for i=0,gateLength do
            local sq = getCell():getGridSquare(gate.startPos.x-i, gate.startPos.y, 0);
            isOpened = not ISGate.squareHasFence(sq);
        end
    else
        return nil;
    end

    return isOpened;
end

-- Add fence on the square passed in parameter
ISGate.addFenceOnSquare = function(square, sprite, isNorth)
    local fence = ISGate.newFence(square, sprite, isNorth);
    square:AddSpecialObject(fence);
    fence:transmitCompleteItemToServer();
end

-- Remove fence on the square passed in parameter
ISGate.removeFenceOnSquare = function(square)
    for i=0,square:getObjects():size()-1 do
        local obj = square:getObjects():get(i);
        if obj:getSprite():getName() and luautils.stringStarts(obj:getSprite():getName(), ISGate.fenceSpriteName) then
            square:transmitRemoveItemFromSquare(obj);
            square:RemoveTileObject(obj);
            -- FIXME: Remove break to prevent duplicated fence on the same square
            -- but some problems appear : the index of the table has changed after deletion
            break;
        end
    end
end

-- Check if square contains a fence
ISGate.squareHasFence = function(square)
    for i=0,square:getObjects():size()-1 do
        local obj = square:getObjects():get(i);
        -- print( "[DT-INFO] ISGate: square contains --> " .. tostring(obj:getSprite():getName()) .. " ("..tostring(obj)..") |--> obj is IsoWorldInventoryObject : " .. tostring(instanceof(obj, "IsoWorldInventoryObject")) )
        if obj:getSprite():getName() and luautils.stringStarts(obj:getSprite():getName(), ISGate.fenceSpriteName) then
            return true;
        end
    end
    return false;
end

ISGate.newFence = function(square, sprite, isNorth)
    local fence = IsoThumpable.new(getCell(), square, sprite, isNorth, {});
    fence:setCanPassThrough(false);
    fence:setCanBarricade(false);
    fence:setThumpDmg(GateProperties.thumpDmg);
    fence:setMaxHealth(GateProperties.maxHealth);
    fence:setIsContainer(false);
    fence:setIsDoor(false);
    fence:setIsDoorFrame(false);
    fence:setCrossSpeed(1.0);
    fence:setBlockAllTheSquare(false);
    fence:setName("Object");
    fence:setIsDismantable(false);
    fence:setCanBePlastered(false);
    fence:setIsHoppable(false);
    fence:setIsThumpable(true);
    fence:setModData({});
    -- the sound that will be played when our furniture will be broken
    fence:setBreakSound("breakdoor");
    return fence;
end