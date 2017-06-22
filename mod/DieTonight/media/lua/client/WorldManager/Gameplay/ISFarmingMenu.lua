-- ================================================
--           PZ Die Tonight Map & mod              
--           File created by Sylvain              
--           Date: 20/06/2017                        
--           Time: 19:12                        
-- ================================================

ISFarmingMenu.canDigHere = function(worldObjects)
    local squares = {}
    local didSquare = {}
    for _,worldObj in ipairs(worldObjects) do
        if not didSquare[worldObj:getSquare()] then
            table.insert(squares, worldObj:getSquare())
            didSquare[worldObj:getSquare()] = true
        end
    end
    for _,square in ipairs(squares) do
        for i=1,square:getObjects():size() do
            local obj = square:getObjects():get(i-1);
            if ISFarmingMenu.isDiggable(obj) and not ISFarmingMenu.isDesert(obj) then
                return true;
            end
        end
    end
    return false;
end

ISFarmingMenu.isDiggable = function(obj)
    if not obj:getTextureName() then
        return false;
    end

    return luautils.stringStarts(obj:getTextureName(), "floors_exterior_natural") or
           luautils.stringStarts(obj:getTextureName(), "blends_natural_01");
end

ISFarmingMenu.isDesert = function(obj)
    if not obj:getTextureName() then
        return false;
    end

    for i=0,15,1 do
        if obj:getTextureName() == ("blends_natural_01_"..i) then
            return true;
        end
    end

    return false;
end