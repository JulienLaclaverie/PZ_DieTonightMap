-- Override ISWorldObjectContextMenu.doScavengeOptions to force the player to have a shovel to be able to forage the desert

ISWorldObjectContextMenu.doScavengeOptions = function(context, player, scavengeZone, clickedSquare)

    print("[DT-INFO] ISWorldObjectContextMenu.doScavengeOptions is properly overitten : ");

    local playerObj = getSpecificPlayer(player)
    local text = "";
    local zone = ISScavengeAction.getScavengingZone(clickedSquare:getX(), clickedSquare:getY());

    if not zone then
        text = "(100" .. getText("ContextMenu_FullPercent") .. ")"
    else
        local plantLeft = tonumber(zone:getName());
        local scavengeZoneIncrease = 0;
        if SandboxVars.NatureAbundance == 1 then -- very poor
            scavengeZoneIncrease = -5;
        elseif SandboxVars.NatureAbundance == 2 then -- poor
            scavengeZoneIncrease = -2;
        elseif SandboxVars.NatureAbundance == 4 then -- abundant
            scavengeZoneIncrease = 2;
        elseif SandboxVars.NatureAbundance == 5 then -- very abundant
            scavengeZoneIncrease = 5;
        end
        local scavengeZoneNumber = ZombRand(5,15) + scavengeZoneIncrease;
        if scavengeZoneNumber <= 0 then
            scavengeZoneNumber = 1;
        end
        if getGametimeTimestamp() - zone:getLastActionTimestamp() > 50000 then
            zone:setName(scavengeZoneNumber .. "");
            zone:setOriginalName(scavengeZoneNumber .. "");
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
    end

end