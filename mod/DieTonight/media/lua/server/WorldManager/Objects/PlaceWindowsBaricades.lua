--
-- Properties
--
 
PlaceWindowsBaricades = {};

-- Methods
--

PlaceWindowsBaricades.loadGridsquare = function(sq)

    if isClient() == false then

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
                
                    --print("[DT-INFO] Window index found !");
                    --print("[DT-INFO] Coords : " .. coords.x .. ", " .. coords.y .. ", " .. coords.z);
                    --print("[DT-INFO] Tile : " .. tileObject:getSprite():getName());
                    object = PlaceWindowsBaricades.getBarricadeAble(coords.x, coords.y, coords.z, tileObject:getObjectIndex());

                    if object then
                        --print("[DT-INFO] Window object found !");

                        local args = {}

                        local randomBaricadeLocation = ZombRand(0,4);
                        local barricadeLocation = true;

                        if (randomBaricadeLocation > 2) then
                            barricadeLocation = false;
                        end

                        local randomBaricade = ZombRand(0,100);
                        --print("[DT-INFO] Random percentage for baricade : " .. randomBaricade);

                        if (randomBaricade >= 95) then
                            --print("[DT-INFO] This window is metal sheet");
                            local args = { x=coords.x, y=coords.y, z=coords.z, index=i, isMetal=true, isMetalBar=false, itemID='Base.MetalBar', condition=10, amount=1 }
                            PlaceWindowsBaricades.placeBarricade(args, object, barricadeLocation);
                        elseif (randomBaricade < 95) and (randomBaricade >= 87) then
                            --print("[DT-INFO] This window is metal bars");
                            local args = { x=coords.x, y=coords.y, z=coords.z, index=i, isMetal=false, isMetalBar=true, itemID='Base.SheetMetal', condition=10, amount=1 }
                            PlaceWindowsBaricades.placeBarricade(args, object, barricadeLocation);
                        elseif (randomBaricade < 87) and (randomBaricade >= 79) then
                            --print("[DT-INFO] This window has four planks");
                            local args = { x=coords.x, y=coords.y, z=coords.z, index=i, isMetal=false, isMetalBar=false, itemID='Base.Plank', condition=10, amount=4 }
                            PlaceWindowsBaricades.placeBarricade(args, object, barricadeLocation);
                        elseif (randomBaricade < 79) and (randomBaricade >= 67) then
                            --print("[DT-INFO] This window has three planks");
                            local args = { x=coords.x, y=coords.y, z=coords.z, index=i, isMetal=false, isMetalBar=false, itemID='Base.Plank', condition=10, amount=3 }
                            PlaceWindowsBaricades.placeBarricade(args, object, barricadeLocation);
                        elseif (randomBaricade < 67) and (randomBaricade >= 49) then
                            --print("[DT-INFO] This window has two planks");
                            local args = { x=coords.x, y=coords.y, z=coords.z, index=i, isMetal=false, isMetalBar=false, itemID='Base.Plank', condition=10, amount=2 }
                            PlaceWindowsBaricades.placeBarricade(args, object, barricadeLocation);
                        elseif (randomBaricade < 49) and (randomBaricade >= 30) then
                            --print("[DT-INFO] This window has one plank");
                            local args = { x=coords.x, y=coords.y, z=coords.z, index=i, isMetal=false, isMetalBar=false, itemID='Base.Plank', condition=10, amount=1 }
                            PlaceWindowsBaricades.placeBarricade(args, object, barricadeLocation);
                        --else
                            --print("[DT-INFO] This window has no baricade");
                        end

                        object:smashWindow();

                    end

                end

            end

        end

    end

end

PlaceWindowsBaricades.getBarricadeAble = function(x, y, z, index)
    local sq = getCell():getGridSquare(x, y, z)
    if sq and index >= 0 and index < sq:getObjects():size() then
        o = sq:getObjects():get(index)
        if instanceof(o, 'BarricadeAble') then
            return o
        end
    end
    return nil
end

PlaceWindowsBaricades.placeBarricade = function(args, object, barricadeLocation)

    local barricade = IsoBarricade.AddBarricadeToObject(object, barricadeLocation) ;

    if barricade then
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
            
            for i=0, args.amount - 1 do
                barricade:addPlank(character, plank);

                if barricade:getNumPlanks() == 1 then
                    barricade:transmitCompleteItemToClients();
                else
                    barricade:sendObjectChange('state');
                end
            end
        end
    else
        print("[DT-ERROR] Barricade not created");
    end

end

Events.LoadGridsquare.Add(PlaceWindowsBaricades.loadGridsquare);
