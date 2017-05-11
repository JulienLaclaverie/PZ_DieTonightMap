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

        end

    end

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