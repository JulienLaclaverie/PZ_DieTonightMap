-- ================================================
--           PZ Die Tonight Map & mod              
--           File created by Sylvain              
--           Date: 09/05/2017                        
--           Time: 19:11                        
-- ================================================

ISHorde = {

    spawnPoints = {
        -- north gate
        {
            x = 7936, y = 6376, x2 = 7939, y2 = 6378,
            noiseSource = {x = 7939, y = 6389, z = 0}
        },
        -- south gate
        {
            x = 7938, y = 6470, x2 = 7946, y2 = 6476,
            noiseSource = {x = 7943, y = 6457, z = 0}
        },
        -- west gate
        {
            x = 7911, y = 6421, x2 = 7913, y2 = 6416,
            noiseSource = {x = 7921, y = 6420, z = 0}
        },
        -- east gate
        {
            x = 7976, y = 6422, x2 = 7980, y2 = 6427,
            noiseSource = {x = 7965, y = 6424, z = 0}
        }
    },

    -- Days interval which will triggered a multiplicator changement
    daysInterval = {1,6,15,19,24},
    -- For each day interval, the given multiplicator
    daysMultiplicator = {
        day1 = 3,
        day6 = 4,
        day15 = 6,
        day19 = 8,
        day24 = 10
    },

    -- properties for the noise emitted when the horde is spawned
    noiseProps = {
        sound = "PZ_MaleBeingEaten_Death",
        pitchVar = 1,
        radius = 65,
        maxGain = 1.0,
        ignoreOutside = true
    }

};

-- Count the number of zombies to spawn for the current night
ISHorde.countZombiesToSpawn = function()
    return ISHorde.countDayFactor() * ISHorde.countPlayersInTown();
end

ISHorde.countDayFactor = function()
    local currentDay = getGameTime():getDaysSurvived();
    local interval = 1;
    local last = 1;
    for i,d in ipairs(ISHorde.daysInterval) do
        if currentDay >= last and currentDay < d then
            interval = last;
            break;
        end
        last = d;
    end
    -- print("CURRENTDAY= "..currentDay..", INTERVAL="..interval..", MULTIPLICATOR="..tostring(ISHorde.daysMultiplicator["day"..interval]))
    return currentDay + ISHorde.daysMultiplicator["day"..interval];
end

-- Count the number of players whose are in the town
ISHorde.countPlayersInTown = function()
    local playerCount = 1;
    local players = getOnlinePlayers();
    if players then
        for i=0,players:size()-1 do
            local p = players:get(i);
            -- print("[DT-INFO] ISHorde: player online --> name="..tostring(p:getUsername())..", isInTown="..tostring(ISHorde.isPlayerInTown(p)));
            if ISHorde.isPlayerInTown(p) then
                playerCount = playerCount + 1;
            end
            print("[DT-INFO] ISHorde: "..playerCount.."/"..(players.size() or 1).." player(s) are in the town");
        end
    -- else
    --     print("[DT-INFO] ISHorde: offline player --> name="..tostring(getPlayer():getUsername())..", isInTown="..tostring(ISHorde.isPlayerInTown(getPlayer())));
    end
    return playerCount;
end

-- Check if a player is in the town zone
ISHorde.isPlayerInTown = function(player)
    local pSquare = player:getCurrentSquare();
       -- north west check
    if pSquare:getX() >= 7915 and
       pSquare:getY() >= 6382 and
       -- south east check
       pSquare:getX() <= 7971 and
       pSquare:getY() <= 6465 then
        return true;
    end
    return false;
end

ISHorde.spawn = function(region, nbZombiesToSpawn)
    spawnHorde(region.x,region.y,region.x2,region.y2, 0, nbZombiesToSpawn);
    local squareNoiseSrc = getCell():getGridSquare(region.noiseSource.x, region.noiseSource.y, region.noiseSource.z);
    getSoundManager():PlayWorldSound(ISHorde.noiseProps.sound, squareNoiseSrc, ISHorde.noiseProps.pitchVar, ISHorde.noiseProps.radius, ISHorde.noiseProps.maxGain, ISHorde.noiseProps.ignoreOutside);
end

ISHorde.buildHorde = function()
    local nbZombiesToSpawn = ISHorde.countZombiesToSpawn();
    print("[DT-INFO] ISHorde: preparing "..nbZombiesToSpawn.." zombies to spawn in front of each gate")
    for i,region in ipairs(ISHorde.spawnPoints) do
        if getCell():getGridSquare(region.x,region.y, 0) and getCell():getGridSquare(region.x2,region.y2, 0) then
            print("[DT-INFO] ISHorde: spawn region n°"..i.." OK");
            ISHorde.spawn(region, nbZombiesToSpawn);
        else
            if getGameTime():getModData()["DT_Horde_"..i]  then
                getGameTime():getModData()["DT_Horde_"..i] = getGameTime():getModData()["DT_Horde_"..i] + nbZombiesToSpawn;
            else
                getGameTime():getModData()["DT_Horde_"..i] = nbZombiesToSpawn;
            end
            print("[DT-INFO] ISHorde: spawn region "..i.." doesn't exist, saving "..getGameTime():getModData()["DT_Horde_"..i].." zombies...");
        end
    end
end

ISHorde.Tick = function()
    if getPlayer() == nil then return end;

    -- print("[DT-INFO] ISHorde.Tick() --> hour=".. getGameTime():getHour() .. ", day="..getGameTime():getDaysSurvived());
    -- print("[DT-INFO] ISHorde: preparing "..ISHorde.countZombiesToSpawn().." zombies to spawn in front of each gate")

    -- FIXME: I saw 24 displayed one time... Just in case :B
    if getGameTime():getHour() == 0 or getGameTime():getHour() == 24 then
        print( "[DT-INFO] ISHorde: It's midnight ! Spawning horde...");
        ISHorde.buildHorde();
    end
end

ISHorde.checkHordeSpawn = function(sq)
    for i,region in ipairs(ISHorde.spawnPoints) do
        if sq:getX() >= region.x and
           sq:getX() <= region.x2 and
           sq:getY() >= region.y and
           sq:getY() <= region.y2 then
            if getGameTime():getModData()["DT_Horde_"..i] then
                print("[DT-INFO] ISHorde: horde spawn region "..i.." loaded. Spawning "..getGameTime():getModData()["DT_Horde_"..i].." zombies...");
                ISHorde.spawn(region, getGameTime():getModData()["DT_Horde_"..i]);
                getGameTime():getModData()["DT_Horde_"..i] = nil;
            end
        end
    end
end

Events.EveryHours.Add(ISHorde.Tick);
Events.LoadGridsquare.Add(ISHorde.checkHordeSpawn);