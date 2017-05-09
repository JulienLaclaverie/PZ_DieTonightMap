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
        1,  -- day 1
        3,  -- day 6
        6,  -- day 15
        8,  -- day 19
        10  -- day 24
    }

};

-- Count the number of zombies to spawn for the current night
ISHorde.countZombiesToSpawn = function()
    -- Nb de Zombies qui attaquent = X * Nb de joueurs (minimum 1)
    local zombyForThisNightDayMultiplicator = 2;
    local nbZombiesToSpawn = 1 * ISHorde.countPlayersInTown();
end

-- Count the number of players whose are in the town
ISHorde.countPlayersInTown = function()
    return 1;
end

ISHorde.Tick = function()
    if getPlayer() == nil then return end;

    local gameTime = GameTime:getInstance();

    if gameTime:getTimeOfDay() == 23.9 then
        print( "[DT-INFO] ISHorde.Tick() --> ".. gameTime:getTimeOfDay() );
    end
end

Events.OnTick.Add(ISHorde.Tick)
