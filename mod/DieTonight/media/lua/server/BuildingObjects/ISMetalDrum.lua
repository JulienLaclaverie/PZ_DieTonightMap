--***********************************************************
--**                    ROBERT JOHNSON                     **
--***********************************************************

-- this class extend ISBuildingObject, it's a class to help you drag around/place an item in the world
ISMetalDrum = ISBuildingObject:derive("ISMetalDrum");
-- list of our barrel in the world
ISMetalDrum.barrels = {};
ISMetalDrum.waterScale = 4
ISMetalDrum.waterMax = 200 * ISMetalDrum.waterScale

ISMetalDrum.wantNoise = true
local noise = function(msg)
    if (ISMetalDrum.wantNoise) then print('metal drum: '..msg) end
end

function ISMetalDrum:create(x, y, z, north, sprite)
    local cell = getWorld():getCell();
    self.sq = cell:getGridSquare(x, y, z);
    self.javaObject = IsoThumpable.new(cell, self.sq, sprite, north, self);
    buildUtil.setInfo(self.javaObject, self);
    buildUtil.consumeMaterial(self);
    self.javaObject:setMaxHealth(200);
    self.javaObject:setBreakSound("breakdoor");
    self.sq:AddSpecialObject(self.javaObject);
    self.javaObject:getModData()["waterMax"] = self.waterMax;
    self.javaObject:getModData()["waterAmount"] = 0;
    self.javaObject:setSpecialTooltip(true)
    local barrel = {};
    barrel.x = self.sq:getX();
    barrel.y = self.sq:getY();
    barrel.z = self.sq:getZ();
    barrel.waterAmount = 0;
    barrel.waterMax = ISMetalDrum.waterMax;
    barrel.exterior = self.sq:isOutside()
    table.insert(ISMetalDrum.barrels, barrel);
    self.javaObject:transmitCompleteItemToServer();
end

function ISMetalDrum:new(player, sprite)
    local o = {};
    setmetatable(o, self);
    self.__index = self;
    o:init();
    o:setSprite(sprite);
    o:setNorthSprite(sprite);
    o.noNeedHammer = true;
    o.name = "MetalDrum";
    o.player = player;
    o.dismantable = true;
    return o;
end

-- our barrel can be placed on this square ?
-- this function is called everytime you move the mouse over a grid square, you can for example not allow building inside house..
function ISMetalDrum:isValid(square)
    if not square then return false end
    if square:isSolid() or square:isSolidTrans() then return false end
    if square:HasStairs() then return false end
    if square:HasTree() then return false end
    if not square:getMovingObjects():isEmpty() then return false end
    if not square:TreatAsSolidFloor() then return false end
    if not self:haveMaterial(square) then return false end
    for i=1,square:getObjects():size() do
        local obj = square:getObjects():get(i-1)
        if self:getSprite() == obj:getTextureName() then return false end
    end
    if buildUtil.stairIsBlockingPlacement( square, true ) then return false; end
    return true
end

-- called after render the ghost objects
-- the ISBuildingObject only render 1 sprite (north, south...), for example for stairs I can render the 2 others tile for stairs here
-- if I return false, the ghost render will be in red and I couldn't build the item
function ISMetalDrum:render(x, y, z, square)
    ISBuildingObject.render(self, x, y, z, square)
end

function ISMetalDrum.isISMetalDrumObject(object)
    if object ~= nil and object:getName() == "MetalDrum" then
        return true;
    end
    return false;
end

function ISMetalDrum.findObject(square)
    if not square then return nil end
    for i=0,square:getSpecialObjects():size()-1 do
        local obj = square:getSpecialObjects():get(i)
        if ISMetalDrum.isISMetalDrumObject(obj) then
            return obj
        end
    end
    return nil
end

