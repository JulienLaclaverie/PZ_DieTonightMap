-- ================================================
--           PZ Die2Nite Map & mod
--           File created by Sylvain               
--           Date: 19/05/2017                         
--           Time: 13:33                         
-- ================================================


ServerSessionManager = {

    -- currentServerName = "",

    -- currentSession = nil,

    specialSessions = {
        {
            name = "onedayasaquarter",
            closeSubscriptionAfter = 86400
            -- closeSubscriptionAfter = 3,
        }
    }

};

ServerSessionManager.PrepareSession = function()
    if isServer() then
        getGameTime():getModData()["DT_currentServerName"] = getServerName();
        getGameTime():getModData()["DT_serverStartedAt"] = getGametimeTimestamp();
    end

end

ServerSessionManager.OnGameStart = function()
    if isClient() and getWorld():getGameMode() == "Multiplayer" then
        local currentServerName = getGameTime():getModData()["DT_currentServerName"];
        print("[DT-INFO] player connected to server ! serverName="..currentServerName..", isClient="..tostring(isClient())..", isMultiplayer="..tostring(getWorld():getGameMode() == "Multiplayer,")..", serverStartedAt="..getGameTime():getModData()["DT_serverStartedAt"])
        if currentServerName then
            for i,session in ipairs(ServerSessionManager.specialSessions) do
                if string.find(string.lower(currentServerName), session.name) then
                    if session.closeSubscriptionAfter or session.closeSubscriptionAfter == 0 then
                        local diff = getGametimeTimestamp() - getGameTime():getModData()["DT_serverStartedAt"];
                        -- print("[DT-INFO] ServerSessionManager: Checking session persistence --> "..diff.."/"..session.closeSubscriptionAfter.." days survived");
                        if diff > session.closeSubscriptionAfter then
                            print("[DT-INFO] ServerSessionManager: Disconnecting client because "..diff.."/"..session.closeSubscriptionAfter.." days survived");
                            -- triggerEvent("OnConnectFailed", "You can't reconnect to the server until the game is restarted.")
                            forceDisconnect();
                        end
                    end
                    break;
                end
            end
        end
    end
end

Events.OnGameStart.Add(ServerSessionManager.OnGameStart);
Events.OnServerStarted.Add(ServerSessionManager.PrepareSession);