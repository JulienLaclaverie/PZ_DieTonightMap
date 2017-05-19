
FixContextMetalDrum = {}

-- Remove the remove option of the metal drum context menu
FixContextMetalDrum.removeRemoveOption= function(player, context, worldobjects, test)

    local playerObj = getSpecificPlayer(player);
    local playerInv = playerObj:getInventory();
    local lightDrumFromPetrol = nil;
    local lightDrumFromKindle = nil;
    local lightDrumFromLiterature = nil;
    local metalDrum;
    local sq;

    local lightFireList = {}
    local lighter = nil
    local matches = nil
    local petrol = nil
    local percedWood = nil
    local branch = nil
    local stick = nil
    local lightFireList = {}
    local lightFromPetrol = nil;
    local lightFromKindle = nil
    local lightFromLiterature = nil
    local lightDrumFromPetrol = nil;
    local lightDrumFromKindle = nil
    local lightDrumFromLiterature = nil
    local metalFence;
    local bellows;
    local coal = nil;
    local containers = ISInventoryPaneContextMenu.getContainers(playerObj)
    for i=1,containers:size() do
        local container = containers:get(i-1)
        for j=1,container:getItems():size() do
            local item = container:getItems():get(j-1)
            local type = item:getType()
            if type == "Lighter" then
                lighter = item
            elseif type == "Matches" then
                matches = item
            elseif type == "PetrolCan" then
                petrol = item
            elseif type == "PercedWood" then
                percedWood = item
            elseif type == "TreeBranch" then
                branch = item
            elseif type == "WoodenStick" then
                stick = item
            elseif type == "MetalFence" then
                metalFence = item
            elseif type == "Coal" or type == "Charcoal" then
                coal = item
            elseif type == "Bellows" then
                bellows = item
            end

            if campingLightFireType[type] then
                if campingLightFireType[type] > 0 then
                    table.insert(lightFireList, item)
                end
            elseif campingLightFireCategory[item:getCategory()] then
                table.insert(lightFireList, item)
            end
        end
    end

    for i,v in ipairs(worldobjects) do
        sq = v:getSquare();
        if instanceof(v, "BSFurnace") then
            furnace = v;
        end
        if v:getName() == "MetalDrum" then
            metalDrum = v;
        end

        if (lighter or matches) and petrol and metalDrum and metalDrum:getModData()["haveLogs"] and not metalDrum:getModData()["isLit"] and not metalDrum:getModData()["haveCharcoal"] then
            lightDrumFromPetrol = metalDrum;
        end

        if percedWood and (stick or branch) and metalDrum and metalDrum:getModData()["haveLogs"] and not metalDrum:getModData()["isLit"] and not metalDrum:getModData()["haveCharcoal"] and playerObj:getStats():getEndurance() > 0 then
            lightDrumFromKindle = metalDrum
        end

        if (lighter or matches) and metalDrum and metalDrum:getModData()["haveLogs"] and not metalDrum:getModData()["isLit"] and not metalDrum:getModData()["haveCharcoal"] then
            lightDrumFromLiterature = metalDrum
        end
    end

    if metalDrum and playerObj:DistToSquared(metalDrum:getX() + 0.5, metalDrum:getY() + 0.5) < 2 * 2 then

        for i=0, context.numOptions-2 do
            context:removeLastOption();
        end

        local option = context:addOption(getText("ContextMenu_Metal_Drum"), worldobjects, nil)
        local subMenuDrum = ISContextMenu:getNew(context);
        context:addSubMenu(option, subMenuDrum);
        local tooltip = ISWorldObjectContextMenu.addToolTip()
        tooltip:setName(getText("ContextMenu_Metal_Drum"))
        if metalDrum:getWaterAmount() > 0 then
            tooltip.description = getText("Water Percent ", round((metalDrum:getWaterAmount() / metalDrum:getModData()["waterMax"]) * 100))
        elseif metalDrum:getModData()["haveLogs"] and metalDrum:getModData()["isLit"] then
            local luaDrum = ISMetalDrum.getLuaObject(metalDrum);
            if luaDrum then
                if not luaDrum.charcoalTick then
                    tooltip.description = "Charcoal Progression 0%";
                else
                    tooltip.description = "Charcoal Progression " .. (round((luaDrum.charcoalTick / 12) * 100)) .. "%";
                end
            end
        end
        if metalDrum:getWaterAmount() > 0 or (metalDrum:getModData()["haveLogs"] and metalDrum:getModData()["isLit"]) then
            option.toolTip = tooltip
        end
        if metalDrum:getWaterAmount() > 0 then
            subMenuDrum:addOption("Empty", worldobjects, ISBlacksmithMenu.onEmptyDrum, metalDrum, playerObj);
        else
            if not metalDrum:getModData()["haveLogs"] and not metalDrum:getModData()["haveCharcoal"] and not metalDrum:getModData()["isLit"] then
                local addWoodOption = subMenuDrum:addOption("Add Logs", worldobjects, FixContextMetalDrum.onAddLogs, metalDrum, playerObj);
                local tooltip = ISWorldObjectContextMenu.addToolTip()
                tooltip:setName("Add Logs")
                tooltip.description = "Add 2 logs to do charcoal, once done, lit up the barrel with a lighter and wait";
                addWoodOption.toolTip = tooltip
                if playerObj:getInventory():getItemCount("Base.Log") < 2 then
                   addWoodOption.notAvailable = true;
                end
            else
                if not metalDrum:getModData()["isLit"] and not metalDrum:getModData()["haveCharcoal"] then
                    subMenuDrum:addOption("Remove Logs", worldobjects, FixContextMetalDrum.onRemoveLogs, metalDrum, playerObj);
                end
            end
            if metalDrum:getModData()["haveCharcoal"] then
                subMenuDrum:addOption(getText("ContextMenu_RemoveCharcoal"), worldobjects, FixContextMetalDrum.onRemoveCharcoal, metalDrum, playerObj);
            end
        end
    end

    if lightDrumFromPetrol or lightDrumFromKindle or (lightDrumFromLiterature and #lightFireList > 0) then
        local lightOption = context:addOption(getText("ContextMenu_LitDrum"), worldobjects, nil);
        local subMenuLight = ISContextMenu:getNew(context);
        context:addSubMenu(lightOption, subMenuLight);
        if lightDrumFromPetrol then
            if lighter then
                local LitOption = subMenuLight:addOption(petrol:getName()..' + '..lighter:getName(), worldobjects, FixContextMetalDrum.onLightDrumFromPetrol, player, lighter, petrol, lightDrumFromPetrol)
                local tooltip = ISWorldObjectContextMenu.addToolTip()
                tooltip:setName(getText("ContextMenu_LitDrum"))
                tooltip.description = getText("Tooltip_Charcoal");
                LitOption.toolTip = tooltip
            end
            if matches then
                local LitOption = subMenuLight:addOption(petrol:getName()..' + '..matches:getName(), worldobjects, FixContextMetalDrum.onLightDrumFromPetrol, player, matches, petrol, lightDrumFromPetrol)
                local tooltip = ISWorldObjectContextMenu.addToolTip()
                tooltip:setName(getText("ContextMenu_LitDrum"))
                tooltip.description = getText("Tooltip_Charcoal");
                LitOption.toolTip = tooltip
            end
        end
    end
    
end

FixContextMetalDrum.onAddLogs = function(worldobjects, metalDrum, player)
    if luautils.walkAdj(player, metalDrum:getSquare()) then
        ISTimedActionQueue.add(ISAddLogsInDrumTimed:new(player, metalDrum, true))
    end
end

FixContextMetalDrum.onRemoveLogs = function(worldobjects, metalDrum, player)
    if luautils.walkAdj(player, metalDrum:getSquare()) then
        ISTimedActionQueue.add(ISAddLogsInDrumTimed:new(player, metalDrum, false))
    end
end

FixContextMetalDrum.onRemoveCharcoal = function(worldobjects, metalDrum, player)
    if luautils.walkAdj(player, metalDrum:getSquare()) then
        ISTimedActionQueue.add(ISRemoveCharcoalTimed:new(player, metalDrum))
    end
end

FixContextMetalDrum.onLightDrumFromPetrol = function(worldobjects, player, lighter, petrol, metalDrum)
    local playerObj = getSpecificPlayer(player)
    ISCampingMenu.toPlayerInventory(playerObj, lighter)
    ISCampingMenu.toPlayerInventory(playerObj, petrol)
    if luautils.walkAdj(playerObj, metalDrum:getSquare(), true) then
        ISTimedActionQueue.add(ISDrumLightFromPetrol:new(playerObj, metalDrum, lighter, petrol, 20));
    end
end

Events.OnFillWorldObjectContextMenu.Add(FixContextMetalDrum.removeRemoveOption);