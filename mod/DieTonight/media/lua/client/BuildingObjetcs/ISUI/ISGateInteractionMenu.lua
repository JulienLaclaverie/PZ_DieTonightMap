ISGateInteractionMenu = {};

ISGateInteractionMenu.doInteractMenu = function(player, context, worldobjects, test)
    if test and ISWorldObjectContextMenu.Test then return true end

    local object;
    local terminal;

    for i,v in ipairs(worldobjects) do
        terminal = ISGateSecurityTerminal.terminals[v:getSprite():getName()];
        object = v;
    end

    if ISGateInteractionMenu.isGateSecurityTerminal(object, terminal) and ISGateInteractionMenu.isTileOrAdjacent(getPlayer():getCurrentSquare(), object:getSquare()) then
        print("[DT-INFO] ISGateInteractionMenu: found the Security Terminal for ".. terminal.gate .." !")
        context:addOption("Toggle gate", worldobjects, ISGate.toggle, getSpecificPlayer(player), terminal.gate, object);
    end
end

-- Check if the terminal selected is a Gate Security Terminal
ISGateInteractionMenu.isGateSecurityTerminal = function(obj, terminal)
    if terminal then
        return obj:getSquare():getX() == terminal.x and
               obj:getSquare():getY() == terminal.y;
    else
        return false;
    end
end

-- Check if the player is next to the terminal square passed in second parameter
--- I have needed to rewrite this method from AdjacentFreeTileFinder because it was to restrictive
ISGateInteractionMenu.isTileOrAdjacent = function(a, b)
    if a:getX() == b:getX() and a:getY() == b:getY() then
        -- print("[DT-INFO] ISGateInteractionMenu: Same tile.")
        return true;
    end

    if(math.abs(a:getX() - b:getX()) > 1) or (math.abs(a:getY() - b:getY()) > 1) then
        -- print("[DT-INFO] ISGateInteractionMenu: Further than 1 away")
        return false;
    end

    if not AdjacentFreeTileFinder.privTrySquareForWalls2(a, b:getX(), a:getY(), a:getZ()) or
       not AdjacentFreeTileFinder.privTrySquareForWalls2(a, a:getX(), b:getY(), a:getZ()) then
        -- print("[DT-INFO] ISGateInteractionMenu: Is not adjacent because there is a wall between them")
        return false;
    end

    return true;
end

Events.OnFillWorldObjectContextMenu.Add(ISGateInteractionMenu.doInteractMenu);