--
-- Scavenging tables for the DieTonight mod
--

scavenges = {};
scavenges.plants = {};
scavenges.insects = {};
scavenges.mushrooms = {};
scavenges.berries = {};
scavenges.forestGoods = {};
scavenges.medicinalPlants = {};

-- Food is stored in "insects" table
-- Rank 0 - Insects & small candy
local Cricket = {};
Cricket.type = "Base.Cricket";
Cricket.minCount = 1;
Cricket.maxCount = 1;
Cricket.skill = 0;
local Deserthopper = {};
Deserthopper.type = "Base.Deserthopper";
Deserthopper.minCount = 1;
Deserthopper.maxCount = 1;
Deserthopper.skill = 0;
-- Rank 1 - Cockroach
local Cockroach = {};
Cockroach.type = "Base.Cockroach";
Cockroach.minCount = 1;
Cockroach.maxCount = 1;
Cockroach.skill = 1;
local MintCandy = {};
MintCandy.type = "Base.MintCandy";
MintCandy.minCount = 1;
MintCandy.maxCount = 2;
MintCandy.skill = 1;
-- Rank 2 - More candies & Chips
local Lollipop = {};
Lollipop.type = "Base.Lollipop";
Lollipop.minCount = 1;
Lollipop.maxCount = 1;
Lollipop.skill = 2;
local Chips = {};
Chips.type = "Base.Crisps";
Chips.minCount = 1;
Chips.maxCount = 1;
Chips.skill = 2;
-- Rank 3 - Dryed & depressing food
local DeadRat = {};
DeadRat.type = "Base.DeadRat";
DeadRat.minCount = 1;
DeadRat.maxCount = 1;
DeadRat.skill = 3;
local Dogfood = {};
Dogfood.type = "Base.Dogfood";
Dogfood.minCount = 1;
Dogfood.maxCount = 1;
Dogfood.skill = 3;
local Ramens = {};
Ramens.type = "Base.Ramen";
Ramens.minCount = 1;
Ramens.maxCount = 1;
Ramens.skill = 3;
-- Rank 4 - Wine & Fish Time
local Modjeska = {};
Modjeska.type = "Base.Modjeska";
Modjeska.minCount = 1;
Modjeska.maxCount = 1;
Modjeska.skill = 4;
local TunaTin = {};
TunaTin.type = "Base.TunaTin";
TunaTin.minCount = 1;
TunaTin.maxCount = 1;
TunaTin.skill = 4;
local Wine2 = {};
Wine2.type = "Base.Wine2";
Wine2.minCount = 1;
Wine2.maxCount = 1;
Wine2.skill = 4;
-- Rank 5 - Good non perishable food & whiskey for morale
local Peanuts = {};
Peanuts.type = "Base.Peanuts";
Peanuts.minCount = 1;
Peanuts.maxCount = 1;
Peanuts.skill = 5;
local Chocolate = {};
Chocolate.type = "Base.Chocolate";
Chocolate.minCount = 1;
Chocolate.maxCount = 1;
Chocolate.skill = 5;
local WhiskeyFull = {};
WhiskeyFull.type = "Base.WhiskeyFull";
WhiskeyFull.minCount = 1;
WhiskeyFull.maxCount = 1;
WhiskeyFull.skill = 5;
-- Rank 6 - Vegetables & package unlocked
local Avocado = {};
Avocado.type = "Base.Avocado";
Avocado.minCount = 1;
Avocado.maxCount = 3;
Avocado.skill = 6;
local CandyPackage = {};
CandyPackage.type = "Base.CandyPackage";
CandyPackage.minCount = 1;
CandyPackage.maxCount = 1;
CandyPackage.skill = 6;
-- Rank 8 - Water source vegetable
local Watermelon = {};
Watermelon.type = "Base.WatermelonSmashed";
Watermelon.minCount = 1;
Watermelon.maxCount = 1;
Watermelon.skill = 8;

table.insert(scavenges.insects, Cricket);
table.insert(scavenges.insects, Deserthopper);
table.insert(scavenges.insects, Cockroach);
table.insert(scavenges.insects, Lollipop);
table.insert(scavenges.insects, Modjeska);
table.insert(scavenges.insects, CandyPackage);
table.insert(scavenges.insects, MintCandy);
table.insert(scavenges.insects, Chips);
table.insert(scavenges.insects, DeadRat);
table.insert(scavenges.insects, Dogfood);
table.insert(scavenges.insects, Ramens);
table.insert(scavenges.insects, TunaTin);
table.insert(scavenges.insects, Wine2);
table.insert(scavenges.insects, Peanuts);
table.insert(scavenges.insects, Chocolate);
table.insert(scavenges.insects, WhiskeyFull);
table.insert(scavenges.insects, Avocado);
table.insert(scavenges.insects, Watermelon);

