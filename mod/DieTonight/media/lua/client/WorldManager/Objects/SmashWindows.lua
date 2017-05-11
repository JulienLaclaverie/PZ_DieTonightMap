--
-- Properties
--

SmashWindows = {

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

SmashWindows.loadGridsquare = function(sq)

    for i=0,sq:getObjects():size()-1 do

        -- Searching for windows
        local tileObject = sq:getObjects():get(i);

        if tileObject then

        	if tileObject:getSprite():getName() == "fixtures_windows_01_1"
	        or tileObject:getSprite():getName() == "fixtures_windows_01_0"
	        or tileObject:getSprite():getName() == "fixtures_windows_01_16"
	        or tileObject:getSprite():getName() == "fixtures_windows_01_17"
	        or tileObject:getSprite():getName() == "fixtures_windows_01_32"
	        or tileObject:getSprite():getName() == "fixtures_windows_01_33" then

				local coords = { x = sq:getX(), y = sq:getY(), z = sq:getZ() }
	        
	            print("[DT-INFO] Window index found !");
	            print("[DT-INFO] Coords : " .. coords.x .. ", " .. coords.y .. ", " .. coords.z);
	            print("[DT-INFO] Tile : " .. tileObject:getSprite():getName());
	            object = SmashWindows.getBarricadeAble(coords.x, coords.y, coords.z, tileObject:getObjectIndex());

	            if object then
	                print("[DT-INFO] Window object found !");
	                object:smashWindow();

	            	local character = getSpecificPlayer(0);
	            	local args = {}

					local randomBaricade = ZombRand(1,101);
					print("[DT-INFO] Random percentage for baricade : " .. randomBaricade);

					if (randomBaricade >= 95) then
						print("[DT-INFO] This window is metal sheet");
						local args = { coords.x, coords.y, coords.z, i, isMetal=true, isMetalBar=false, itemID='Base.MetalBar', condition=100 }
						SmashWindows.placeBarricade(args, object, character);
					elseif (randomBaricade < 95) and (randomBaricade >= 87) then
						print("[DT-INFO] This window is metal bars");
						local args = { coords.x, coords.y, coords.z, i, isMetal=false, isMetalBar=true, itemID='Base.SheetMetal', condition=100 }
						SmashWindows.placeBarricade(args, object, character);
					elseif (randomBaricade < 87) and (randomBaricade >= 79) then
						print("[DT-INFO] This window has four planks");
						local args = { coords.x, coords.y, coords.z, i, isMetal=false, isMetalBar=false, itemID='Base.Plank', condition=100 }
						SmashWindows.placeBarricade(args, object, character);
						SmashWindows.placeBarricade(args, object, character);
						SmashWindows.placeBarricade(args, object, character);
						SmashWindows.placeBarricade(args, object, character);
					elseif (randomBaricade < 79) and (randomBaricade >= 67) then
						print("[DT-INFO] This window has three planks");
						local args = { coords.x, coords.y, coords.z, i, isMetal=false, isMetalBar=false, itemID='Base.Plank', condition=100 }
						SmashWindows.placeBarricade(args, object, character);
						SmashWindows.placeBarricade(args, object, character);
						SmashWindows.placeBarricade(args, object, character);
					elseif (randomBaricade < 67) and (randomBaricade >= 49) then
						print("[DT-INFO] This window has two planks");
						local args = { coords.x, coords.y, coords.z, i, isMetal=false, isMetalBar=false, itemID='Base.Plank', condition=100 }
						SmashWindows.placeBarricade(args, object, character);
						SmashWindows.placeBarricade(args, object, character);
					elseif (randomBaricade < 49) and (randomBaricade >= 27) then
						print("[DT-INFO] This window has one plank");
						local args = { coords.x, coords.y, coords.z, i, isMetal=false, isMetalBar=false, itemID='Base.Plank', condition=100 }
						SmashWindows.placeBarricade(args, object, character);
					else
						print("[DT-INFO] This window has no baricade");
					end

					SmashWindows.placeBarricade(args, object, character);

	            end

	        end

        end

    end

end

SmashWindows.getBarricadeAble = function(x, y, z, index)
    local sq = getCell():getGridSquare(x, y, z)
    if sq and index >= 0 and index < sq:getObjects():size() then
        o = sq:getObjects():get(index)
        if instanceof(o, 'BarricadeAble') then
            return o
        end
    end
    return nil
end

SmashWindows.placeBarricade = function(args, object, character)


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

Events.LoadGridsquare.Add(SmashWindows.loadGridsquare);
--Events.OnNewGame.Add(SmashWindows.smashCity);