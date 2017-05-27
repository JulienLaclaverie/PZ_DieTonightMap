-- ================================================
--           PZ Die Tonight Map & mod              
--           File created by Sylvain               
--           Date: 06/05/2017                         
--           Time: 15:39                         
-- ================================================


GateProperties = {

    stopOnWalk = false,
    stopOnRun = false,
    caloriesModifier = 1,
    maxTime = 100 ,              -- 100=2sec , 250=6sec
    -- TODO: find the most appropriated sound
    soundPlayed = "shoveling",    -- see media/lua/shared/SoundBanks/SoundBanks.lua
    -- TODO: Check the thump domages that a gate can handle, also check maxHealth
    thumpDmg = 8,
    maxHealth = 200,
    ---- fixme: I wrote 12 because it can arrive that update() is triggered only 23 or 24 times... :'(
    animationPonderator = 12

}