-- Pharmaceuticals are stored in "MedicinalPlants" table
-- Rank 0 - Low usage pills & medic stuffs
local Bandaid = {};
Bandaid.type = "Base.Bandaid";
Bandaid.minCount = 1;
Bandaid.maxCount = 3;
Bandaid.skill = 0;
local PillsSleepingTablets = {};
PillsSleepingTablets.type = "Base.PillsSleepingTablets";
PillsSleepingTablets.minCount = 1;
PillsSleepingTablets.maxCount = 1;
PillsSleepingTablets.skill = 0;
-- Rank 1 - Operation stuff
local Needle = {};
Needle.type = "Base.Needle";
Needle.minCount = 1;
Needle.maxCount = 1;
Needle.skill = 1;
local Thread = {};
Thread.type = "Base.Thread";
Thread.minCount = 1;
Thread.maxCount = 1;
Thread.skill = 1;
local Tweezers = {};
Tweezers.type = "Base.Tweezers";
Tweezers.minCount = 1;
Tweezers.maxCount = 1;
Tweezers.skill = 1;
-- Rank 2 - Standard pills
local Pills = {};
Pills.type = "Base.Pills";
Pills.minCount = 1;
Pills.maxCount = 1;
Pills.skill = 2;
local PillsBeta = {};
PillsBeta.type = "Base.PillsBeta";
PillsBeta.minCount = 1;
PillsBeta.maxCount = 1;
PillsBeta.skill = 2;
-- Rank 3 - Bandage & Antidepressant
local BandageDirty = {};
BandageDirty.type = "Base.BandageDirty";
BandageDirty.minCount = 1;
BandageDirty.maxCount = 2;
BandageDirty.skill = 3;
local PillsAntiDep = {};
PillsAntiDep.type = "Base.PillsAntiDep";
PillsAntiDep.minCount = 1;
PillsAntiDep.maxCount = 1;
PillsAntiDep.skill = 3;
-- Rank 4 - Anti-infections stuff
local AlcoholWipes = {};
AlcoholWipes.type = "Base.AlcoholWipes";
AlcoholWipes.minCount = 1;
AlcoholWipes.maxCount = 1;
AlcoholWipes.skill = 4;
local Antibiotics = {};
Antibiotics.type = "Base.Antibiotics";
Antibiotics.minCount = 1;
Antibiotics.maxCount = 1;
Antibiotics.skill = 4;
-- Rank 5 - Disinfectant
local Disinfectant = {};
Disinfectant.type = "Base.Disinfectant";
Disinfectant.minCount = 1;
Disinfectant.maxCount = 1;
Disinfectant.skill = 5;

table.insert(scavenges.medicinalPlants, Bandaid);
table.insert(scavenges.medicinalPlants, PillsSleepingTablets);
table.insert(scavenges.medicinalPlants, Needle);
table.insert(scavenges.medicinalPlants, Thread);
table.insert(scavenges.medicinalPlants, Tweezers);
table.insert(scavenges.medicinalPlants, Pills);
table.insert(scavenges.medicinalPlants, PillsBeta);
table.insert(scavenges.medicinalPlants, BandageDirty);
table.insert(scavenges.medicinalPlants, PillsAntiDep);
table.insert(scavenges.medicinalPlants, AlcoholWipes);
table.insert(scavenges.medicinalPlants, Antibiotics);
table.insert(scavenges.medicinalPlants, Disinfectant);

