ISGateInteractionMenu = {};

-- Gate security terminals table
ISGateInteractionMenu.terminals = {

    -- West Gate Security Terminal
    {
        x = 7917, y = 6428, gate = "westGate",
        interactionZone = { x = 7917, y = 6429 }
    },

    -- North Gate Security Terminal
    {
        x = 7946, y = 6383, gate = "northGate",
        interactionZone = { x = 7947, y = 6383 }
    },

    -- East Gate Security Terminal
    {
        x = 7970, y = 6431, gate = "eastGate",
        interactionZone = { x = 7970, y = 6432 }
    },

    -- South Gate Security Terminal
    {
        x = 7950, y = 6463, gate = "southGate",
        interactionZone = { x = 7951, y = 6463 }
    }
};

ISGateInteractionMenu.doInteractMenu = function(player, context, worldobjects, test)
    if test and ISWorldObjectContextMenu.Test then return true end

    local object;
    local terminal;

    for i,v in ipairs(worldobjects) do
        -- It's a security terminal sprite
        if luautils.stringStarts(v:getSprite():getName(), "security_01_") then
            -- We browse the gates security terminals to see if it's registered
            for ind,term in ipairs(ISGateInteractionMenu.terminals) do
                if v:getSquare():getX() == term.x and
                   v:getSquare():getY() == term.y then
                    terminal = term;
                    print("[DT-INFO] ISGateInteractionMenu: found the Security Terminal for ".. tostring(terminal.gate));
                    break;
                end
            end
        end
        object = v;
    end

    if terminal and ISGateInteractionMenu.isOnInteractionZone(terminal, getPlayer()) then
        print("[DT-INFO] ISGateInteractionMenu: Interacting with ".. tostring(terminal.gate) .." !");
        context:addOption("Toggle gate", worldobjects, ISGate.toggle, getSpecificPlayer(player), terminal, object);
    end
end

-- Check if the player is in the terminal interaction zone
ISGateInteractionMenu.isOnInteractionZone = function(terminal, player)
    if terminal.interactionZone.x == player:getCurrentSquare():getX() and
       terminal.interactionZone.y == player:getCurrentSquare():getY() then
        return true;
    end

    return false;
end

Events.OnFillWorldObjectContextMenu.Add(ISGateInteractionMenu.doInteractMenu);