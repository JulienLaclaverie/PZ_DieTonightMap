ISInteractMenu = {};

ISInteractMenu.doInteractMenu = function(player, context, worldobjects, test)
    if test and ISWorldObjectContextMenu.Test then return true end

    -- Instanciate interaction menu here

    local object = nil;
    local terminal = nil;

    for i,v in ipairs(worldobjects) do
        -- print( "ISInteractMenu: item seleted  --> " .. v:getSprite():getName() .. ", " .. tostring(v:getSquare():getX()) .. ", " .. tostring(v:getSquare():getY()) )
        terminal = ISGateSecurityTerminal.terminals[v:getSprite():getName()];
        object = v;
    end

    if ISInteractMenu.isGateSecurityTerminal(object, terminal) then
        print("ISInteractMenu: found the Security Terminal for ".. terminal.gate .." !")
        local interactOption = context:addOption("Toggle gate", worldobjects, ISGate.toggle, terminal.gate);
    end
end

ISInteractMenu.isGateSecurityTerminal = function(obj, terminal)
    if terminal then
        return obj:getSquare():getX() == terminal.x and
               obj:getSquare():getY() == terminal.y;
    else
        return false;
    end
end

Events.OnFillWorldObjectContextMenu.Add(ISInteractMenu.doInteractMenu);