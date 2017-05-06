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

ISGate.toggle = function(target, player, gateName, terminalTile)
    local gate = ISGate.gates[gateName];
    if gate then
        if ISGate.isOpen(gate) then
            print( "ISGate: " .. gateName .. " is opened ! Closing..." );
            ISGate.close(gate);
        else
            print( "ISGate: " .. gateName .. " is closed ! Opening..." );
            ISTimedActionQueue.add(ISOpenGate:new(player, gate, terminalTile));
        end
    else
        print( "ISGate: Not gate found for this security terminal ! The gate registered for this terminal is " .. gateName );
    end
end

-- Check if the gate passed in parameter is open
ISGate.isOpen = function(gate)
    local isOpened = true;
    ISGate.browseGateSquares(gate, function(square)
        if square then
            isOpened = not ISGate.squareHasFence(square);
        end
    end)
    return isOpened;
end

-- Close the gate passed in parameter
ISGate.close = function(gate)
    -- print( "ISGate: closing gate --> " .. gate.startPos.x .. ", " .. gate.startPos.y )
    ISGate.browseGateSquares(gate, function(square)
        if square then
            local fence = IsoObject.new(getCell(), square, gate.sprite);
            square:getObjects():add(fence);
            -- square:RecalcProperties();
        end
    end)
end

-- DEPRECATED
-- Open the gate passed in parameter
ISGate.open = function(gate)
    -- print( "ISGate: opening gate --> " .. gate.startPos.x .. ", " .. gate.startPos.y )
    ISGate.browseGateSquares(gate, function(square)
        if square then
            -- print( "ISGate: square --> " .. tostring(square:getX()) .. "," .. tostring(square:getY()) )
            for i=0,square:getObjects():size()-1 do
                local obj = square:getObjects():get(i);
                -- print( "ISGate: obj sprite --> " .. obj:getSprite():getName() )
                if luautils.stringStarts(obj:getSprite():getName(), ISGate.fenceSpriteName) then
                    -- print( "ISGate: removing fence from square" )
                    square:getObjects():remove(obj);
                    -- square:RecalcProperties();
                    break;
                end
            end
        end
    end)
end

-- Iterate on the gate squares
ISGate.browseGateSquares = function(gate, callback)
    -- if gate direction is on X axis
    if gate.startPos.x == gate.endPos.x then
        local gateLength = gate.startPos.y - gate.endPos.y;
        for i=0,gateLength do
            local sq = getCell():getGridSquare(gate.startPos.x, gate.startPos.y-i, 0);
            callback(sq);
        end
    -- if gate direction is on Y axis
    elseif gate.startPos.y == gate.endPos.y then
        local gateLength = gate.startPos.x - gate.endPos.x;
        for i=0,gateLength do
            local sq = getCell():getGridSquare(gate.startPos.x-i, gate.startPos.y, 0);
            callback(sq);
        end
    else
        callback(nil);
    end
end

ISGate.removeFenceOnSquare = function(square)
    for i=0,square:getObjects():size()-1 do
        local obj = square:getObjects():get(i);
        -- print( "ISGate: obj sprite --> " .. obj:getSprite():getName() )
        if luautils.stringStarts(obj:getSprite():getName(), ISGate.fenceSpriteName) then
            -- print( "ISGate: removing fence from square" )
            square:getObjects():remove(obj);
            -- square:RecalcProperties();
            break;
        end
    end
end

-- Check if square contains a fence
ISGate.squareHasFence = function(square)
    for i=0,square:getObjects():size()-1 do
        local obj = square:getObjects():get(i);
        if luautils.stringStarts(obj:getSprite():getName(), ISGate.fenceSpriteName) then
            return true;
        end
    end
    return false;
end