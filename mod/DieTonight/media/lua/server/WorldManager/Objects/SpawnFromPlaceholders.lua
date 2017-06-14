-- ================================================
--           PZ Die2Nite Map & mod              
--           File created by Sylvain               
--           Date: 14/06/2017                         
--           Time: 10:45                         
-- ================================================

SpawnFromPlaceholders = {};

SpawnFromPlaceholders.onGridsquareLoaded = function()

    CityObjects.spawnObjects();
    PlaceWindowsBaricades.spawnObjects();
    CustomZombieSpawn.spawnObjects();

end

Events.LoadGridsquare.Add(SpawnFromPlaceholders.onGridsquareLoaded);