-- Objects are stored in "Berries" table
-- Rank 0 - Useless and low usage stuff
local Dice = {};
Dice.type = "Base.Dice";
Dice.minCount = 1;
Dice.maxCount = 1;
Dice.skill = 0;
local CardDeck = {};
CardDeck.type = "Base.CardDeck";
CardDeck.minCount = 1;
CardDeck.maxCount = 1;
CardDeck.skill = 0;
local Earbuds = {};
Earbuds.type = "Base.Earbuds";
Earbuds.minCount = 1;
Earbuds.maxCount = 1;
Earbuds.skill = 0;
local ToyBear = {};
ToyBear.type = "Base.ToyBear";
ToyBear.minCount = 1;
ToyBear.maxCount = 1;
ToyBear.skill = 0;
local Garbagebag = {};
Garbagebag.type = "Base.Garbagebag";
Garbagebag.minCount = 1;
Garbagebag.maxCount = 1;
Garbagebag.skill = 0;
local Matches = {};
Matches.type = "Base.Matches";
Matches.minCount = 1;
Matches.maxCount = 1;
Matches.skill = 0;
local Newspaper = {};
Newspaper.type = "Base.Newspaper";
Newspaper.minCount = 1;
Newspaper.maxCount = 1;
Newspaper.skill = 0;
local Scotchtape = {};
Scotchtape.type = "Base.Scotchtape";
Scotchtape.minCount = 1;
Scotchtape.maxCount = 1;
Scotchtape.skill = 0;
local Paperclip = {};
Paperclip.type = "Base.Paperclip";
Paperclip.minCount = 1;
Paperclip.maxCount = 3;
Paperclip.skill = 0;
-- Rank 1 - Slightly better loots
local Lighter = {};
Lighter.type = "Base.Lighter";
Lighter.minCount = 1;
Lighter.maxCount = 1;
Lighter.skill = 1;
local CDplayer = {};
CDplayer.type = "Base.CDplayer";
CDplayer.minCount = 1;
CDplayer.maxCount = 1;
CDplayer.skill = 1;
local Sheet = {};
Sheet.type = "Base.Sheet";
Sheet.minCount = 1;
Sheet.maxCount = 1;
Sheet.skill = 1;
local Padlock = {};
Padlock.type = "Base.Padlock";
Padlock.minCount = 1;
Padlock.maxCount = 1;
Padlock.skill = 1;
local Hairspray = {};
Hairspray.type = "Base.Hairspray";
Hairspray.minCount = 1;
Hairspray.maxCount = 2;
Hairspray.skill = 1;
-- Rank 2 - Medium quality loots
local Torch = {};
Torch.type = "Base.Torch";
Torch.minCount = 1;
Torch.maxCount = 1;
Torch.skill = 2;
local Aluminum = {};
Aluminum.type = "Base.Aluminum";
Aluminum.minCount = 1;
Aluminum.maxCount = 2;
Aluminum.skill = 2;
local Glue = {};
Glue.type = "Base.Glue";
Glue.minCount = 1;
Glue.maxCount = 1;
Glue.skill = 2;
local Pipe = {};
Pipe.type = "Base.Pipe";
Pipe.minCount = 1;
Pipe.maxCount = 2;
Pipe.skill = 2;
local Pillow = {};
Pillow.type = "Base.Pillow";
Pillow.minCount = 1;
Pillow.maxCount = 2;
Pillow.skill = 2;
-- Rank 3 - Medium+ quality loots
local Bleach = {};
Bleach.type = "Base.Bleach";
Bleach.minCount = 1;
Bleach.maxCount = 1;
Bleach.skill = 3;
local AlarmClock = {};
AlarmClock.type = "Base.AlarmClock";
AlarmClock.minCount = 1;
AlarmClock.maxCount = 1;
AlarmClock.skill = 3;
local Schoolbag = {};
Schoolbag.type = "Base.Schoolbag";
Schoolbag.minCount = 1;
Schoolbag.maxCount = 1;
Schoolbag.skill = 3;
local Cologne = {};
Cologne.type = "Base.Cologne";
Cologne.minCount = 1;
Cologne.maxCount = 1;
Cologne.skill = 3;
-- Rank 4 - Good Quality loots & literature
local DigitalWatch = {};
DigitalWatch.type = "Base.DigitalWatch";
DigitalWatch.minCount = 1;
DigitalWatch.maxCount = 1;
DigitalWatch.skill = 4;
local Speaker = {};
Speaker.type = "Base.Speaker";
Speaker.minCount = 1;
Speaker.maxCount = 2;
Speaker.skill = 4;
local Sparklers = {};
Sparklers.type = "Base.Sparklers";
Sparklers.minCount = 1;
Sparklers.maxCount = 2;
Sparklers.skill = 4;
local DuctTape = {};
DuctTape.type = "Base.DuctTape";
DuctTape.minCount = 1;
DuctTape.maxCount = 1;
DuctTape.skill = 4;
local ElectronicsMag4 = {};
ElectronicsMag4.type = "Base.ElectronicsMag4";
ElectronicsMag4.minCount = 1;
ElectronicsMag4.maxCount = 1;
ElectronicsMag4.skill = 4;
local BucketEmpty = {};
BucketEmpty.type = "Base.BucketEmpty";
BucketEmpty.minCount = 1;
BucketEmpty.maxCount = 1;
BucketEmpty.skill = 4;
-- Rank 5 - Traping & cooking literature
local HuntingMag1 = {};
HuntingMag1.type = "Base.HuntingMag1";
HuntingMag1.minCount = 1;
HuntingMag1.maxCount = 1;
HuntingMag1.skill = 5;
local HuntingMag2 = {};
HuntingMag2.type = "Base.HuntingMag2";
HuntingMag2.minCount = 1;
HuntingMag2.maxCount = 1;
HuntingMag2.skill = 5;
local HuntingMag3 = {};
HuntingMag3.type = "Base.HuntingMag3";
HuntingMag3.minCount = 1;
HuntingMag3.maxCount = 1;
HuntingMag3.skill = 5;
local CookingMag2 = {};
CookingMag2.type = "Base.CookingMag2";
CookingMag2.minCount = 1;
CookingMag2.maxCount = 1;
CookingMag2.skill = 5;
-- Rank 6 - Usefull loots
local Extinguisher = {};
Extinguisher.type = "Base.Extinguisher";
Extinguisher.minCount = 1;
Extinguisher.maxCount = 1;
Extinguisher.skill = 6;
local Woodglue = {};
Woodglue.type = "Base.Woodglue";
Woodglue.minCount = 1;
Woodglue.maxCount = 2;
Woodglue.skill = 6;
local HomeAlarm = {};
HomeAlarm.type = "Base.HomeAlarm";
HomeAlarm.minCount = 1;
HomeAlarm.maxCount = 1;
HomeAlarm.skill = 6;
-- Rank 7 - Fertilizer
local Fertilizer = {};
Fertilizer.type = "Base.Fertilizer";
Fertilizer.minCount = 1;
Fertilizer.maxCount = 2;
Fertilizer.skill = 7;
-- Rank 10 - Spiffo :D
local Spiffo = {};
Spiffo.type = "Base.Spiffo";
Spiffo.minCount = 1;
Spiffo.maxCount = 1;
Spiffo.skill = 10;

