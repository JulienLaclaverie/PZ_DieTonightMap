-- ================================================
--           PZ Die Tonight Map & mod              
--           File created by Sylvain               
--           Date: 18/05/2017                         
--           Time: 16:19                         
-- ================================================

OneDayInAQuarter = {
    modeName = "OneDayInAQuarter"
};

-- ServerOptions

OneDayInAQuarter.Tick = function()
    print("[DT-INFO] OneDayInAQuarter: isClient() --> "..tostring(isClient())..", isServer() --> "..tostring(isServer())..", getSandboxOptions() --> "..tostring(getSandboxOptions()));
    -- if isServer() then
        -- print("[DT-INFO] OneDayInAQuarter: Mode matcher enabled on server. activated custom mode --> "..tostring(ServerOptions:getOption("DietonightMode")));
        -- see SandboxVars in client/LastStand/AReallyCDDAy.lua
    -- else
        --[[local serverOptions = ServerOptions:new();
        print("[DT-INFO] OneDayInAQuarter: Mode matcher enabled on server. activated custom mode --> "..tostring(serverOptions:getOptionByName("DietonightMode")));
        for i=1,serverOptions:getNumOptions() do
            print("[DT-INFO] OneDayInAQuarter: "..tostring(serverOptions:getOptionByIndex(i-1):getName()).." --> "..tostring(serverOptions:getOptionByIndex(i-1)));
        end]]
        for i=1,getSandboxOptions():getNumOptions() do
            print("[DT-INFO] OneDayInAQuarter: "..tostring(getSandboxOptions():getOptionByIndex(i-1):getName()).." --> "..tostring(getSandboxOptions():getOptionByIndex(i-1):getValue()));
        end
        -- serverOptions:getOptionByName("DietonightMode")
        -- DietonightMode=OneDayInAQuarter
    -- end
end

-- Events.EveryTenMinutes.Add(OneDayInAQuarter.Tick);
-- Events.EveryDays.Add(OneDayInAQuarter.Tick);
