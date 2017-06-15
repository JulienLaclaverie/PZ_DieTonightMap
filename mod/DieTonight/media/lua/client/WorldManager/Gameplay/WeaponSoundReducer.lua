-- ======================================================================================
--           PZ Die2Nite Map & mod              
--           File created by Sylvain               
--           Date: 15/06/2017                         
--           Time: 10:15
--           Credits: Based on Silencer / Suppressor Mod by nolanritchie
--           https://steamcommunity.com/sharedfiles/filedetails/?id=639909479
-- ======================================================================================

WeaponSoundReducer = {

    radius = 20

};

function WeaponSoundReducer.onAttack(owner,weapon)
    if weapon:getSubCategory() == "Firearm" then
        weapon:setSoundRadius( WeaponSoundReducer.radius );
    end
end

Events.OnWeaponSwing.Add(WeaponSoundReducer.onAttack);