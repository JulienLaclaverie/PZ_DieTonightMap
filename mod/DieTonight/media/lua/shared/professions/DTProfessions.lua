DTProfessions = {}

function DTProfessions.DoProfessions()

    print( "[DT-INFO] Factory reset...");
    ProfessionFactory.Reset();

    local resident = ProfessionFactory.addProfession("resident", "Resident", "basic_suit", 8);

    local scavenger = ProfessionFactory.addProfession("scavenger", "Scavenger", "shovel", -4);
    scavenger:addXPBoost(Perks.PlantScavenging, 3);

    local scout = ProfessionFactory.addProfession("scout", "Scout", "vest_on", -6);
    scout:addXPBoost(Perks.Nimble, 2)
    scout:addXPBoost(Perks.Sneak, 2)
    scout:addXPBoost(Perks.Lightfoot, 2)
    scout:addFreeTrait("NightOwl");

    local survivalist = ProfessionFactory.addProfession("survivalist", "Survivalist", "suvivalist", -5);
    survivalist:addXPBoost(Perks.Trapping, 4);
    survivalist:addXPBoost(Perks.PlantScavenging, 1);
    survivalist:getFreeRecipes():add("Make Stick Trap");
    survivalist:getFreeRecipes():add("Make Snare Trap");
    survivalist:getFreeRecipes():add("Make Wooden Cage Trap");
    survivalist:getFreeRecipes():add("Make Trap Box");
    survivalist:getFreeRecipes():add("Make Cage Trap");

    local technician = ProfessionFactory.addProfession("technician", "Technician", "keymole", -5);
    technician:addXPBoost(Perks.Electricity, 3)
    technician:getFreeRecipes():add("Generator");
    technician:getFreeRecipes():add("Make Remote Controller V1");
    technician:getFreeRecipes():add("Make Remote Controller V2");
    technician:getFreeRecipes():add("Make Remote Controller V3");
    technician:getFreeRecipes():add("Make Remote Trigger");
    technician:getFreeRecipes():add("Make Timer");
    technician:getFreeRecipes():add("Craft Makeshift Radio");
    technician:getFreeRecipes():add("Craft Makeshift HAM Radio");
    technician:getFreeRecipes():add("Craft Makeshift Walkie Talkie");
    technician:getFreeRecipes():add("Make Aerosol bomb");
    technician:getFreeRecipes():add("Make Flame bomb");
    technician:getFreeRecipes():add("Make Pipe bomb");
    technician:getFreeRecipes():add("Make Noise generator");
    technician:getFreeRecipes():add("Make Smoke Bomb");

    local metalworker = ProfessionFactory.addProfession("metalworker", "Metal worker", "metal", -6);
    metalworker:addXPBoost(Perks.MetalWelding, 3);
    metalworker:getFreeRecipes():add("Make Metal Walls");
    metalworker:getFreeRecipes():add("Make Metal Fences");
    metalworker:getFreeRecipes():add("Make Metal Containers");
    metalworker:getFreeRecipes():add("Make Metal Sheet");
    metalworker:getFreeRecipes():add("Make Small Metal Sheet");
    metalworker:getFreeRecipes():add("Make Metal Roof");

    local carpenter = ProfessionFactory.addProfession("carpenter", "Carpenter", "refine", -5);
    carpenter:addXPBoost(Perks.Woodwork, 3);
    carpenter:addXPBoost(Perks.BluntMaintenance, 3);

    local guardian = ProfessionFactory.addProfession("guardian", "Guardian", "shield", -6);
    guardian:addFreeTrait("Desensitized");
    guardian:addXPBoost(Perks.Strength, 1);
    guardian:addXPBoost(Perks.Fitness, 1);

    local cook = ProfessionFactory.addProfession("cook", "Cook", "tasty_food", -4);
    cook:addXPBoost(Perks.Cooking, 4)
    cook:addXPBoost(Perks.BladeMaintenance, 1)
    cook:getFreeRecipes():add("Make Cake Batter");
    cook:getFreeRecipes():add("Make Pie Dough");
    cook:getFreeRecipes():add("Make Bread Dough");
    cook:addFreeTrait("Cook2");

    local gardener = ProfessionFactory.addProfession("gardener", "Gardener", "vegetable", -3);
    gardener:addXPBoost(Perks.Farming, 4)
    gardener:getFreeRecipes():add("Make Mildew Cure");
    gardener:getFreeRecipes():add("Make Flies Cure");

    local guide = ProfessionFactory.addProfession("guide", "Guide to the World Beyond", "compass", -3);
    guide:addFreeTrait("Nutritionist2");
    guide:addXPBoost(Perks.Fitness, 1);
    guide:addXPBoost(Perks.Sprinting, 1);

    local dealer = ProfessionFactory.addProfession("dealer", "Drug dealer", "pills", -3);
    dealer:addXPBoost(Perks.Doctor, 4)

    local profList = ProfessionFactory.getProfessions()
    for i=1,profList:size() do
        local prof = profList:get(i-1)
        DTProfessions.SetProfessionDescription(prof)
    end

end

function DTProfessions.SetProfessionDescription(prof)
    local desc = getTextOrNull("UI_DT_profdesc_" .. prof:getType()) or ""
    local boost = transformIntoKahluaTable(prof:getXPBoostMap())
    local infoList = {}
    for perk,level in pairs(boost) do
        local perkName = PerkFactory.getPerkName(perk)
        if perk == Perks.Axe then
            perkName = getText("IGUI_perks_Blade") .. " " .. perkName
        elseif perk == Perks.Blunt then
            perkName = getText("IGUI_perks_Blunt") .. " " .. perkName
        elseif perk == Perks.BluntMaintenance or perk == Perks.BluntGuard then
            perkName = getText("IGUI_perks_Blunt") .. " " .. perkName
        elseif perk == Perks.BladeMaintenance or perk == Perks.BladeGuard then
            perkName = getText("IGUI_perks_Blade") .. " " .. perkName
        end
        -- "+1 Cooking" etc
        local levelStr = tostring(level:intValue())
        if level:intValue() > 0 then levelStr = "+" .. levelStr end
        table.insert(infoList, { perkName = perkName, levelStr = levelStr })
    end
    table.sort(infoList, function(a,b) return not string.sort(a.perkName, b.perkName) end)
    for _,info in ipairs(infoList) do
        if desc ~= "" then desc = desc .. "\n" end
        desc = desc .. info.levelStr .. " " .. info.perkName
    end
    local traits = prof:getFreeTraits()
    for j=1,traits:size() do
        if desc ~= "" then desc = desc .. "\n" end
        local traitName = traits:get(j-1)
        local trait = TraitFactory.getTrait(traitName)
        desc = desc .. trait:getLabel()
    end
    prof:setDescription(desc)
end



Events.OnGameBoot.Add(DTProfessions.DoProfessions);