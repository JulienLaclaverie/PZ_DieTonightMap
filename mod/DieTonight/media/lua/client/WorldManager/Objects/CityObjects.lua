--
-- Properties
--
 
CityObjects = {}

-- Methods
--

CityObjects.loadGridsquare = function(sq)


    for i=0,sq:getObjects():size()-1 do

        -- Searching for objects
        local tileObject = sq:getObjects():get(i);

        if tileObject then

            -- Place a campfire
            if tileObject:getSprite():getName() == "location_community_park_01_16" then

                -- Remove the placeholder 
                sq:RemoveTileObject(tileObject);

                -- Place the campfire
                local args = { x = sq:getX(), y = sq:getY(), z = sq:getZ() };
                if isClient() then
                    sendClientCommand(nil, 'camping', 'addCampfire', args);
                else
                    camping.addCampfire(sq);
                end

            end

            -- Place a Metal drum
            if tileObject:getSprite():getName() == "location_community_park_01_18" then

                -- Remove the placeholder & load metal drum
                print("[DT-INFO] Add Metal drum to map");
                sq:RemoveTileObject(tileObject);
                CityObjects.createMetalDrum(sq);

            end

            -- Place a composter
            if tileObject:getSprite():getName() == "location_community_park_01_22" then

                -- Remove the placeholder & load the furnace
                print("[DT-INFO] Add Compost to map");
                sq:RemoveTileObject(tileObject);
                CityObjects.createCompost(sq);

            end

        end

    end

end

-- Place a metal barrel on a square
CityObjects.createMetalDrum = function(sq)

    local character = getSpecificPlayer(0);
    local cell = getWorld():getCell();
    local square = cell:getGridSquare(sq:getX(), sq:getY(), sq:getZ());

    local metalDrum = ISMetalDrum:new(character, "crafted_01_24");
    local javaObject = IsoThumpable.new(cell, square, "crafted_01_24", false, metalDrum);

    buildUtil.setInfo(javaObject, metalDrum);
    javaObject:setMaxHealth(200);
    javaObject:setBreakSound("breakdoor");
    square:AddSpecialObject(javaObject);
    javaObject:getModData()["waterMax"] = 200;
    javaObject:getModData()["waterAmount"] = 0;
    javaObject:setSpecialTooltip(true);

    local barrel = {};
    barrel.x = square:getX();
    barrel.y = square:getY();
    barrel.z = square:getZ();
    barrel.waterAmount = 0;
    barrel.waterMax = ISMetalDrum.waterMax;
    barrel.exterior = square:isOutside();

    table.insert(ISMetalDrum.barrels, barrel);
    javaObject:transmitCompleteItemToServer();

end

-- Place an compost on a square
CityObjects.createCompost = function(sq)

    local character = getSpecificPlayer(0);
    local cell = getWorld():getCell();
    local square = cell:getGridSquare(sq:getX(), sq:getY(), sq:getZ());

    local javaObject = IsoCompost.new(cell, square);

    --square:AddSpecialObject(javaObject);
    --javaObject:transmitCompleteItemToServer();
    
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

Events.LoadGridsquare.Add(CityObjects.loadGridsquare);
Events.OnFillWorldObjectContextMenu.Add(CityObjects.getCoords);