-- every 10 minutes we check if it's raining, to fill our water barrel
function ISMetalDrum.checkRain()
    if isClient() then return; end
    for iB,vB in ipairs(ISMetalDrum.barrels) do
        ISMetalDrum.setModData(vB);
        if RainManager.isRaining() then
            if vB.waterAmount < vB.waterMax then
                local square = getCell():getGridSquare(vB.x, vB.y, vB.z);
                if square then vB.exterior = square:isOutside() end
                if vB.exterior then
                    local obj = ISMetalDrum.findObject(square)
                    if not vB.haveLogs and not vB.haveCharcoal then
                        vB.waterAmount = math.min(vB.waterMax, vB.waterAmount + 1 * ISMetalDrum.waterScale)
                        if obj then -- object might have been destroyed
                            noise('added rain to barrel at '..vB.x..","..vB.y..","..vB.z..' waterAmount='..vB.waterAmount)
                            obj:setWaterAmount(vB.waterAmount)
                            obj:transmitModData()
                        end
                    end
                end
            end
        else
            local square = getCell():getGridSquare(vB.x, vB.y, vB.z);
            local obj = ISMetalDrum.findObject(square)
            if vB.haveLogs and vB.isLit then
                if not vB.charcoalTick then vB.charcoalTick = 1; else vB.charcoalTick = vB.charcoalTick + 1; end
                noise('charcoal update ' .. vB.charcoalTick);
                if vB.charcoalTick == 12 then
                    vB.haveLogs = false;
                    vB.isLit = false;
                    vB.haveCharcoal = true;
                    vB.charcoalTick = nil;
                end
            end
            if obj then
                obj:getModData()["isLit"] = vB.isLit;
                obj:getModData()["haveCharcoal"] = vB.haveCharcoal;
                obj:getModData()["charcoalTick"] = vB.charcoalTick;
                ISMetalDrum.changeSprite(nil, obj);
                obj:transmitModData()
            end
        end
    end
end

function ISMetalDrum.LoadGridsquare(square)
    if isClient() then return; end
    -- does this square have a rain barrel ?
    for i=0,square:getSpecialObjects():size() - 1 do
        local obj = square:getSpecialObjects():get(i)
        if ISMetalDrum.isISMetalDrumObject(obj) then
            ISMetalDrum.loadMetalDrum(obj)
            break
        end
    end
end

function ISMetalDrum.loadGridsquareJavaHook(sq, object)
    if isClient() then return; end
    ISMetalDrum.loadMetalDrum(object)
end

-- load the barrel
function ISMetalDrum.loadMetalDrum(barrelObject)
    if not barrelObject or not barrelObject:getSquare() then return end
    local square = barrelObject:getSquare()
    local barrel = nil;
    -- check if we don't already have this barrel in our map (the streaming of the map make the gridsquare to reload every time)
    for i,v in ipairs(ISMetalDrum.barrels) do
        if v.x == square:getX() and v.y == square:getY() and v.z == square:getZ() then
            barrel = v;
            break;
        end
    end
    if not barrel then -- if we don't have the barrel, it's basically when you load your saved game the first time
        barrel = {};
        barrel.x = square:getX();
        barrel.y = square:getY();
        barrel.z = square:getZ();
        barrel.waterAmount = barrelObject:getWaterAmount()
        barrel.waterMax = barrelObject:getModData()["waterMax"]
        barrel.charcoalTick = barrelObject:getModData()["charcoalTick"];
        barrel.haveLogs = barrelObject:getModData()["haveLogs"];
        barrel.haveCharcoal = barrelObject:getModData()["haveCharcoal"];
        barrel.isLit = barrelObject:getModData()["isLit"];
        -- compatibility, waterAmount stored in IsoGridSquare modData
        if square:getModData()["waterAmount"] then
            barrel.waterAmount = tonumber(square:getModData()["waterAmount"])
            square:getModData()["waterAmount"] = nil
            square:getModData()["waterMax"] = nil
            square:getModData()["alwaysTakeWater"] = nil
            square:getModData()["waterbarrel"] = nil
        end
    -- sanity check + compatibility with waterMax stored in IsoGridSquare modData
    if not barrel.waterMax then
        local spriteName = nil
        if barrelObject:getSprite() then spriteName = barrelObject:getSprite():getName() end
        barrel.waterMax = ISMetalDrum.waterMax;
        barrelObject:getModData()["waterMax"] = barrel.waterMax
    end
    table.insert(ISMetalDrum.barrels, barrel);
    noise("new barrel created " .. barrel.x .. "," .. barrel.y .. " with " .. barrel.waterAmount .. " water");
    else
        noise("found existed barrel " .. barrel.x .. "," .. barrel.y .. " with " .. barrel.waterAmount);
        barrelObject:setWaterAmount(barrel.waterAmount)
    end

    barrelObject:setSpecialTooltip(true)
    barrelObject:getModData()["waterMax"] = barrel.waterMax
    barrel.exterior = square:isOutside()
    ISMetalDrum.changeSprite(barrel, barrelObject);
