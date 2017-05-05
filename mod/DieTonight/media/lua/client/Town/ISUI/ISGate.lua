--
-- Created by IntelliJ IDEA.
-- User: Sylvain
-- Date: 05/05/2017
-- Time: 12:36
-- To change this template use File | Settings | File Templates.
--

-- local variables
local fenceSpriteName = "fencing_01";
-- local functions
local browseGateSquares, hasFence;


--
-- Properties
--

ISGate = {
    gates = {
        northGate = {
            startPos = { x = 7944, y = 6382 },
            endPos = { x = 7934, y = 6382 }
        },
        southGate = {
            startPos = { x = 7948, y = 6464 },
            endPos = { x = 7938, y = 6464 }
        },
        westGate = {
            startPos = { x = 7918, y = 6426 }, -- fencing_01_58
            endPos = { x = 7918, y = 6416 } -- fencing_01_58
        },
        eastGate = {
            startPos = { x = 6429, y = 7971 },
            endPos = { x = 6419, y = 7971 }
        }
    }
};


--
-- Methods
--

ISGate.toggle = function(target, gateName)
    print( "Asking to toggle the gate " .. tostring(gateName) )
    local gate = ISGate.gates[gateName];
    if gate then
        if ISGate.isOpen(gate) then
            print( "ISGate: " .. gateName .. " is open !" );
        else
            print( "ISGate: " .. gateName .. " is close !" );
        end
    else
        print( "ISGate: Not gate found for this security terminal ! The gate registered for this terminal is " .. gateName );
    end
end

-- Check if the gate passed in parameter is open
ISGate.isOpen = function(gate)
    local isOpen = true;
    -- if gate direction is on X axis
    if gate.startPos.x == gate.endPos.x then
        local gateLength = gate.startPos.y - gate.endPos.y;
        for i=0,gateLength do
            local sq = getCell():getGridSquare(gate.startPos.x, gate.startPos.y-i, 0);
            isOpen = not hasFence(sq);
        end
    -- if gate direction is on Y axis
    elseif gate.startPos.y == gate.endPos.y then
        local gateLength = gate.startPos.x - gate.endPos.x;
        for i=0,gateLength do
            local sq = getCell():getGridSquare(gate.startPos.x-i, gate.startPos.y, 0);
            isOpen = not hasFence(sq);
        end
    else
        return nil;
    end

    return isOpen;
end

ISGate.open = function(gate)
    -- if gate direction is on X axis
    if gate.startPos.x == gate.endPos.x then
        local gateLength = gate.startPos.y - gate.endPos.y;
        for i=0,gateLength do
            local sq = getCell():getGridSquare(gate.startPos.x, gate.startPos.y-i, 0);
            isOpen = not hasFence(sq);
        end
        -- if gate direction is on Y axis
    elseif gate.startPos.y == gate.endPos.y then
        local gateLength = gate.startPos.x - gate.endPos.x;
        for i=0,gateLength do
            local sq = getCell():getGridSquare(gate.startPos.x-i, gate.startPos.y, 0);
            isOpen = not hasFence(sq);
        end
    end
    --[[local object = IsoObject.new(getCell(), sq, "location_shop_mall_01_19");
    sq:getObjects():add(object);
    sq:RecalcProperties();]]
end

ISGate.close = function(gate)
    --[[local obj = square:getObjects():get(i);
    if obj:getType() == IsoObjectType.fence then -- fence is not the real type
        square:transmitRemoveItemFromSquare(thump);
        square:getObjects():remove(thump);
    end]]
end


--
-- Local functions
--

--function browseGateSquares(gate, callback)
--    -- if gate direction is on X axis
--    if gate.startPos.x == gate.endPos.x then
--        local gateLength = gate.startPos.y - gate.endPos.y;
--        for i=0,gateLength do
--            local sq = getCell():getGridSquare(gate.startPos.x, gate.startPos.y-i, 0);
--            callback(sq);
--        end
--        -- if gate direction is on Y axis
--    elseif gate.startPos.y == gate.endPos.y then
--        local gateLength = gate.startPos.x - gate.endPos.x;
--        for i=0,gateLength do
--            local sq = getCell():getGridSquare(gate.startPos.x-i, gate.startPos.y, 0);
--            callback(sq);
--        end
--    end
--end

-- Check if square contains a fence
function hasFence(square)
    for i=0,square:getObjects():size()-1 do
        local obj = square:getObjects():get(i);
        if luautils.stringStarts(obj:getSprite():getName(), fenceSpriteName) then
            return true;
        end
    end
    return false;
end