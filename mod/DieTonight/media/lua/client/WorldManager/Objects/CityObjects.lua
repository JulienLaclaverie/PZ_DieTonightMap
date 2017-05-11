--
-- Properties
--

CityObjects = {

    objects = {

        -- Campfires
        campfire = {
            source = 'camping',
            action = 'addCampfire',
            args = { x = 7940, y = 6437, z = 0 }
            --sprite = "crafted_01_30"
        },

        -- window frames
        -- metalwindow = {
        -- I need to create window frames baricadeable via this lua file or from the map editor   
        -- }

        -- Baricades
        baricade = {
            source = 'object',
            action = 'baricade',
            args = { x=7922, y=6464, z=0, index=nil, isMetal=false, isMetalBar=false, itemID="Base.Plank", condition=100 },
            supportSprite = "constructedobjects_01_57"
        }

    }

};

--
-- Methods
--

-- Initialize objects with special behaviors (campfire, baricades, etc...)
CityObjects.initialize = function(player)

    print("[DT-INFO] Initializing all the objects of the map...");

    -- Check if initialization has not been done for previous characters
    -- [ Check needs to be implemented here ]

    for k, object in pairs(CityObjects.objects) do

        local sq = getWorld():getCell():getGridSquare(object.args.x, object.args.y, object.args.z);

        if object.action == 'addCampfire' then 
            print("[DT-INFO] Campfire...");

            if isClient() then
                sendClientCommand(nil, object.source, object.action, object.args);
            else
                camping.addCampfire(sq);
            end

        elseif object.action == 'baricade' then
            print("[DT-INFO] Baricade...");

            for i=0,sq:getObjects():size()-1 do
                -- Find the object that needs to recieve the baricade
                local tileObject = sq:getObjects():get(i);
                if luautils.stringStarts(tileObject:getSprite():getName(), object.supportSprite) then
                    print("[DT-ERROR] Tile Object has been found");
                    object.args.index = tileObject:getObjectIndex();
                    -- Add the baricade to the item
                    if isClient() then
                        sendClientCommand(nil, object.source, object.action, object.args);
                    else
                        CityObjects.placeBarricade(player, object.args);
                    end

                end
            end

        else

            print("[DT-ERROR] The provided action does'nt match any planned actions");

        end

    end

    -- Place a 'flag' to show that the initialization has been done once on the map
    -- This is done to prevent baricades respawn on new characters
    -- [ Flag needs to be implemented here ]

    print("[DT-INFO] Initialization is done !");
    
end

-- CityObjects.barricade = function(player, args)
CityObjects.placeBarricade = function(player, args)
    local object = CityObjects.getBarricadeAble(args.x, args.y, args.z, args.index)

    if object then
        print("[DT-INFO] Found Barricadeable");
        local barricade = IsoBarricade.AddBarricadeToObject(object, player);
        if barricade then
            print("[DT-INFO] Baricade is valid");
            if args.isMetal then
                local metal = InventoryItemFactory.CreateItem('Base.SheetMetal')
                metal:setCondition(args.condition);
                barricade:addMetal(player, metal);
                barricade:transmitCompleteItemToClients();
                --player:sendObjectChange('removeItemID', { id = args.itemID, type = "Base.SheetMetal" })
            elseif args.isMetalBar then
                local metal = InventoryItemFactory.CreateItem('Base.MetalBar');
                metal:setCondition(args.condition);
                barricade:addMetalBar(player, metal);
                barricade:transmitCompleteItemToClients();
                --player:sendObjectChange('removeItemID', { id = args.itemID, type = "Base.MetalBar" })
            else
                local plank = InventoryItemFactory.CreateItem('Base.Plank');
                plank:setCondition(args.condition);
                barricade:addPlank(player, plank);
                if barricade:getNumPlanks() == 1 then
                    barricade:transmitCompleteItemToClients();
                else
                    barricade:sendObjectChange('state');
                end
                --player:sendObjectChange('removeItemID', { id = args.itemID, type = "Base.Plank" })
                --player:sendObjectChange('removeOneOf', { type = 'Nails' })
                --player:sendObjectChange('addXp', { perk = Perks.Woodwork:index(), xp = 3, noMultiplier = true })
            end
        else
            print("[DT-ERROR] Barricade not created");
        end
    else
        print("[DT-ERROR] Expected Barricadeable");
    end
end

-- Get the baricadeable object from coords
CityObjects.getBarricadeAble = function(x, y, z, index)
    local sq = getCell():getGridSquare(x, y, z)
    if sq and index >= 0 and index < sq:getObjects():size() then
        o = sq:getObjects():get(index)
        if instanceof(o, 'BarricadeAble') then
            return o
        end
    end
    return nil
end

-- Get sprite & coordinates 
CityObjects.getCoords = function(player, context, worldobjects, test)

    for i,v in ipairs(worldobjects) do

        print( "---------------------------------------------------------------");
        print( "Square Coordinates --> " .. tostring(v:getSquare():getX()) .. ", " .. tostring(v:getSquare():getY()) .. ", " .. tostring(v:getSquare():getZ()) );
        print( "Selected Item --> " .. v:getSprite():getName());
        print( "---------------------------------------------------------------");

    end

end

-- Events are curently off because of the work in progress state
-- Events.OnFillWorldObjectContextMenu.Add(CityObjects.getCoords);
-- Events.OnNewGame.Add(CityObjects.initialize);