end

function ISMetalDrum.changeSprite(barrel, barrelObject)
    print("start change sprite")
    local spriteName = nil
    if not barrelObject then return; end
    if barrelObject:getModData()["haveLogs"] or barrelObject:getModData()["haveCharcoal"] then
        if barrelObject:getModData()["isLit"] then
        spriteName = "crafted_01_27"
        else
        spriteName = "crafted_01_26"
        end
    else
        spriteName = "crafted_01_24"
    end
    if barrel and not (barrelObject:getModData()["haveCharcoal"] or barrelObject:getModData()["haveLogs"] or barrelObject:getModData()["isLit"]) then
        if barrel.waterAmount >= barrel.waterMax * 0.75 then
            spriteName = "crafted_01_25"
        else
            spriteName = "crafted_01_24"
        end
    end
    if spriteName and (not barrelObject:getSprite() or spriteName ~= barrelObject:getSprite():getName()) then
    if barrel then noise('sprite changed to '..spriteName..' at '..barrel.x..','..barrel.y..','..barrel.z) end
        barrelObject:setSprite(spriteName)
        barrelObject:transmitUpdatedSpriteToClients()
    end
end

ISMetalDrum.OnClientCommand = function(module, command, player, args)
    if module ~= 'object' then
        return
    end
    -- This takeWater command works for *any* object that the player takes
    -- water from, including sinks and rain barrels.
    if command == 'takeWater' then
        local gs = getCell():getGridSquare(args.x, args.y, args.z)
        if gs then
            for i=0,gs:getObjects():size()-1 do
                local obj = gs:getObjects():get(i)
                if obj:useWater(args.units) > 0 then
                    obj:transmitModData()
                    break
                end
            end
        end
    end
end

