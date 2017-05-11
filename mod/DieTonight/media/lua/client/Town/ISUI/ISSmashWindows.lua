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
            finish = 6565
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
                        or (luautils.stringStarts(tileObject:getSprite():getName(), "fixtures_windows_01_16"))
                        or (luautils.stringStarts(tileObject:getSprite():getName(), "fixtures_windows_01_17"))
                        or (luautils.stringStarts(tileObject:getSprite():getName(), "fixtures_windows_01_32"))
                        or (luautils.stringStarts(tileObject:getSprite():getName(), "fixtures_windows_01_33")) then
                        
                            print("[DT-INFO] Window index found !");
                            print("[DT-INFO] Coords : " .. x .. ", " .. y .. ", " .. z);
                            print("[DT-INFO] Tile : " .. tileObject:getSprite():getName());
                            object = ISSmashWindows.getBarricadeAble(x, y, z, tileObject:getObjectIndex());
                            if object then
                                print("[DT-INFO] Window object found !");
                                object:smashWindow();

                            	local character = getSpecificPlayer(0);
								local args = {};

								local randomBaricade = ZombRand(1,101);
								print("[DT-INFO] Random percentage for baricade : " .. randomBaricade);

								if (randomBaricade >= 95) then
									print("[DT-INFO] This window is metal sheet");
									local args = { x, y, z, i, isMetal=true, isMetalBar=false, itemID='Base.MetalBar', condition=100 }
									ISSmashWindows.placeBarricade(args, object, character);
								elseif (randomBaricade < 95) and (randomBaricade >= 87) then
									print("[DT-INFO] This window is metal bars");
									local args = { x, y, z, i, isMetal=false, isMetalBar=true, itemID='Base.SheetMetal', condition=100 }
									ISSmashWindows.placeBarricade(args, object, character);
								elseif (randomBaricade < 87) and (randomBaricade >= 79) then
									print("[DT-INFO] This window has four planks");
									local args = { x, y, z, i, isMetal=false, isMetalBar=false, itemID='Base.Plank', condition=100 }
									ISSmashWindows.placeBarricade(args, object, character);
									ISSmashWindows.placeBarricade(args, object, character);
									ISSmashWindows.placeBarricade(args, object, character);
									ISSmashWindows.placeBarricade(args, object, character);
								elseif (randomBaricade < 79) and (randomBaricade >= 67) then
									print("[DT-INFO] This window has three planks");
									local args = { x, y, z, i, isMetal=false, isMetalBar=false, itemID='Base.Plank', condition=100 }
									ISSmashWindows.placeBarricade(args, object, character);
									ISSmashWindows.placeBarricade(args, object, character);
									ISSmashWindows.placeBarricade(args, object, character);
								elseif (randomBaricade < 67) and (randomBaricade >= 49) then
									print("[DT-INFO] This window has two planks");
									local args = { x, y, z, i, isMetal=false, isMetalBar=false, itemID='Base.Plank', condition=100 }
									ISSmashWindows.placeBarricade(args, object, character);
									ISSmashWindows.placeBarricade(args, object, character);
								elseif (randomBaricade < 49) and (randomBaricade >= 27) then
									print("[DT-INFO] This window has one plank");
									local args = { x, y, z, i, isMetal=false, isMetalBar=false, itemID='Base.Plank', condition=100 }
									ISSmashWindows.placeBarricade(args, object, character);
								else
									print("[DT-INFO] This window has no baricade");
								end

								ISSmashWindows.placeBarricade(args, object, character);

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

ISSmashWindows.placeBarricade = function(args, object, character)


	if isClient() then

		print("[DT-INFO] Baricade Client is valid");
		sendClientCommand(character, 'object', 'barricade', args);

	else

		local barricade = IsoBarricade.AddBarricadeToObject(object, character);

	    if barricade then
	        print("[DT-INFO] Baricade Server is valid");
	        if args.isMetal then
	            local metal = InventoryItemFactory.CreateItem('Base.SheetMetal')
	            metal:setCondition(args.condition);
	            barricade:addMetal(character, metal);
	            barricade:transmitCompleteItemToClients();
	        elseif args.isMetalBar then
	            local metal = InventoryItemFactory.CreateItem('Base.MetalBar');
	            metal:setCondition(args.condition);
	            barricade:addMetalBar(character, metal);
	            barricade:transmitCompleteItemToClients();
	        else
	            local plank = InventoryItemFactory.CreateItem('Base.Plank');
	            plank:setCondition(args.condition);
	            barricade:addPlank(character, plank);
	            if barricade:getNumPlanks() == 1 then
	                barricade:transmitCompleteItemToClients();
	            else
	                barricade:sendObjectChange('state');
	            end
	        end
	    else
	        print("[DT-ERROR] Barricade not created");
	    end

	end

end

Events.OnNewGame.Add(ISSmashWindows.smashCity);