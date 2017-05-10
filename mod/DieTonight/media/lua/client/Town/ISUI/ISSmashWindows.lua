--
-- Properties
--

ISSmashWindows = {

    area = {

        -- x coordinates
        x = {
            start = 7931,
            finish = 7946
        },

        -- y coordinates
        y = {
            start = 6417,
            finish = 6428
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
ISSmashWindows.initialize = function(player)

    print("[DT-INFO] Smashing windows...");

    -- Check all the city squares to find windows

    for z = ISSmashWindows.area.z.start, ISSmashWindows.area.z.finish do
	    for y = ISSmashWindows.area.y.start, ISSmashWindows.area.y.finish do
		    for x = ISSmashWindows.area.x.start, ISSmashWindows.area.x.finish do

                local sq = getCell():getGridSquare(x, y, z);

                if sq then

                    for i=0,sq:getObjects():size()-1 do

                        print("[DT-INFO] Searching for windows...");
                        local tileObject = sq:getObjects():get(i);
                        if (luautils.stringStarts(tileObject:getSprite():getName(), "fixtures_windows_01_1")) or (luautils.stringStarts(tileObject:getSprite():getName(), "fixtures_windows_01_0")) then
                        
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

Events.OnFillWorldObjectContextMenu.Add(ISSmashWindows.initialize);