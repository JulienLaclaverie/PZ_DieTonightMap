ISGateInteractionMenu = {};

ISGateInteractionMenu.doInteractMenu = function(player, context, worldobjects, test)
    if test and ISWorldObjectContextMenu.Test then return true end

    local object;
    local terminal;

    for i,v in ipairs(worldobjects) do
        -- print( "[DT-INFO] ISGateInteractionMenu: item seleted  --> " .. v:getSprite():getName() .. ", " .. tostring(v:getSquare():getX()) .. ", " .. tostring(v:getSquare():getY()) )
        terminal = ISGateSecurityTerminal.terminals[v:getSprite():getName()];
        object = v;
    end

    if ISGateInteractionMenu.isGateSecurityTerminal(object, terminal) then
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

Events.OnFillWorldObjectContextMenu.Add(ISGateInteractionMenu.doInteractMenu);