table.insert(scavenges.berries, Dice);
table.insert(scavenges.berries, CardDeck);
table.insert(scavenges.berries, Earbuds);
table.insert(scavenges.berries, ToyBear);
table.insert(scavenges.berries, Garbagebag);
table.insert(scavenges.berries, Matches);
table.insert(scavenges.berries, Newspaper);
table.insert(scavenges.berries, Scotchtape);
table.insert(scavenges.berries, Paperclip);
table.insert(scavenges.berries, Lighter);
table.insert(scavenges.berries, CDplayer);
table.insert(scavenges.berries, Sheet);
table.insert(scavenges.berries, Padlock);
table.insert(scavenges.berries, Hairspray);
table.insert(scavenges.berries, Torch);
table.insert(scavenges.berries, Aluminum);
table.insert(scavenges.berries, Glue);
table.insert(scavenges.berries, Pipe);
table.insert(scavenges.berries, Pillow);
table.insert(scavenges.berries, Bleach);
table.insert(scavenges.berries, AlarmClock);
table.insert(scavenges.berries, Schoolbag);
table.insert(scavenges.berries, Cologne);
table.insert(scavenges.berries, DigitalWatch);
table.insert(scavenges.berries, Speaker);
table.insert(scavenges.berries, Sparklers);
table.insert(scavenges.berries, DuctTape);
table.insert(scavenges.berries, ElectronicsMag4);
table.insert(scavenges.berries, BucketEmpty);
table.insert(scavenges.berries, HuntingMag1);
table.insert(scavenges.berries, HuntingMag2);
table.insert(scavenges.berries, HuntingMag3);
table.insert(scavenges.berries, CookingMag2);
table.insert(scavenges.berries, Extinguisher);
table.insert(scavenges.berries, Woodglue);
table.insert(scavenges.berries, HomeAlarm);
table.insert(scavenges.berries, Fertilizer);
table.insert(scavenges.berries, Spiffo);