-- Called when the client adds an object to the map (which it shouldn't be able to)
ISMetalDrum.OnObjectAdded = function(object)
    if isClient() then return end
    if ISMetalDrum.isISMetalDrumObject(object) then
        ISMetalDrum.loadMetalDrum(object)
    end
end

function ISMetalDrum.OnDestroyIsoThumpable(thump, player)
    if isClient() then return end
    if not thump:getSquare() or not ISMetalDrum.isISMetalDrumObject(thump) then
        return
    end
    local sq = thump:getSquare()
    if not sq then return end
        for iB,vB in ipairs(ISMetalDrum.barrels) do
        if vB.x == sq:getX() and vB.y == sq:getY() and vB.z == sq:getZ() then
            noise('destroyed at '..vB.x..','..vB.y..','..vB.z)
        table.remove(ISMetalDrum.barrels, iB)
        break
        end
    end
end

function ISMetalDrum.DoSpecialTooltip(tooltipUI, square)
    local playerObj = getSpecificPlayer(0)
    if not playerObj or playerObj:getZ() ~= square:getZ() or
        playerObj:DistToSquared(square:getX() + 0.5, square:getY() + 0.5) > 2 * 2 then
        return
    end

    local barrel = ISMetalDrum.findObject(square)
    if not barrel or not barrel:getModData()["waterMax"] then return end

    local smallFontHgt = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight()
    tooltipUI:setHeight(6 + smallFontHgt + 6 + smallFontHgt + 12)

    local textX = 12
    local textY = 6 + smallFontHgt + 6

    local barX = textX + getTextManager():MeasureStringX(UIFont.Small, getText("IGUI_invpanel_Remaining")) + 12
    local barWid = 80
    local barHgt = 4
    local barY = textY + (smallFontHgt - barHgt) / 2 + 2

    tooltipUI:setWidth(barX + barWid + 12)
    tooltipUI:DrawTextureScaledColor(nil, 0, 0, tooltipUI:getWidth(), tooltipUI:getHeight(), 0, 0, 0, 0.75)
    tooltipUI:DrawTextCentre(getText("ContextMenu_Rain_Collector_Barrel"), tooltipUI:getWidth() / 2, 6, 1, 1, 1, 1)
    tooltipUI:DrawText(getText("IGUI_invpanel_Remaining") .. ":", textX, textY, 1, 1, 1, 1)

    local f = barrel:getWaterAmount() / barrel:getModData()["waterMax"]
    local fg = { r=0.0, g=0.6, b=0.0, a=0.7 }
    if f < 0.0 then f = 0.0 end
    if f > 1.0 then f = 1.0 end
    local done = math.floor(barWid * f)
    if f > 0 then done = math.max(done, 1) end
    tooltipUI:DrawTextureScaledColor(nil, barX, barY, done, barHgt, fg.r, fg.g, fg.b, fg.a)
    local bg = {r=0.15, g=0.15, b=0.15, a=1.0}
    tooltipUI:DrawTextureScaledColor(nil, barX + done, barY, barWid - done, barHgt, bg.r, bg.g, bg.b, bg.a)
end

function ISMetalDrum.getLuaObject(drum)
    if not drum then return nil; end
    for iB,vB in ipairs(ISMetalDrum.barrels) do
        if vB.x == drum:getX() and vB.y == drum:getY() and vB.z == drum:getZ() then
            return vB;
        end
    end
end

ISMetalDrum.setModData = function(drum)
    local cell = getWorld():getCell();
    local sq = cell:getGridSquare(drum.x, drum.y, drum.z);
    if not sq then return; end
    local drumObject = ISMetalDrum.findObject(sq);
    local previousisLit = drumObject:getModData()["isLit"];
    local previoushaveLogs = drumObject:getModData()["haveLogs"];
    local previoushaveCharcoal = drumObject:getModData()["haveCharcoal"];
    local previouscharcoalTick = drumObject:getModData()["charcoalTick"];
    drumObject:getModData()["isLit"] = drum.isLit;
    drumObject:getModData()["haveLogs"] = drum.haveLogs;
    drumObject:getModData()["haveCharcoal"] = drum.haveCharcoal;
    drumObject:getModData()["charcoalTick"] = drum.charcoalTick;
    if previousisLit ~= drumObject:getModData()["isLit"] or previoushaveLogs ~= drumObject:getModData()["haveLogs"] or previoushaveCharcoal ~= drumObject:getModData()["haveCharcoal"] or previouscharcoalTick ~= drumObject:getModData()["charcoalTick"] then
        drumObject:transmitModData();
    end
end

ISMetalDrum.lit = function(drum, isLit)
    local luaDrum = ISMetalDrum.getLuaObject(drum);
    drum:getModData()["isLit"] = isLit;
    drum:transmitModData();
    if luaDrum then
        luaDrum.isLit = isLit;
        if isLit then
            luaDrum.LightSource = IsoLightSource.new(drum:getX(), drum:getY(), drum:getZ(), 0.61, 0.165, 0, 3);
            getCell():addLamppost(luaDrum.LightSource);
        elseif luaDrum.LightSource then
            getCell():removeLamppost(luaDrum.LightSource);
            luaDrum.charcoalTick = 0;
        end
    end
    drum:transmitModData();
    ISMetalDrum.changeSprite(nil, drum);
end

ISMetalDrum.addCharcoal = function(drum, haveCharcoal)
    local luaDrum = ISMetalDrum.getLuaObject(drum);
    drum:getModData()["haveCharcoal"] = haveCharcoal;
    drum:transmitModData();
    if luaDrum then
        luaDrum.haveCharcoal = haveCharcoal;
    end
    drum:transmitModData();
    ISMetalDrum.changeSprite(nil, drum);
end

ISMetalDrum.addLogs = function(drum, haveLog)
    local luaDrum = ISMetalDrum.getLuaObject(drum);
    drum:getModData()["haveLogs"] = haveLog;
    drum:transmitModData();
    if luaDrum then
        luaDrum.haveLogs = haveLog;
        if not haveLog then
            luaDrum.charcoalTick = 0;
        end
    end
    drum:transmitModData();
    ISMetalDrum.changeSprite(nil, drum);
end

-- every 10 minutes we check if it's raining, to fill our water barrel
Events.EveryTenMinutes.Add(ISMetalDrum.checkRain);
Events.OnClientCommand.Add(ISMetalDrum.OnClientCommand)
Events.OnObjectAdded.Add(ISMetalDrum.OnObjectAdded)
Events.OnDestroyIsoThumpable.Add(ISMetalDrum.OnDestroyIsoThumpable);

