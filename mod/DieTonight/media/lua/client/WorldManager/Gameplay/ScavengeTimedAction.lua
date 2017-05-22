-- random a plant/insect, more chance in deep forest

function ISScavengeAction:scavenge()
    self.character:getStats():setEndurance(self.character:getStats():getEndurance() - 0.004)
    local zone = self:getScavengeZone();
    local scavengeZoneNumber = ZombRand(5,15) + self.scavengeZoneIncrease;
    if scavengeZoneNumber <= 0 then
        scavengeZoneNumber = 1;
    end
    if zone then
        local plantLeft = tonumber(zone:getName());
        if getGametimeTimestamp() - zone:getLastActionTimestamp() > 86400 then
            --            print("refill zone");
            zone:setName(1 .. "");
            zone:setOriginalName(1 .. "");
        elseif plantLeft == 0 then
            return;
        end
    end

    local item = self:getPlant();
    if item ~= nil then
        self:addOrDropItems(item.type, item.count);
        self.character:getXp():AddXP(Perks.PlantScavenging, 2);
    elseif ZombRand(9) == 0 then -- give some xp even for a fail
        self.character:getXp():AddXP(Perks.PlantScavenging, 1);
    end

    local goods = self:getForestGoods();
    if goods ~= nil then
        self:addOrDropItems(goods.type, goods.count);
        self.character:getXp():AddXP(Perks.PlantScavenging, 2);
    elseif ZombRand(9) == 0 then -- give some xp even for a fail
        self.character:getXp():AddXP(Perks.PlantScavenging, 1);
    end

    local medicinal = self:getMedicinalHerbs();
    if medicinal ~= nil then
        self:addOrDropItems(medicinal.type, medicinal.count);
        self.character:getXp():AddXP(Perks.PlantScavenging, 2);
    elseif ZombRand(9) == 0 then -- give some xp even for a fail
        self.character:getXp():AddXP(Perks.PlantScavenging, 1);
    end

    if item or goods or medicinal then -- got something
        if not zone then -- register the new zone
            --            print("register new zone");
            zone = getWorld():registerZone(scavengeZoneNumber .. "", "PlantScavenge",self.x - 20, self.y - 20, 0, 40, 40);
            zone:setLastActionTimestamp(getGametimeTimestamp());
            zone:setName(2 .. "");
            zone:setOriginalName(3 .. "");
        else -- update the plant available
            local plantLeft = tonumber(zone:getName());
            zone:setName(plantLeft - 1 .. "");
            zone:setLastActionTimestamp(getGametimeTimestamp());
        end
        if isClient() then
            zone:sendToServer()
        end
        return true;
    end
    return false;
end

function ISScavengeAction:getPlant()

    local level = self.character:getPerkLevel(Perks.PlantScavenging);
    local baseChance = 3;
    if self.zone:getType() == "DeepForest" then
        baseChance = 7;
    end
    baseChance = baseChance + (4 * level);
    baseChance = baseChance + self.bonusFindingChance;

    -- harder to find food during early months
    if (getGameTime():getMonth() + 1) == 3 or (getGameTime():getMonth() + 1) == 4 then
        baseChance = baseChance - 2;
    end

    if baseChance > (25 + self.bonusFindingChance) then
        baseChance = 25 + self.bonusFindingChance;
    end

    local possibilities = {};
    -- hydrocraft compatibility
    for i,v in ipairs(scavenges.plants) do
        if v.skill <= level then
            table.insert(possibilities, v);
        end
    end
    -- check for all the scavenging possibilities
    if self.options["Insects"] then
        for i,v in ipairs(scavenges.insects) do
            if v.skill <= level then
                table.insert(possibilities, v);
            end
        end
    end
    if self.options["Mushrooms"] then
        for i,v in ipairs(scavenges.mushrooms) do
            if v.skill <= level then
                table.insert(possibilities, v);
            end
        end
    end
    if self.options["Berries"] then
        for i,v in ipairs(scavenges.berries) do
            if v.skill <= level then
                table.insert(possibilities, v);
            end
        end
    end

    --    baseChance = 100;

    -- you now get more than 1 plants
    if #possibilities > 0 and ZombRand(100) < baseChance then
        local result = {};
        local item = possibilities[ZombRand(#possibilities) + 1];
        local count = ZombRand(item.minCount, item.maxCount) + (level / 2);
        if count > item.maxCount then
            count = item.maxCount;
        end
        result.type = item.type;
        result.count = count;
        return result;
    end

    return nil;
end

function ISScavengeAction:getMedicinalHerbs()
    if not self.options["MedicinalPlants"] then
        return nil;
    end

    local level = self.character:getPerkLevel(Perks.PlantScavenging);
    local baseChance = 3;
    if self.zone:getType() == "DeepForest" then
        baseChance = 7;
    end
    baseChance = baseChance + (4 * level);
    baseChance = baseChance + self.bonusFindingChance;

    if baseChance > (25 + self.bonusFindingChance) then
        baseChance = 25 + self.bonusFindingChance;
    end

    local possibilities = {};
    -- check for all the scavenging possibilities
    for i,v in ipairs(scavenges.medicinalPlants) do
        if v.skill <= level then
            table.insert(possibilities, v);
        end
    end

    --    baseChance = 100;

    -- you now get more than 1 plants
    if #possibilities > 0 and ZombRand(100) < baseChance then
        local result = {};
        local item = possibilities[ZombRand(#possibilities) + 1];
        local count = ZombRand(item.minCount, item.maxCount) + (level / 2);
        if count > item.maxCount then
            count = item.maxCount;
        end
        result.type = item.type;
        result.count = count;
        return result;
    end

    return nil;
end