-- Resources are stored in "ForestGoods" table
-- Rank 0 - low uses stuff like stones or twigs
local TreeBranch = {};
TreeBranch.type = "Base.TreeBranch";
TreeBranch.minCount = 1;
TreeBranch.maxCount = 2;
TreeBranch.skill = 0;
local SharpedStone = {};
SharpedStone.type = "Base.SharpedStone";
SharpedStone.minCount = 1;
SharpedStone.maxCount = 2;
SharpedStone.skill = 0;
local Stone = {};
Stone.type = "Base.Stone";
Stone.minCount = 1;
Stone.maxCount = 1;
Stone.skill = 0;
local Twigs = {};
Twigs.type = "Base.Twigs";
Twigs.minCount = 1;
Twigs.maxCount = 3;
Twigs.skill = 0;
-- Rank 1 - Basic scraps materials
local Nails = {};
Nails.type = "Base.Nails";
Nails.minCount = 2;
Nails.maxCount = 6;
Nails.skill = 1;
local ScrapMetal = {};
ScrapMetal.type = "Base.ScrapMetal";
ScrapMetal.minCount = 1;
ScrapMetal.maxCount = 5;
ScrapMetal.skill = 1;
local Twine = {};
Twine.type = "Base.Twine";
Twine.minCount = 1;
Twine.maxCount = 1;
Twine.skill = 1;
-- Rank 2 - Base for basic crafts
local Hinge = {};
Hinge.type = "Base.Hinge";
Hinge.minCount = 1;
Hinge.maxCount = 2;
Hinge.skill = 2;
local Doorknob = {};
Doorknob.type = "Base.Doorknob";
Doorknob.minCount = 1;
Doorknob.maxCount = 1;
Doorknob.skill = 2;
local Rope = {};
Rope.type = "Base.Rope";
Rope.minCount = 1;
Rope.maxCount = 1;
Rope.skill = 2;
local Plank = {};
Plank.type = "Base.Plank";
Plank.minCount = 1;
Plank.maxCount = 2;
Plank.skill = 2;
-- Rank 3 - Base for metal crafts
local Wire = {};
Wire.type = "Base.Wire";
Wire.minCount = 1;
Wire.maxCount = 1;
Wire.skill = 3;
local WeldingRods = {};
WeldingRods.type = "Base.WeldingRods";
WeldingRods.minCount = 1;
WeldingRods.maxCount = 3;
WeldingRods.skill = 3;
local MetalPipe = {};
MetalPipe.type = "Base.MetalPipe";
MetalPipe.minCount = 1;
MetalPipe.maxCount = 1;
MetalPipe.skill = 3;
-- Rank 4 - More metal stuff
local BarbedWire = {};
BarbedWire.type = "Base.BarbedWire";
BarbedWire.minCount = 1;
BarbedWire.maxCount = 1;
BarbedWire.skill = 4;
local MetalBar = {};
MetalBar.type = "Base.MetalBar";
MetalBar.minCount = 1;
MetalBar.maxCount = 1;
MetalBar.skill = 4;
-- Rank 5 - Nails overload
local NailsBox = {};
NailsBox.type = "Base.NailsBox";
NailsBox.minCount = 1;
NailsBox.maxCount = 1;
NailsBox.skill = 5;
-- Rank 6 - Lod and metal sheet
local Log = {};
Log.type = "Base.Log";
Log.minCount = 1;
Log.maxCount = 1;
Log.skill = 6;
local SheetMetal = {};
SheetMetal.type = "Base.SheetMetal";
SheetMetal.minCount = 1;
SheetMetal.maxCount = 1;
SheetMetal.skill = 6;
-- Rank 7 - Powders & log
local ConcretePowder = {};
ConcretePowder.type = "Base.ConcretePowder";
ConcretePowder.minCount = 1;
ConcretePowder.maxCount = 1;
ConcretePowder.skill = 7;
local ConcretePowder = {};
ConcretePowder.type = "Base.ConcretePowder";
ConcretePowder.minCount = 1;
ConcretePowder.maxCount = 1;
ConcretePowder.skill = 7;
-- Rank 9 - Fuels
local PetrolCan = {};
PetrolCan.type = "Base.PetrolCan";
PetrolCan.minCount = 1;
PetrolCan.maxCount = 1;
PetrolCan.skill = 9;
local PropaneTank = {};
PropaneTank.type = "Base.PropaneTank";
PropaneTank.minCount = 1;
PropaneTank.maxCount = 1;
PropaneTank.skill = 9;

