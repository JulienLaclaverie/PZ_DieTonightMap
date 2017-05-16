-- ================================================
--           PZ Die Tonight Map & mod              
--           File created by Sylvain              
--           Date: 09/05/2017                        
--           Time: 19:11                        
-- ================================================

ISHorde = {

    spawnPoints = {
        -- north gate
        {x = 7934, y = 6376, x2 = 7938, y2 = 6372},
        -- south gate
        {x = 7938, y = 6470, x2 = 7946, y2 = 6476},
        -- west gate
        {x = 7908, y = 6421, x2 = 7905, y2 = 6415},
        -- east gate
        {x = 7976, y = 6422, x2 = 7980, y2 = 6427 }
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
    return nbZombiesToSpawn;
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
            print("[DT-INFO] ISHorde: player online --> name="..tostring(p:getSurname())..", isInTown="..tostring(ISHorde.isPlayerInTown(getPlayer())));
            if ISHorde.isPlayerInTown(p) then
                playerCount = playerCount + 1;
            end
        end
    else
        print("[DT-INFO] ISHorde: offline player --> name="..tostring(getPlayer():getSurname())..", isInTown="..tostring(ISHorde.isPlayerInTown(getPlayer())));
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

ISHorde.spawn = function()
    local nbZombiesToSpawn = ISHorde.countPlayersInTown();
    for i,region in ipairs(ISHorde.spawnPoints) do
        spawnHorde(region.x,region.y,region.x2,region.y2, 0, ISHorde.countZombiesToSpawn());
        -- addSound(getPlayer(), 13986, 5833, getPlayer():getZ(), 600, 600);
        -- addSound(self:getTrapObject(), square:getX(),square:getY(),square:getZ(), 40, 10);
    end
end

ISHorde.Tick = function()
    if getPlayer() == nil then return end;

    --print( "[DT-INFO] ISHorde.Tick() --> hour=".. getGameTime():getHour() .. ", day="..getGameTime():getDaysSurvived());

    -- FIXME: I saw 24 displayed one time...
    if getGameTime():getHour() == 0 or getGameTime():getHour() == 24 then
        print( "[DT-INFO] ISHorde: It's midnight !");
        -- ISHorde.spawn();
        ISHorde.countZombiesToSpawn();
    end
end

Events.EveryHours.Add(ISHorde.Tick);
-- Events.EveryTenMinutes.Add(ISHorde.Tick);