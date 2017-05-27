-- Override ISWorldObjectContextMenu.doScavengeOptions to force the player
-- to have a shovel to be able to forage the desert

ISWorldObjectContextMenu.doScavengeOptions = function(context, player, scavengeZone, clickedSquare)

    local playerObj = getSpecificPlayer(player)
    local text = "";
    local zone = ISScavengeAction.getScavengingZone(clickedSquare:getX(), clickedSquare:getY());

    if not zone then
        text = "(100" .. getText("ContextMenu_FullPercent") .. ")"
    else
        local plantLeft = tonumber(zone:getName());
        local scavengeZoneNumber = ZombRand(0,15)

        if getGametimeTimestamp() - zone:getLastActionTimestamp() > 86400 then

            zone:setName(1 .. "");
            zone:setOriginalName(1 .. "");

        end

        if zone:getName() == "0" then
            text = "(" .. getText("ContextMenu_Empty") .. ")";
        else
            text = "(" .. math.floor((tonumber(zone:getName()) / tonumber(zone:getOriginalName())) * 100) .. getText("ContextMenu_FullPercent") .. ")";
        end
    end

    local scavengeOption = context:addOption("Scavenge " .. text, nil, ISWorldObjectContextMenu.onScavenge, getSpecificPlayer(player), scavengeZone, clickedSquare);

    -- In the desert, you can't forage without a shovel
    if (playerObj:getInventory():contains("HandShovel") == false) and (playerObj:getInventory():contains("Shovel") == false) then  
        scavengeOption.notAvailable = true;
        local tooltip = ISWorldObjectContextMenu.addToolTip();
        tooltip:setName("Scavenge the desert");
        tooltip.description = "You need a shovel or a trovel to scavenge";
        scavengeOption.toolTip = tooltip;
    elseif (playerObj:getInventory():contains("Shovel") == true) and (playerObj:getInventory():contains("HandShovel") == false) then
        local shovel = playerObj:getInventory():FindAndReturn("Shovel");
        if shovel:getCondition() <= 0 or shovel:isBroken() then
            scavengeOption.notAvailable = true;
            local tooltip = ISWorldObjectContextMenu.addToolTip();
            tooltip:setName("Scavenge the desert");
            tooltip.description = "Your shovel is broken, find a trovel or a new shovel to scavenge";
            scavengeOption.toolTip = tooltip;
        end
    end

end