table.insert(scavenges.forestGoods, TreeBranch);
table.insert(scavenges.forestGoods, SharpedStone);
table.insert(scavenges.forestGoods, Stone);
table.insert(scavenges.forestGoods, Twigs);
table.insert(scavenges.forestGoods, Nails);
table.insert(scavenges.forestGoods, ScrapMetal);
table.insert(scavenges.forestGoods, Twine);
table.insert(scavenges.forestGoods, Hinge);
table.insert(scavenges.forestGoods, Doorknob);
table.insert(scavenges.forestGoods, Rope);
table.insert(scavenges.forestGoods, Plank);
table.insert(scavenges.forestGoods, Wire);
table.insert(scavenges.forestGoods, WeldingRods);
table.insert(scavenges.forestGoods, MetalPipe);
table.insert(scavenges.forestGoods, BarbedWire);
table.insert(scavenges.forestGoods, MetalBar);
table.insert(scavenges.forestGoods, NailsBox);
table.insert(scavenges.forestGoods, Log);
table.insert(scavenges.forestGoods, SheetMetal);
table.insert(scavenges.forestGoods, ConcretePowder);
table.insert(scavenges.forestGoods, ConcretePowder);
table.insert(scavenges.forestGoods, PetrolCan);
table.insert(scavenges.forestGoods, PropaneTank);

