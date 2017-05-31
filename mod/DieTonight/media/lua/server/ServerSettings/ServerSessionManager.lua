-- ================================================
--           PZ Die2Nite Map & mod
--           File created by Sylvain               
--           Date: 19/05/2017                         
--           Time: 13:33                         
-- ================================================

ServerSessionManager = {

    currentServerName = "",

    currentSession = nil,

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
        -- print("[DT-INFO] ServerSesssionManager: Day survived="..tostring(daysSurvived).."/"..ServerSessionManager.currentSession.closeSubscriptionAfter..", isOpen="..tostring(option:getValue()));
        if option:getValue() == true and daysSurvived >= ServerSessionManager.currentSession.closeSubscriptionAfter then
            print("[DT-INFO] ServerSesssionManager: Closing subscriptions...");
            ServerSessionManager.updateOpenOption("false");
        end
    end
end

ServerSessionManager.updateOpenOption = function(value)
    -- print("[DT-INFO] Expecting Open="..value)
    ServerOptions.instance:init();
    ServerOptions.instance:changeOption("Open",value);
    -- print("[DT-INFO] After saving Open="..tostring(ServerOptions.instance:getOptionByName("Open"):getValue()));
end

ServerSessionManager.PrepareSession = function()
    if isServer() then
        ServerSessionManager.currentServerName = getServerName();
        for i,session in ipairs(ServerSessionManager.specialSessions) do
            if string.find(string.lower(ServerSessionManager.currentServerName), session.name) then
                ServerSessionManager.currentSession = session;
                if session.closeSubscriptionAfter or session.closeSubscriptionAfter == 0 then
                    print("[DT-INFO] ServerSessionManager: Server will close subs after "..session.closeSubscriptionAfter.." days survived");
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

Events.OnServerStarted.Add(ServerSessionManager.PrepareSession);