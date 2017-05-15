-- ================================================
--           PZ Die Tonight Map & mod              
--           File created by Sylvain              
--           Date: 09/05/2017                        
--           Time: 19:11                        
-- ================================================

ISHorde = {

    spawnPoints = {
        -- north gate
        {x = 0, y = 0},
        -- south gate
        {x = 0, y = 0},
        -- west gate
        {x = 0, y = 0},
        -- east gate
        {x = 0, y = 0}
    },

    daysInterval = {1,6,15,19,24},

    daysMultiplicator = {
        day1 = 1,
        day6 = 3,
        day15 = 6,
        day19 = 8,
        day24 = 10
    }

};

-- Count the number of zombies to spawn for the current night
ISHorde.countZombiesToSpawn = function()
    -- Nb de Zombies qui attaquent = X * Nb de joueurs (minimum 1)
    local nbZombiesToSpawn = ISHorde.countDayFactor() * ISHorde.countPlayersInTown();
    print("[DT-INFO] ISHorde: nb zombie to spawn --> "..nbZombiesToSpawn)
end

ISHorde.countDayFactor = function()
    local currentDay = getGameTime():getDay();
    local interval;
    local last = 0;
    for i,d in ipairs(ISHorde.daysInterval) do
        if currentDay >= last and currentDay < d then
            interval = last;
            break;
        end
        last = d;
    end
    return currentDay + ISHorde.daysMultiplicator["day"..interval];
end

-- Count the number of players whose are in the town
ISHorde.countPlayersInTown = function()
    local players = getOnlinePlayers();
    if players then
        for i=0,players:size()-1 do
            local p = players:get(i);
            print("[DT-INFO] ISHorde: player --> "..tostring(p)..", position --> "..tostring(p:getCurrentSquare():getX())..","..tostring(p:getCurrentSquare():getY()))
        end
    end
    return 1;
end

ISHorde.spawn = function(currentDay)
    -- spawnHorde(regionSpawn.x,regionSpawn.y,regionSpawn.x2,regionSpawn.y2,regionSpawnZ, ISHorde.countZombiesToSpawn(currentDay));
    -- addSound(getPlayer(), 13986, 5833, getPlayer():getZ(), 600, 600);
end

ISHorde.Tick = function()
    if getPlayer() == nil then return end;

    -- print( "[DT-INFO] ISHorde.Tick() --> hour=".. getGameTime():getHour() .. ", day="..getGameTime():getDay());
    -- ISHorde.countZombiesToSpawn();
    if getGameTime():getHour() == 24 then
        print( "[DT-INFO] ISHorde: It's midnight !");
        -- ISHorde.spawn();
    end
end

Events.EveryHours.Add(ISHorde.Tick);
-- Events.EveryTenMinutes.Add(ISHorde.Tick);