-- Weapons & tools are stored in "Mushrooms" table
-- Rank 0 - Poor quality weapons & low usage tool
local Paintbrush = {};
Paintbrush.type = "Base.Paintbrush";
Paintbrush.minCount = 1;
Paintbrush.maxCount = 1;
Paintbrush.skill = 0;
local Spoon = {};
Spoon.type = "Base.Spoon";
Spoon.minCount = 1;
Spoon.maxCount = 2;
Spoon.skill = 0;
local Pen = {};
Pen.type = "Base.Pen";
Pen.minCount = 1;
Pen.maxCount = 1;
Pen.skill = 0;
local Pencil = {};
Pencil.type = "Base.Pencil";
Pencil.minCount = 1;
Pencil.maxCount = 2;
Pencil.skill = 0;
local Fork = {};
Fork.type = "Base.Fork";
Fork.minCount = 1;
Fork.maxCount = 1;
Fork.skill = 0;
-- Rank 1 - Still bad quality weapon but better
local Scissors = {};
Scissors.type = "Base.Scissors";
Scissors.minCount = 1;
Scissors.maxCount = 1;
Scissors.skill = 1;
local RollingPin = {};
RollingPin.type = "Base.RollingPin";
RollingPin.minCount = 1;
RollingPin.maxCount = 1;
RollingPin.skill = 1;
local ButterKnife = {};
ButterKnife.type = "Base.ButterKnife";
ButterKnife.minCount = 1;
ButterKnife.maxCount = 1;
ButterKnife.skill = 1;
-- Rank 2 - Pistol & Cooking stuff
local IronSight = {};
IronSight.type = "Base.IronSight";
IronSight.minCount = 1;
IronSight.maxCount = 1;
IronSight.skill = 2;
local Laser = {};
Laser.type = "Base.Laser";
Laser.minCount = 1;
Laser.maxCount = 1;
Laser.skill = 2;
local RedDot = {};
RedDot.type = "Base.RedDot";
RedDot.minCount = 1;
RedDot.maxCount = 1;
RedDot.skill = 2;
local Pan = {};
Pan.type = "Base.Pan";
Pan.minCount = 1;
Pan.maxCount = 1;
Pan.skill = 2;
local Bullets9mm = {};
Bullets9mm.type = "Base.Bullets9mm";
Bullets9mm.minCount = 1;
Bullets9mm.maxCount = 5;
Bullets9mm.skill = 2;
-- Rank 3 - Electronics + Cooking tools & Medium blunt weapon
local Screwdriver = {};
Screwdriver.type = "Base.Screwdriver";
Screwdriver.minCount = 1;
Screwdriver.maxCount = 1;
Screwdriver.skill = 3;
local Poolcue = {};
Poolcue.type = "Base.Poolcue";
Poolcue.minCount = 1;
Poolcue.maxCount = 1;
Poolcue.skill = 3;
local KitchenKnife = {};
KitchenKnife.type = "Base.KitchenKnife";
KitchenKnife.minCount = 1;
KitchenKnife.maxCount = 1;
KitchenKnife.skill = 3;
local PlankNail = {};
PlankNail.type = "Base.PlankNail";
PlankNail.minCount = 1;
PlankNail.maxCount = 1;
PlankNail.skill = 3;
-- Rank 4 - Basic tools for metalurgy and carpentry
local BlowTorch = {};
BlowTorch.type = "Base.BlowTorch";
BlowTorch.minCount = 1;
BlowTorch.maxCount = 1;
BlowTorch.skill = 4;
local WeldingMask = {};
WeldingMask.type = "Base.WeldingMask";
WeldingMask.minCount = 1;
WeldingMask.maxCount = 1;
WeldingMask.skill = 4;
local Hammer = {};
Hammer.type = "Base.Hammer";
Hammer.minCount = 1;
Hammer.maxCount = 1;
Hammer.skill = 4;
-- Rank 5 - Metal warfare & tool 
local Crowbar = {};
Crowbar.type = "Base.Crowbar";
Crowbar.minCount = 1;
Crowbar.maxCount = 1;
Crowbar.skill = 5;
local Golfclub = {};
Golfclub.type = "Base.Golfclub";
Golfclub.minCount = 1;
Golfclub.maxCount = 1;
Golfclub.skill = 5;
local HuntingKnife = {};
HuntingKnife.type = "Base.HuntingKnife";
HuntingKnife.minCount = 1;
HuntingKnife.maxCount = 1;
HuntingKnife.skill = 5;
local Saw = {};
Saw.type = "Base.Saw";
Saw.minCount = 1;
Saw.maxCount = 1;
Saw.skill = 5;
local ChokeTubeImproved = {};
ChokeTubeImproved.type = "Base.ChokeTubeImproved";
ChokeTubeImproved.minCount = 1;
ChokeTubeImproved.maxCount = 1;
ChokeTubeImproved.skill = 5;
-- Rank 6 - Axe & Gunpower
local Axe = {};
Axe.type = "Base.Axe";
Axe.minCount = 1;
Axe.maxCount = 1;
Axe.skill = 6;
local Pistol = {};
Pistol.type = "Base.Pistol";
Pistol.minCount = 1;
Pistol.maxCount = 1;
Pistol.skill = 6;
local ShotgunShells = {};
ShotgunShells.type = "Base.ShotgunShells";
ShotgunShells.minCount = 1;
ShotgunShells.maxCount = 5;
ShotgunShells.skill = 6;
local TwoHundredBullets = {};
TwoHundredBullets.type = "Base.223Bullets";
TwoHundredBullets.minCount = 1;
TwoHundredBullets.maxCount = 5;
TwoHundredBullets.skill = 6;
local ThreeHundredBullets = {};
ThreeHundredBullets.type = "Base.308Bullets";
ThreeHundredBullets.minCount = 1;
ThreeHundredBullets.maxCount = 5;
ThreeHundredBullets.skill = 6;
local ChokeTubeFull = {};
ChokeTubeFull.type = "Base.ChokeTubeFull";
ChokeTubeFull.minCount = 1;
ChokeTubeFull.maxCount = 1;
ChokeTubeFull.skill = 6;
-- Rank 7 - High end weapons & Guns upgrades
local Sledgehammer = {};
Sledgehammer.type = "Base.Sledgehammer";
Sledgehammer.minCount = 1;
Sledgehammer.maxCount = 1;
Sledgehammer.skill = 7;
local BaseballBatNails = {};
BaseballBatNails.type = "Base.BaseballBatNails";
BaseballBatNails.minCount = 1;
BaseballBatNails.maxCount = 1;
BaseballBatNails.skill = 7;
local Shovel = {};
Shovel.type = "Base.Shovel";
Shovel.minCount = 1;
Shovel.maxCount = 1;
Shovel.skill = 7;
local x2Scope = {};
x2Scope.type = "Base.x2Scope";
x2Scope.minCount = 1;
x2Scope.maxCount = 1;
x2Scope.skill = 7;
local RecoilPad = {};
RecoilPad.type = "Base.RecoilPad";
RecoilPad.minCount = 1;
RecoilPad.maxCount = 1;
RecoilPad.skill = 7;
local x4Scope = {};
x4Scope.type = "Base.x4Scope";
x4Scope.minCount = 1;
x4Scope.maxCount = 1;
x4Scope.skill = 7;
-- Rank 8 - Shotgun'n Straps
local Shotgun = {};
Shotgun.type = "Base.Shotgun";
Shotgun.minCount = 1;
Shotgun.maxCount = 1;
Shotgun.skill = 8;
local AmmoStraps = {};
AmmoStraps.type = "Base.AmmoStraps";
AmmoStraps.minCount = 1;
AmmoStraps.maxCount = 1;
AmmoStraps.skill = 8;
local Sling = {};
Sling.type = "Base.Sling";
Sling.minCount = 1;
Sling.maxCount = 1;
Sling.skill = 8;
local x8Scope = {};
x8Scope.type = "Base.x8Scope";
x8Scope.minCount = 1;
x8Scope.maxCount = 1;
x8Scope.skill = 8;
-- Rank 9 - Epic Rifles & Upgrades
local HuntingRifle = {};
HuntingRifle.type = "Base.HuntingRifle";
HuntingRifle.minCount = 1;
HuntingRifle.maxCount = 1;
HuntingRifle.skill = 9;
local VarmintRifle = {};
VarmintRifle.type = "Base.VarmintRifle";
VarmintRifle.minCount = 1;
VarmintRifle.maxCount = 1;
VarmintRifle.skill = 9;
local FiberglassStock = {};
FiberglassStock.type = "Base.FiberglassStock";
FiberglassStock.minCount = 1;
FiberglassStock.maxCount = 1;
FiberglassStock.skill = 9;

