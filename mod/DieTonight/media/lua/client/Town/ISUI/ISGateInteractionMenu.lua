ISGateInteractionMenu = {};

-- terminal fixes requirements (inclusives)
TerminalHealthInfos = {
    health = 100,

    repairRequirements = {
        electricWires = 5,
        electricScraps = 5,
        electricityPerkLevel = 1
    }
};

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
        if v and v:getSprite():getName() then
            if luautils.stringStarts(v:getSprite():getName(), "security_01_") then
                -- We browse the gates security terminals to see if it's registered
                for ind,term in ipairs(ISGateInteractionMenu.terminals) do
                    if v:getSquare():getX() == term.x and
                       v:getSquare():getY() == term.y then
                        terminal = term;
                        ISGate.currentSquareForModData = v;
                        if not ISGate.getHealth() then
                            ISGate.setHealth(TerminalHealthInfos.health);
                        end
                        print("[DT-INFO] ISGateInteractionMenu: found the Security Terminal for ".. tostring(terminal.gate));
                        break;
                    end
                end
            end
        end
        object = v;
    end

    local gateHealth = ISGate.getHealth();

    if terminal and object then
        if ISGateInteractionMenu.isOnInteractionZone(terminal, getPlayer()) then
            print("[DT-INFO] ISGateInteractionMenu: Interacting with ".. tostring(terminal.gate) .." !");
            local toggleOption = context:addOption("Toggle gate", worldobjects, ISGate.toggle, getSpecificPlayer(player), terminal, object);
            local tooltip;

            -- If the gate has no more health, we add the repair option to the menu
            if gateHealth <= 0 then
                object:getSquare():playSound("breakdoor", true);

                toggleOption.notAvailable = true;
                tooltip = ISWorldObjectContextMenu.addToolTip();
                tooltip.description = "The gate mechanism is broken, you need to repair it to be able to use it !";
                toggleOption.toolTip = tooltip;

                local repairOption = context:addOption("Repair terminal", worldobjects, ISGate.repairTerminal, getSpecificPlayer(player), object);
                tooltip = ISWorldObjectContextMenu.addToolTip();
                tooltip:setName("Requirements");
                tooltip.description = "1 level in electronics".."\n".."5 electronic scraps".."\n".."5 electronic wires";
                if not ISGateInteractionMenu.canPlayerRepairTerminal(getSpecificPlayer(player)) then
                    repairOption.notAvailable = true;
                end
                repairOption.toolTip = tooltip;
            elseif ISGate.isToggled() then
                toggleOption.notAvailable = true;
                tooltip = ISWorldObjectContextMenu.addToolTip();
                tooltip.description = "The gate mechanism is busy...";
                toggleOption.toolTip = tooltip;
            end

            -- If the player is a technician, we display the terminal condition in a tooltip
            if getSpecificPlayer(player):getDescriptor():getProfession() == "technician" then
                local condition = 0;
                if gateHealth > 0 then
                    condition = ((gateHealth*100)/TerminalHealthInfos.health);
                end
                local tooltipDesc = "Condition - "..condition.."%";

                if not tooltip then
                    tooltip = ISWorldObjectContextMenu.addToolTip();
                    tooltip.description = tooltipDesc;
                else
                    tooltip.description = tooltip.description .. "\n\n" .. tooltipDesc;
                end
                toggleOption.toolTip = tooltip;
            end

        end
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

ISGateInteractionMenu.canPlayerRepairTerminal = function(specificPlayer)
    local playerInv = specificPlayer:getInventory();
    local electricityPerkLevel = specificPlayer:getPerkLevel(Perks.Electricity);
    local itemsCount = {
        electricWires = 0,
        electricScraps = 0
    };

    -- On compte le nombre le nombre d'items requis présent dans l'inventaire
    for i = 0, playerInv:getItems():size() - 1 do
        local vItem = playerInv:getItems():get(i);
        if vItem:getName() == "Electric Wire" then
            itemsCount.electricWires = itemsCount.electricWires + 1;
        end
        if vItem:getName() == "Electronics Scrap" then
            itemsCount.electricScraps = itemsCount.electricScraps + 1;
        end
    end

    if itemsCount.electricWires >= TerminalHealthInfos.repairRequirements.electricWires and
       itemsCount.electricScraps >= TerminalHealthInfos.repairRequirements.electricScraps and
       playerInv:contains("Screwdriver") and
       electricityPerkLevel >= TerminalHealthInfos.repairRequirements.electricityPerkLevel then
        return true;
    end

    return false;
end

Events.OnFillWorldObjectContextMenu.Add(ISGateInteractionMenu.doInteractMenu);