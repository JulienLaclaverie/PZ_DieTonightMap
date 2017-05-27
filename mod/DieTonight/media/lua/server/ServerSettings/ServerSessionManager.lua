-- ================================================
--           PZ Die2Nite Map & mod
--           File created by Sylvain               
--           Date: 19/05/2017                         
--           Time: 13:33                         
-- ================================================

ServerSessionManager = {

    currentSession = nil,

    specialSessions = {
        {
            name = "onedayasaquarter",
            closeSubscriptionAfter = 1
        }
    }

};

ServerSessionManager.UpdateServerAccess = function()
    if isServer() then
        local daysSurvived = getGameTime():getDaysSurvived();
        local option = getServerOptions():getOptionByName("Open");
        if option:getValue() == true and daysSurvived >= ServerSessionManager.currentSession.closeSubscriptionAfter then
            print("[DT-INFO] ServerSesssionManager: Closing subscriptions...");
            option:setValue(false);
        end
    end
end

ServerSessionManager.PrepareSession = function()
    if isServer() then
        local serverName = getServerName();
        for i,session in ipairs(ServerSessionManager.specialSessions) do
            if string.find(string.lower(serverName), session.name) then
                ServerSessionManager.currentSession = session;
                if session.closeSubscriptionAfter or session.closeSubscriptionAfter == 0 then
                    print("[DT-INFO] ServerSessionManager: Server will close subs after "..session.closeSubscriptionAfter.." days survived");
                    -- Activating Open option when server start
                    getServerOptions():getOptionByName("Open"):setValue(true);
                    -- EveryHours or EveryDays | EveryTenMinutes
                    Events.EveryHours.Add(ServerSessionManager.UpdateServerAccess);
                end
                break;
            end
        end
    end
end

Events.OnServerStarted.Add(ServerSessionManager.PrepareSession);