--
-- Properties
--

ISSmashWindows = {

    city = {

        -- x coordinates
        x = {
            start = 7915,
            finish = 7971
        },

        -- y coordinates
        y = {
            start = 6381,
            finish = 6564
        },

        -- z coordinates
        z = {
            start = 0,
            finish = 3
        },

    }

};

--
-- Methods
--

-- Smash all windows within range
ISSmashWindows.smashCity = function(player)

    print("[DT-INFO] Smashing windows...");

    -- Check all the city squares to find windows

    for z = ISSmashWindows.city.z.start, ISSmashWindows.city.z.finish do
	    for y = ISSmashWindows.city.y.start, ISSmashWindows.city.y.finish do
		    for x = ISSmashWindows.city.x.start, ISSmashWindows.city.x.finish do

                local sq = getCell():getGridSquare(x, y, z);

                if sq then

                    for i=0,sq:getObjects():size()-1 do

                        -- Searching for windows
                        -- print("[DT-INFO] Searching for windows...");
                        local tileObject = sq:getObjects():get(i);
                        if (luautils.stringStarts(tileObject:getSprite():getName(), "fixtures_windows_01_1"))
                        or (luautils.stringStarts(tileObject:getSprite():getName(), "fixtures_windows_01_0"))
                        or (luautils.stringStarts(tileObject:getSprite():getName(), "fixtures_windows_01_32"))
                        or (luautils.stringStarts(tileObject:getSprite():getName(), "fixtures_windows_01_33")) then
                        
                            print("[DT-INFO] Window index found !");
                            object = ISSmashWindows.getBarricadeAble(x, y, z, tileObject:getObjectIndex());
                            if object then
                                print("[DT-INFO] Window object found !");
                                object:smashWindow();
                            end

                        end

                    end

                end

		    end
	    end
    end
    
end

ISSmashWindows.getBarricadeAble = function(x, y, z, index)
    local sq = getCell():getGridSquare(x, y, z)
    if sq and index >= 0 and index < sq:getObjects():size() then
        o = sq:getObjects():get(index)
        if instanceof(o, 'BarricadeAble') then
            return o
        end
    end
    return nil
end

Events.OnNewGame.Add(ISSmashWindows.smashCity);