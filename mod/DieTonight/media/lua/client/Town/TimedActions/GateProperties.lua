-- ================================================
--           PZ Die2Nite Map & mod
--           File created by Sylvain               
--           Date: 06/05/2017                         
--           Time: 15:39                         
-- ================================================


GateProperties = {

    stopOnWalk = false,
    stopOnRun = false,
    caloriesModifier = 1,
    maxTime = 0 ,                 -- 100=2sec , 250=6sec
    animationDuration = 2,          -- in seconds
    soundPlayed = "shoveling",      -- see media/lua/shared/SoundBanks/SoundBanks.lua
    thumpDmg = 8,
    maxHealth = 200,
    ---- fixme: I wrote 12 because it can arrive that update() is triggered less than 25 times :'(
    animationPonderator = 12

}
