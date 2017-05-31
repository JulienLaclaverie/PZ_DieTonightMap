-- ================================================
--           PZ Die2Nite Map & mod
--           File created by Sylvain               
--           Date: 19/05/2017                         
--           Time: 13:33                         
-- ================================================

ServerSessionManager = {

    currentServerName = "",

    currentSession = nil,

    currentSessionSettings = nil,

    optionsAlreadyReloaded = false,

    specialSessions = {
        {
            name = "onedayasaquarter",
            closeSubscriptionAfter = 2
        }
    }

};

ServerSessionManager.UpdateServerAccess = function()
    if isServer() then
        local daysSurvived = getGameTime():getDay();
        local option = ServerOptions.instance:getOptionByName("Open");
        print("[DT-INFO] ServerSesssionManager: Day survived="..tostring(daysSurvived).."/"..ServerSessionManager.currentSession.closeSubscriptionAfter..", isOpen="..tostring(option:getValue()));
        if option:getValue() == true and daysSurvived >= ServerSessionManager.currentSession.closeSubscriptionAfter then
            print("[DT-INFO] ServerSesssionManager: Closing subscriptions...");
            ServerSessionManager.updateOpenOption("false");
        end
    end
end

ServerSessionManager.updateOpenOption = function(value)
    print("[DT-INFO] Expecting Open="..value)
    ServerOptions.instance:init();
    ServerOptions.instance:changeOption("Open",value);
    -- ServerSessionManager.currentSessionSettings:getServerOptions():getOptionByName("Open"):parse(value);
    -- ServerSessionManager.currentSessionSettings:saveFiles();
    print("[DT-INFO] After saving Open="..tostring(ServerOptions.instance:getOptionByName("Open"):getValue()));
    -- print("[DT-INFO] After saving Open="..tostring(ServerSessionManager.currentSessionSettings:getServerOptions():getOptionByName("Open"):getValue()));
end

ServerSessionManager.PrepareSession = function()
    if isServer() then
        ServerSessionManager.currentServerName = getServerName();
        getGameTime():getModData()["DT_currentServerName"] = ServerSessionManager.currentServerName;
        for i,session in ipairs(ServerSessionManager.specialSessions) do
            if string.find(string.lower(ServerSessionManager.currentServerName), session.name) then
                ServerSessionManager.currentSession = session;
                if session.closeSubscriptionAfter or session.closeSubscriptionAfter == 0 then
                    print("[DT-INFO] ServerSessionManager: Server will close subs after "..session.closeSubscriptionAfter.." days survived");
                    -- ServerSessionManager.currentSessionSettings = ServerSettings.new(ServerSessionManager.currentServerName);
                    -- ServerSessionManager.currentSessionSettings:loadFiles();

                    -- Activating Open option when server start
                    ServerSessionManager.updateOpenOption("true");
                    -- EveryHours or EveryDays | EveryTenMinutes
                    Events.EveryHours.Add(ServerSessionManager.UpdateServerAccess);
                end
                break;
            end
        end
    end

end

-- Reload the options one time if necessary
--[[ServerSessionManager.ReloadOptions = function()
    local daysSurvived = getGameTime():getDay();
    local option = getServerOptions():getOptionByName("Open");

    if daysSurvived >= ServerSessionManager.currentSession.closeSubscriptionAfter and
       not ServerSessionManager.optionsAlreadyReloaded then
        print("[DT-INFO] Reloading options. survivedDays="..getGameTime():getDay()..", isOpen="..tostring(option:getValue())..", serverName="..tostring(ServerSessionManager.currentServerName))
        SendCommandToServer("/reloadoptions");
        ServerSessionManager.optionsAlreadyReloaded = true;
    end

end

-- Prepare the client custom session
ServerSessionManager.PrepareClientSession = function()
    ServerSessionManager.currentServerName = getGameTime():getModData()["DT_currentServerName"];

    if isClient() and getWorld():getGameMode() == "Multiplayer" and ServerSessionManager.currentServerName then
        for i,session in ipairs(ServerSessionManager.specialSessions) do
            if string.find(string.lower(ServerSessionManager.currentServerName), session.name) then
                ServerSessionManager.currentSession = session;
                if session.closeSubscriptionAfter or session.closeSubscriptionAfter == 0 then
                    print("[DT-INFO] Adding reload options trigger to client");
                    Events.EveryHours.Add(ServerSessionManager.ReloadOptions);
                end
                break;
            end
        end
    end

end

Events.OnGameStart.Add(ServerSessionManager.PrepareClientSession);]]
Events.OnServerStarted.Add(ServerSessionManager.PrepareSession);