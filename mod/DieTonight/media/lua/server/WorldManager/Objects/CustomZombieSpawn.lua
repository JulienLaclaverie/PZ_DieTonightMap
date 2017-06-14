--
-- Properties
--
 
CustomZombieSpawn = {

    oneZombiePlaceholder = "location_community_park_01_17",
    fiveZombiesPlaceholder = "location_community_park_01_19",
    tenZombiesPlaceholder = "location_community_park_01_20",
    twentyZombiesPlaceholder = "location_community_park_01_21"

};

--
-- Methods
--

CustomZombieSpawn.spawnObjects = function(sq)

    for i=0,sq:getObjects():size()-1 do
        if sq:getObjects() then
            local tileObject = sq:getObjects():get(i);

            if tileObject then

                local coords = { x = sq:getX(), y = sq:getY(), z = sq:getZ() };
                local zombiesToSpawn;

                if tileObject:getSprite():getName() == CustomZombieSpawn.oneZombiePlaceholder then
                    zombiesToSpawn = 1;
                end

                if tileObject:getSprite():getName() == CustomZombieSpawn.fiveZombiesPlaceholder then
                    zombiesToSpawn = 5;
                end

                if tileObject:getSprite():getName() == CustomZombieSpawn.tenZombiesPlaceholder then
                    zombiesToSpawn = 10;
                end

                if tileObject:getSprite():getName() == CustomZombieSpawn.twentyZombiesPlaceholder then
                    zombiesToSpawn = 20;
                end

                if zombiesToSpawn and zombiesToSpawn > 0 then
                    spawnHorde(coords.x, coords.y, coords.x, coords.y, coords.z, zombiesToSpawn);
                    -- Remove the placeholder
                    sq:transmitRemoveItemFromSquare(tileObject);
                    sq:RemoveTileObject(tileObject);
                end

            end
        end
    end

end