table.insert(scavenges.mushrooms, Paintbrush);
table.insert(scavenges.mushrooms, Spoon);
table.insert(scavenges.mushrooms, Pen);
table.insert(scavenges.mushrooms, Pencil);
table.insert(scavenges.mushrooms, Fork);
table.insert(scavenges.mushrooms, Scissors);
table.insert(scavenges.mushrooms, RollingPin);
table.insert(scavenges.mushrooms, ButterKnife);
table.insert(scavenges.mushrooms, IronSight);
table.insert(scavenges.mushrooms, Laser);
table.insert(scavenges.mushrooms, RedDot);
table.insert(scavenges.mushrooms, Pan);
table.insert(scavenges.mushrooms, Bullets9mm);
table.insert(scavenges.mushrooms, Screwdriver);
table.insert(scavenges.mushrooms, Poolcue);
table.insert(scavenges.mushrooms, KitchenKnife);
table.insert(scavenges.mushrooms, PlankNail);
table.insert(scavenges.mushrooms, BlowTorch);
table.insert(scavenges.mushrooms, WeldingMask);
table.insert(scavenges.mushrooms, Hammer);
table.insert(scavenges.mushrooms, Crowbar);
table.insert(scavenges.mushrooms, Golfclub);
table.insert(scavenges.mushrooms, HuntingKnife);
table.insert(scavenges.mushrooms, Saw);
table.insert(scavenges.mushrooms, ChokeTubeImproved);
table.insert(scavenges.mushrooms, Axe);
table.insert(scavenges.mushrooms, Pistol);
table.insert(scavenges.mushrooms, ShotgunShells);
table.insert(scavenges.mushrooms, TwoHundredBullets);
table.insert(scavenges.mushrooms, ThreeHundredBullets);
table.insert(scavenges.mushrooms, ChokeTubeFull);
table.insert(scavenges.mushrooms, Sledgehammer);
table.insert(scavenges.mushrooms, BaseballBatNails);
table.insert(scavenges.mushrooms, Shovel);
table.insert(scavenges.mushrooms, x2Scope);
table.insert(scavenges.mushrooms, RecoilPad);
table.insert(scavenges.mushrooms, x4Scope);
table.insert(scavenges.mushrooms, Shotgun);
table.insert(scavenges.mushrooms, AmmoStraps);
table.insert(scavenges.mushrooms, Sling);
table.insert(scavenges.mushrooms, x8Scope);
table.insert(scavenges.mushrooms, HuntingRifle);
table.insert(scavenges.mushrooms, VarmintRifle);
table.insert(scavenges.mushrooms, FiberglassStock);

local check = function()
    -- Kahlua gives an error if this loop is placed outside this function.
    for k,v in ipairs(scavenges.berries) do
	local item = ScriptManager.instance:FindItem(v.type)
	if not item then print("ScavengDefinitions: no such item "..v.type) end
    end
end
check()
