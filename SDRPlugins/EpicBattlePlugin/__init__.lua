debuggingMode = false;

-- Check and load the LanguageData (Note: Searchstrings and Names should be changed there)
GLocale = Turbine.Engine.GetLanguage();
if GLocale == 268435460 then 
	GLocale = "de";
	import "SDRPlugins.EpicBattlePlugin.Language_de";
elseif GLocale == 268435459 then
	GLocale = "fr";
	import "SDRPlugins.EpicBattlePlugin.Language_fr";
--  elseif GLocale == 268435463 then GLocale = "ru";
else
	GLocale = "en";
	import "SDRPlugins.EpicBattlePlugin.Language_en";
end

import "SDRPlugins.EpicBattlePlugin.Class";
import "SDRPlugins.EpicBattlePlugin.TrapObject";
import "SDRPlugins.EpicBattlePlugin.VindarPatch";

-- stores the information on each Epic Battle space, using basically the following format:
--EpicBattleData = {}
--EpicBattleData["Name of instance - size"] = {}
--EpicBattleData["Name of instance - size"].waves = the number of waves this instance has
--EpicBattleData["Name of instance - size"].sides = {} -- will hold the sides this space has
--EpicBattleData["Name of instance - size"].sides["SideName"] = {} -- for instance, Eastern, or Glittering Caves, or Only
--EpicBattleData["Name of instance - size"].sides["SideName"].wave = {} -- will store the information for each wave of the instance
--EpicBattleData["Name of instance - size"].sides["SideName"].wave[1] = {} -- indicates wave 1 on this side
--EpicBattleData["Name of instance - size"].sides["SideName"].wave[1].killTimeRatio; -- will store the ratio of kills/second before the side quest starts
--EpicBattleData["Name of instance - size"].sides["SideName"].wave[1].maxTime -- indicates the max time of this wave (in seconds)
--EpicBattleData["Name of instance - size"].sides["SideName"].wave[1].killCount -- indicates the kill count to get the side quest started
--EpicBattleData["Name of instance - size"].sides["SideName"].wave[1].nextSide -- indicates the next side to be attacked, if known
--EpicBattleData["Name of instance - size"].sides["SideName"].wave[1].delay -- indicates the delay between the wave starting and when the first mobs are killed
--EpicBattleData["Name of instance - size"].sides["SideName"].wave[1][1] = "Quest Name"

--STANDARD_KILL_COUNT = 250; -- default kill count til a side quest starts until a better estimate is known
--STANDARD_MAX_TIME = 600; -- 10 mins seems to be a very good estimate of when a wave will end for HD and DW, will check others
--STANDARD_KILL_TIME_RATIO = 0; -- usually it seems most instances have a kill/time ratio of 0.5 as a basic start
--STANDARD_DELAY = 120; -- most instances have about 2 minutes between wave starting and the mobs arriving

EpicBattleData = {}

-- Information for Helm's Dike Solo
EpicBattleData["Helm's Dike - Solo/Duo"] = {};
EpicBattleData["Helm's Dike - Solo/Duo"].waves = 3;
EpicBattleData["Helm's Dike - Solo/Duo"].sides = {}; -- will hold the sides this space has

EpicBattleData["Helm's Dike - Solo/Duo"].sides["Western"] = {};
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Western"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Western"].wave[1] = {}; -- indicates wave 1 on this side
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Western"].wave[1].killTimeRatio = 0.61;
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Western"].wave[1].maxTime = 650;
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Western"].wave[1].killCount = 109;
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Western"].wave[1].nextSide = "Eastern";
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Western"].wave[1].delay = 89;
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Western"].wave[1][1] = "Stone Obstruction";
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Western"].wave[2] = {}; -- indicates wave 2 on this side
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Western"].wave[2][1] = "Guarding the Watchtower";
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Western"].wave[2].killTimeRatio = 0.61;
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Western"].wave[2].maxTime = 650;
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Western"].wave[2].killCount = 109;
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Western"].wave[2].nextSide = "Centre";
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Western"].wave[2].delay = 89;

EpicBattleData["Helm's Dike - Solo/Duo"].sides["Eastern"] = {};
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Eastern"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Eastern"].wave[1] = {}; -- indicates wave 1 on this side
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Eastern"].wave[1].killTimeRatio = 0.63;
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Eastern"].wave[1][1] = "Protect the Horses";
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Eastern"].wave[1].maxTime = 650;
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Eastern"].wave[1].killCount = 110;
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Eastern"].wave[1].nextSide = "Western";
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Eastern"].wave[1].delay = 96;
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Eastern"].wave[2] = {}; -- indicates wave 2 on this side
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Eastern"].wave[2].killTimeRatio = 0.63;
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Eastern"].wave[2].maxTime = 650;
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Eastern"].wave[2].killCount = 110;
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Eastern"].wave[2].nextSide = "Centre";
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Eastern"].wave[2][1] = "Statue of Helm Hammerhand";
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Eastern"].wave[2].delay = 96;

EpicBattleData["Helm's Dike - Solo/Duo"].sides["Centre"] = {};
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Centre"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Centre"].wave[3] = {}; -- indicates wave 3 on this side
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Centre"].wave[3].killTimeRatio = 0.64;
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Centre"].wave[3].maxTime = 650;
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Centre"].wave[3].killCount = 108;
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Centre"].wave[3][1] = "Powder at the Gate";
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Centre"].wave[3][2] = "Flames at the Gate";
EpicBattleData["Helm's Dike - Solo/Duo"].sides["Centre"].wave[3].delay = 96;

-- Information for Helm's Dike Fellowship
EpicBattleData["Helm's Dike - Fellowship"] = {};
EpicBattleData["Helm's Dike - Fellowship"].waves = 3;
EpicBattleData["Helm's Dike - Fellowship"].sides = {}; -- will hold the sides this space has

EpicBattleData["Helm's Dike - Fellowship"].sides["Western"] = {};
EpicBattleData["Helm's Dike - Fellowship"].sides["Western"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["Helm's Dike - Fellowship"].sides["Western"].wave[1] = {}; -- indicates wave 1 on this side
EpicBattleData["Helm's Dike - Fellowship"].sides["Western"].wave[1].killTimeRatio = 1.05;
EpicBattleData["Helm's Dike - Fellowship"].sides["Western"].wave[1].maxTime = 630;
EpicBattleData["Helm's Dike - Fellowship"].sides["Western"].wave[1].killCount = 160;
EpicBattleData["Helm's Dike - Fellowship"].sides["Western"].wave[1].nextSide = "Eastern";
EpicBattleData["Helm's Dike - Fellowship"].sides["Western"].wave[1].delay = 86;
EpicBattleData["Helm's Dike - Fellowship"].sides["Western"].wave[1][1] = "Stone Obstruction";
EpicBattleData["Helm's Dike - Fellowship"].sides["Western"].wave[2] = {}; -- indicates wave 2 on this side
EpicBattleData["Helm's Dike - Fellowship"].sides["Western"].wave[2].killTimeRatio = 1.05;
EpicBattleData["Helm's Dike - Fellowship"].sides["Western"].wave[2].maxTime = 560;
EpicBattleData["Helm's Dike - Fellowship"].sides["Western"].wave[2].killCount = 160;
EpicBattleData["Helm's Dike - Fellowship"].sides["Western"].wave[2].nextSide = "Centre";
EpicBattleData["Helm's Dike - Fellowship"].sides["Western"].wave[2][1] = "Protect the Horses";
EpicBattleData["Helm's Dike - Fellowship"].sides["Western"].wave[2].delay = 86;

EpicBattleData["Helm's Dike - Fellowship"].sides["Eastern"] = {};
EpicBattleData["Helm's Dike - Fellowship"].sides["Eastern"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["Helm's Dike - Fellowship"].sides["Eastern"].wave[1] = {}; -- indicates wave 1 on this side
EpicBattleData["Helm's Dike - Fellowship"].sides["Eastern"].wave[1].killTimeRatio = 1.01;
EpicBattleData["Helm's Dike - Fellowship"].sides["Eastern"].wave[1].maxTime = 605;
EpicBattleData["Helm's Dike - Fellowship"].sides["Eastern"].wave[1].killCount = 240;
EpicBattleData["Helm's Dike - Fellowship"].sides["Eastern"].wave[1].nextSide = "Western";
EpicBattleData["Helm's Dike - Fellowship"].sides["Eastern"].wave[1].delay = 87;
EpicBattleData["Helm's Dike - Fellowship"].sides["Eastern"].wave[1][1] = "Powder at the Gate";
EpicBattleData["Helm's Dike - Fellowship"].sides["Eastern"].wave[2] = {}; -- indicates wave 2 on this side
EpicBattleData["Helm's Dike - Fellowship"].sides["Eastern"].wave[2].killTimeRatio = 1.01;
EpicBattleData["Helm's Dike - Fellowship"].sides["Eastern"].wave[2].maxTime = 630;
EpicBattleData["Helm's Dike - Fellowship"].sides["Eastern"].wave[2].killCount = 240;
EpicBattleData["Helm's Dike - Fellowship"].sides["Eastern"].wave[2].nextSide = "Centre";
EpicBattleData["Helm's Dike - Fellowship"].sides["Eastern"].wave[2][1] = "Guarding the Watchtowers";
EpicBattleData["Helm's Dike - Fellowship"].sides["Eastern"].wave[2].delay = 87;

EpicBattleData["Helm's Dike - Fellowship"].sides["Centre"] = {};
EpicBattleData["Helm's Dike - Fellowship"].sides["Centre"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["Helm's Dike - Fellowship"].sides["Centre"].wave[3] = {}; -- indicates wave 3 on this side
EpicBattleData["Helm's Dike - Fellowship"].sides["Centre"].wave[3].killTimeRatio = 0.99;
EpicBattleData["Helm's Dike - Fellowship"].sides["Centre"].wave[3].maxTime = 655;
EpicBattleData["Helm's Dike - Fellowship"].sides["Centre"].wave[3].killCount = 152;
EpicBattleData["Helm's Dike - Fellowship"].sides["Centre"].wave[3][1] = "Statue of Helm Hammerhand";
EpicBattleData["Helm's Dike - Fellowship"].sides["Centre"].wave[3][2] = "Flames at the Gate";
EpicBattleData["Helm's Dike - Fellowship"].sides["Centre"].wave[3].delay = 90;

-- Information for Deeping Wall Solo
EpicBattleData["Deeping Wall - Solo/Duo"] = {};
EpicBattleData["Deeping Wall - Solo/Duo"].waves = 2;
EpicBattleData["Deeping Wall - Solo/Duo"].sides = {}; -- will hold the sides this space has

EpicBattleData["Deeping Wall - Solo/Duo"].sides["Only"] = {};
EpicBattleData["Deeping Wall - Solo/Duo"].sides["Only"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["Deeping Wall - Solo/Duo"].sides["Only"].wave[1] = {}; -- indicates wave 1 on this side
EpicBattleData["Deeping Wall - Solo/Duo"].sides["Only"].wave[1].killTimeRatio = 0.89;
EpicBattleData["Deeping Wall - Solo/Duo"].sides["Only"].wave[1].maxTime = 645;
EpicBattleData["Deeping Wall - Solo/Duo"].sides["Only"].wave[1].killCount = 207;
EpicBattleData["Deeping Wall - Solo/Duo"].sides["Only"].wave[1].nextSide = "Only";
EpicBattleData["Deeping Wall - Solo/Duo"].sides["Only"].wave[1].delay = 173;
EpicBattleData["Deeping Wall - Solo/Duo"].sides["Only"].wave[1][1] = "Breaching the Hornburg";
EpicBattleData["Deeping Wall - Solo/Duo"].sides["Only"].wave[1][2] = "Securing the Culvert";
EpicBattleData["Deeping Wall - Solo/Duo"].sides["Only"].wave[2] = {}; -- indicates wave 2 on this side
EpicBattleData["Deeping Wall - Solo/Duo"].sides["Only"].wave[2].killTimeRatio = 1.00;
EpicBattleData["Deeping Wall - Solo/Duo"].sides["Only"].wave[2].maxTime = 655;
EpicBattleData["Deeping Wall - Solo/Duo"].sides["Only"].wave[2].killCount = 221;
EpicBattleData["Deeping Wall - Solo/Duo"].sides["Only"].wave[2][1] = "The Vanguard Defilers";
EpicBattleData["Deeping Wall - Solo/Duo"].sides["Only"].wave[2][2] = "Vandals in the Tower";
EpicBattleData["Deeping Wall - Solo/Duo"].sides["Only"].wave[2].delay = 173;

-- Information for Deeping Wall Raid
EpicBattleData["Deeping Wall - Raid"] = {};
EpicBattleData["Deeping Wall - Raid"].waves = 3;
EpicBattleData["Deeping Wall - Raid"].sides = {}; -- will hold the sides this space has

EpicBattleData["Deeping Wall - Raid"].sides["Western"] = {};
EpicBattleData["Deeping Wall - Raid"].sides["Western"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["Deeping Wall - Raid"].sides["Western"].wave[1] = {}; -- indicates wave 1 on this side
EpicBattleData["Deeping Wall - Raid"].sides["Western"].wave[1].killTimeRatio = 1.07;
EpicBattleData["Deeping Wall - Raid"].sides["Western"].wave[1].maxTime = 680;
EpicBattleData["Deeping Wall - Raid"].sides["Western"].wave[1].killCount = 268;
EpicBattleData["Deeping Wall - Raid"].sides["Western"].wave[1].delay = 172;
EpicBattleData["Deeping Wall - Raid"].sides["Western"].wave[1][1] = "Breaching the Hornburg";
EpicBattleData["Deeping Wall - Raid"].sides["Western"].wave[2] = {}; -- indicates wave 2 on this side
EpicBattleData["Deeping Wall - Raid"].sides["Western"].wave[2].killTimeRatio = 1.07;
EpicBattleData["Deeping Wall - Raid"].sides["Western"].wave[2].maxTime = 680;
EpicBattleData["Deeping Wall - Raid"].sides["Western"].wave[2].killCount = 268;
EpicBattleData["Deeping Wall - Raid"].sides["Western"].wave[2].delay = 172;
EpicBattleData["Deeping Wall - Raid"].sides["Western"].wave[2][1] = "Securing the Culvert";
EpicBattleData["Deeping Wall - Raid"].sides["Western"].wave[3] = {}; -- indicates wave 3 on this side
EpicBattleData["Deeping Wall - Raid"].sides["Western"].wave[3].killTimeRatio = 1.07;
EpicBattleData["Deeping Wall - Raid"].sides["Western"].wave[3].maxTime = 680;
EpicBattleData["Deeping Wall - Raid"].sides["Western"].wave[3].killCount = 268;
EpicBattleData["Deeping Wall - Raid"].sides["Western"].wave[3].delay = 172;
EpicBattleData["Deeping Wall - Raid"].sides["Western"].wave[3][1] = "Shells in the Air";

EpicBattleData["Deeping Wall - Raid"].sides["Eastern"] = {};
EpicBattleData["Deeping Wall - Raid"].sides["Eastern"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["Deeping Wall - Raid"].sides["Eastern"].wave[1] = {}; -- indicates wave 1 on this side
EpicBattleData["Deeping Wall - Raid"].sides["Eastern"].wave[1].killTimeRatio = 0.99;
EpicBattleData["Deeping Wall - Raid"].sides["Eastern"].wave[1].maxTime = 680;
EpicBattleData["Deeping Wall - Raid"].sides["Eastern"].wave[1].killCount = 263;
EpicBattleData["Deeping Wall - Raid"].sides["Eastern"].wave[1].delay = 173;
EpicBattleData["Deeping Wall - Raid"].sides["Eastern"].wave[1][1] = "Assault on the East Tower";
EpicBattleData["Deeping Wall - Raid"].sides["Eastern"].wave[2] = {}; -- indicates wave 2 on this side
EpicBattleData["Deeping Wall - Raid"].sides["Eastern"].wave[2].killTimeRatio = 0.99;
EpicBattleData["Deeping Wall - Raid"].sides["Eastern"].wave[2].maxTime = 680;
EpicBattleData["Deeping Wall - Raid"].sides["Eastern"].wave[2].killCount = 263;
EpicBattleData["Deeping Wall - Raid"].sides["Eastern"].wave[2].delay = 173;
EpicBattleData["Deeping Wall - Raid"].sides["Eastern"].wave[2][1] = "A Flanking Foe";
EpicBattleData["Deeping Wall - Raid"].sides["Eastern"].wave[3] = {}; -- indicates wave 3 on this side
EpicBattleData["Deeping Wall - Raid"].sides["Eastern"].wave[3].killTimeRatio = 0.99;
EpicBattleData["Deeping Wall - Raid"].sides["Eastern"].wave[3].maxTime = 680;
EpicBattleData["Deeping Wall - Raid"].sides["Eastern"].wave[3].killCount = 263;
EpicBattleData["Deeping Wall - Raid"].sides["Eastern"].wave[3].delay = 173;
EpicBattleData["Deeping Wall - Raid"].sides["Eastern"].wave[3][1] = "Bred for Battle";

EpicBattleData["Deeping Wall - Raid"].sides["Centre"] = {};
EpicBattleData["Deeping Wall - Raid"].sides["Centre"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["Deeping Wall - Raid"].sides["Centre"].wave[1] = {}; -- indicates wave 1 on this side
EpicBattleData["Deeping Wall - Raid"].sides["Centre"].wave[1].killTimeRatio = 1.73;
EpicBattleData["Deeping Wall - Raid"].sides["Centre"].wave[1].maxTime = 680;
EpicBattleData["Deeping Wall - Raid"].sides["Centre"].wave[1].killCount = 414;
EpicBattleData["Deeping Wall - Raid"].sides["Centre"].wave[1].delay = 175;
EpicBattleData["Deeping Wall - Raid"].sides["Centre"].wave[1][1] = "Vandals in the Tower";
EpicBattleData["Deeping Wall - Raid"].sides["Centre"].wave[2] = {}; -- indicates wave 2 on this side
EpicBattleData["Deeping Wall - Raid"].sides["Centre"].wave[2].killTimeRatio = 1.73;
EpicBattleData["Deeping Wall - Raid"].sides["Centre"].wave[2].maxTime = 680;
EpicBattleData["Deeping Wall - Raid"].sides["Centre"].wave[2].killCount = 414;
EpicBattleData["Deeping Wall - Raid"].sides["Centre"].wave[2].delay = 175;
EpicBattleData["Deeping Wall - Raid"].sides["Centre"].wave[2][1] = "Siege Under Fire";
EpicBattleData["Deeping Wall - Raid"].sides["Centre"].wave[3] = {}; -- indicates wave 3 on this side
EpicBattleData["Deeping Wall - Raid"].sides["Centre"].wave[3].killTimeRatio = 1.73;
EpicBattleData["Deeping Wall - Raid"].sides["Centre"].wave[3].maxTime = 680;
EpicBattleData["Deeping Wall - Raid"].sides["Centre"].wave[3].killCount = 414;
EpicBattleData["Deeping Wall - Raid"].sides["Centre"].wave[3].delay = 175;
EpicBattleData["Deeping Wall - Raid"].sides["Centre"].wave[3][1] = "The Vanguard Defilers";

-- Information for Deeping-coomb Solo
EpicBattleData["The Deeping-coomb - Solo/Duo"] = {};
EpicBattleData["The Deeping-coomb - Solo/Duo"].waves = 2;
EpicBattleData["The Deeping-coomb - Solo/Duo"].sides = {}; -- will hold the sides this space has

EpicBattleData["The Deeping-coomb - Solo/Duo"].sides["Glittering Caves"] = {};
EpicBattleData["The Deeping-coomb - Solo/Duo"].sides["Glittering Caves"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["The Deeping-coomb - Solo/Duo"].sides["Glittering Caves"].wave[1] = {}; -- indicates wave 1 on this side
EpicBattleData["The Deeping-coomb - Solo/Duo"].sides["Glittering Caves"].wave[1].killTimeRatio = 0.53;
EpicBattleData["The Deeping-coomb - Solo/Duo"].sides["Glittering Caves"].wave[1].maxTime = 780;
EpicBattleData["The Deeping-coomb - Solo/Duo"].sides["Glittering Caves"].wave[1].killCount = 103;
EpicBattleData["The Deeping-coomb - Solo/Duo"].sides["Glittering Caves"].wave[1].nextSide = "Hornburg";
EpicBattleData["The Deeping-coomb - Solo/Duo"].sides["Glittering Caves"].wave[1].delay = 80;
EpicBattleData["The Deeping-coomb - Solo/Duo"].sides["Glittering Caves"].wave[1][1] = "Searching the Debris";
EpicBattleData["The Deeping-coomb - Solo/Duo"].sides["Glittering Caves"].wave[2] = {}; -- indicates wave 2 on this side
EpicBattleData["The Deeping-coomb - Solo/Duo"].sides["Glittering Caves"].wave[2].killTimeRatio = 0.53;
EpicBattleData["The Deeping-coomb - Solo/Duo"].sides["Glittering Caves"].wave[2].maxTime = 780;
EpicBattleData["The Deeping-coomb - Solo/Duo"].sides["Glittering Caves"].wave[2].killCount = 103;
EpicBattleData["The Deeping-coomb - Solo/Duo"].sides["Glittering Caves"].wave[2].delay = 80;
EpicBattleData["The Deeping-coomb - Solo/Duo"].sides["Glittering Caves"].wave[2][1] = "Defilers in the Water";

EpicBattleData["The Deeping-coomb - Solo/Duo"].sides["Hornburg"] = {};
EpicBattleData["The Deeping-coomb - Solo/Duo"].sides["Hornburg"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["The Deeping-coomb - Solo/Duo"].sides["Hornburg"].wave[1] = {}; -- indicates wave 1 on this side
EpicBattleData["The Deeping-coomb - Solo/Duo"].sides["Hornburg"].wave[1].killTimeRatio = 0.49;
EpicBattleData["The Deeping-coomb - Solo/Duo"].sides["Hornburg"].wave[1].maxTime = 780;
EpicBattleData["The Deeping-coomb - Solo/Duo"].sides["Hornburg"].wave[1].killCount = 105;
EpicBattleData["The Deeping-coomb - Solo/Duo"].sides["Hornburg"].wave[1].delay = 73;
EpicBattleData["The Deeping-coomb - Solo/Duo"].sides["Hornburg"].wave[1].nextSide = "Glittering Caves";
EpicBattleData["The Deeping-coomb - Solo/Duo"].sides["Hornburg"].wave[1][1] = "A Pillage Denied";
EpicBattleData["The Deeping-coomb - Solo/Duo"].sides["Hornburg"].wave[2] = {}; -- indicates wave 2 on this side
EpicBattleData["The Deeping-coomb - Solo/Duo"].sides["Hornburg"].wave[2].killTimeRatio = 0.49;
EpicBattleData["The Deeping-coomb - Solo/Duo"].sides["Hornburg"].wave[2].maxTime = 780;
EpicBattleData["The Deeping-coomb - Solo/Duo"].sides["Hornburg"].wave[2].killCount = 105;
EpicBattleData["The Deeping-coomb - Solo/Duo"].sides["Hornburg"].wave[2].delay = 73;
EpicBattleData["The Deeping-coomb - Solo/Duo"].sides["Hornburg"].wave[2][1] = "Prepare to Fall Back";

-- Information for Glittering Caves Solo
EpicBattleData["Glittering Caves - Solo/Duo"] = {};
EpicBattleData["Glittering Caves - Solo/Duo"].waves = 3;
EpicBattleData["Glittering Caves - Solo/Duo"].sides = {}; -- will hold the sides this space has

EpicBattleData["Glittering Caves - Solo/Duo"].sides["Western"] = {};
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Western"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Western"].wave[1] = {}; -- indicates wave 1 on this side
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Western"].wave[1].killTimeRatio = 0.51;
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Western"].wave[1].maxTime = 580;
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Western"].wave[1].killCount = 72;
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Western"].wave[1].nextSide = "Eastern";
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Western"].wave[1].delay = 206;
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Western"].wave[1][1] = "Stalactites Over the Bridge";
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Western"].wave[2] = {}; -- indicates wave 2 on this side
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Western"].wave[2].killTimeRatio = 0.51;
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Western"].wave[2].maxTime = 580;
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Western"].wave[2].killCount = 72;
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Western"].wave[2].nextSide = "Centre";
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Western"].wave[2].delay = 206;
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Western"].wave[2][1] = "Bombs and Bats";

EpicBattleData["Glittering Caves - Solo/Duo"].sides["Eastern"] = {};
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Eastern"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Eastern"].wave[1] = {}; -- indicates wave 1 on this side
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Eastern"].wave[1].killTimeRatio = 0.47;
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Eastern"].wave[1].maxTime = 490;
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Eastern"].wave[1].killCount = 93;
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Eastern"].wave[1].nextSide = "Western";
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Eastern"].wave[1].delay = 89;
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Eastern"].wave[1][1] = "Cave In";
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Eastern"].wave[2] = {}; -- indicates wave 2 on this side
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Eastern"].wave[2].killTimeRatio = 0.47;
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Eastern"].wave[2].maxTime = 490;
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Eastern"].wave[2].killCount = 93;
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Eastern"].wave[2].delay = 89;
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Eastern"].wave[2].nextSide = "Centre";
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Eastern"].wave[2][1] = "Spider Assault";

EpicBattleData["Glittering Caves - Solo/Duo"].sides["Centre"] = {};
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Centre"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Centre"].wave[3] = {}; -- indicates wave 3 on this side
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Centre"].wave[3].killTimeRatio = 0.54;
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Centre"].wave[3].maxTime = 700;
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Centre"].wave[3].killCount = 70;
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Centre"].wave[3].delay = 50;
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Centre"].wave[3][1] = "Civilian Defence";
EpicBattleData["Glittering Caves - Solo/Duo"].sides["Centre"].wave[3][2] = "Preparing the Charge";

-- Information for Glittering Caves Small Fellowship
EpicBattleData["Glittering Caves - Small Fellowship"] = {};
EpicBattleData["Glittering Caves - Small Fellowship"].waves = 3;
EpicBattleData["Glittering Caves - Small Fellowship"].sides = {}; -- will hold the sides this space has

EpicBattleData["Glittering Caves - Small Fellowship"].sides["Western"] = {};
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Western"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Western"].wave[1] = {}; -- indicates wave 1 on this side
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Western"].wave[1].killTimeRatio = 0.53;
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Western"].wave[1].maxTime = 560;
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Western"].wave[1].killCount = 32;
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Western"].wave[1].nextSide = "Eastern";
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Western"].wave[1].delay = 206;
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Western"].wave[1][1] = "Stalactites Over the Bridge";
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Western"].wave[2] = {}; -- indicates wave 2 on this side
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Western"].wave[2].killTimeRatio = 0.53;
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Western"].wave[2].maxTime = 560;
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Western"].wave[2].killCount = 32;
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Western"].wave[2].delay = 206;
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Western"].wave[2].nextSide = "Centre";
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Western"].wave[2][1] = "Bombs and Bats";

EpicBattleData["Glittering Caves - Small Fellowship"].sides["Eastern"] = {};
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Eastern"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Eastern"].wave[1] = {}; -- indicates wave 1 on this side
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Eastern"].wave[1].killTimeRatio = 0.45;
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Eastern"].wave[1].maxTime = 575;
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Eastern"].wave[1].killCount = 48;
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Eastern"].wave[1].nextSide = "Western";
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Eastern"].wave[1].delay = 89;
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Eastern"].wave[1][1] = "Cave In";
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Eastern"].wave[2] = {}; -- indicates wave 2 on this side
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Eastern"].wave[2].killTimeRatio = 0.45;
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Eastern"].wave[2].maxTime = 575;
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Eastern"].wave[2].killCount = 48;
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Eastern"].wave[2].delay = 89;
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Eastern"].wave[2].nextSide = "Centre";
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Eastern"].wave[2][1] = "Spider Assault";

EpicBattleData["Glittering Caves - Small Fellowship"].sides["Centre"] = {};
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Centre"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Centre"].wave[3] = {}; -- indicates wave 3 on this side
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Centre"].wave[3].killTimeRatio = 0.59;
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Centre"].wave[3].maxTime = 650;
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Centre"].wave[3].killCount = 30;
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Centre"].wave[3].delay = 48;
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Centre"].wave[3][1] = "Civilian Defence";
EpicBattleData["Glittering Caves - Small Fellowship"].sides["Centre"].wave[3][2] = "Preparing the Charge";

-- Information for The Horburg Solo
EpicBattleData["The Hornburg - Solo/Duo"] = {};
EpicBattleData["The Hornburg - Solo/Duo"].waves = 2;
EpicBattleData["The Hornburg - Solo/Duo"].sides = {}; -- will hold the sides this space has

EpicBattleData["The Hornburg - Solo/Duo"].sides["Only"] = {};
EpicBattleData["The Hornburg - Solo/Duo"].sides["Only"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["The Hornburg - Solo/Duo"].sides["Only"].wave[1] = {}; -- indicates wave 1 on this side
EpicBattleData["The Hornburg - Solo/Duo"].sides["Only"].wave[1].killTimeRatio = 0.71;
EpicBattleData["The Hornburg - Solo/Duo"].sides["Only"].wave[1].maxTime = 660;
EpicBattleData["The Hornburg - Solo/Duo"].sides["Only"].wave[1].killCount = 127;
EpicBattleData["The Hornburg - Solo/Duo"].sides["Only"].wave[1].nextSide = "Only";
EpicBattleData["The Hornburg - Solo/Duo"].sides["Only"].wave[1].delay = 106;
EpicBattleData["The Hornburg - Solo/Duo"].sides["Only"].wave[1][1] = "Bringing Down the Siege Ladders";
EpicBattleData["The Hornburg - Solo/Duo"].sides["Only"].wave[1][2] = "Repair the Portcullis";
EpicBattleData["The Hornburg - Solo/Duo"].sides["Only"].wave[2] = {}; -- indicates wave 2 on this side
EpicBattleData["The Hornburg - Solo/Duo"].sides["Only"].wave[2].killTimeRatio = 0.75;
EpicBattleData["The Hornburg - Solo/Duo"].sides["Only"].wave[2].maxTime = 680;
EpicBattleData["The Hornburg - Solo/Duo"].sides["Only"].wave[2].killCount = 111;
EpicBattleData["The Hornburg - Solo/Duo"].sides["Only"].wave[2].delay = 102;
EpicBattleData["The Hornburg - Solo/Duo"].sides["Only"].wave[2][1] = "Protecting the Gatehouse";
EpicBattleData["The Hornburg - Solo/Duo"].sides["Only"].wave[2][2] = "Winches in the Windows";
EpicBattleData["The Hornburg - Solo/Duo"].sides["Only"].wave[2][3] = "The Final Blockade";

-- Information for Pelargir - Solo
EpicBattleData["Retaking Pelargir - Solo/Duo"] = {};
EpicBattleData["Retaking Pelargir - Solo/Duo"].waves = 3;
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides = {}; -- will hold the sides this space has

EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 1"] = {};
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 1"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 1"].wave[1] = {}; -- indicates wave 1 on this side
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 1"].wave[1].killTimeRatio = 0.12;
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 1"].wave[1].maxTime = 365;
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 1"].wave[1].killCount = 41;
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 1"].wave[1].nextSide = "Phase 2";
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 1"].wave[1].delay = 30;

EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 2"] = {};
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 2"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 2"].wave[2] = {}; -- indicates wave 2 on this side
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 2"].wave[2].killTimeRatio = 0.25;
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 2"].wave[2].maxTime = 350;
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 2"].wave[2].killCount = 18;
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 2"].wave[2].delay = 40;
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 2"].wave[2].nextSide = "Phase 3";
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 2"].wave[2].epicFoes = {};
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 2"].wave[2].epicFoes.killCount = 45;
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 2"].wave[2].epicFoes[1] = {};
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 2"].wave[2].epicFoes[1].name = "Kang-kethek the Sorcerer";
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 2"].wave[2].epicFoes[1].timeToKill = 45;
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 2"].wave[2].epicFoes[2] = {};
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 2"].wave[2].epicFoes[2].name = "Ugturu the Half-troll";
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 2"].wave[2].epicFoes[2].timeToKill = 60;
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 2"].wave[2].quests = {};
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 2"].wave[2].quests.killCount = 22;
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 2"].wave[2].quests[1] = "Backs to the Wall";
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 2"].wave[2].quests[2] = "Parade of Thieves";
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 2"].wave[2].secondary = "Kisung Teng";
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 2"].wave[2].secondaryCallout = EBLangData.FirstPelFoe;
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 2"].wave[2].secondaryKillCount = 70;
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 2"].wave[2].secondaryTimeToKill = 45;

EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 3"] = {};
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 3"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 3"].wave[3] = {}; -- indicates wave 3 on this side
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 3"].wave[3].killTimeRatio = 0.29;
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 3"].wave[3].maxTime = 500;
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 3"].wave[3].killCount = 39;
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 3"].wave[3].delay = 75;
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 3"].wave[3].epicFoes = {};
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 3"].wave[3].epicFoes.killCount = 60;
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 3"].wave[3].epicFoes[1] = {};
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 3"].wave[3].epicFoes[1].name = "Okurayo the Minstrel";
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 3"].wave[3].epicFoes[1].timeToKill = 45;
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 3"].wave[3].epicFoes[2] = {};
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 3"].wave[3].epicFoes[2].name = "Archer Thisarti";
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 3"].wave[3].epicFoes[2].timeToKill = 45;
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 3"].wave[3].secondary = "Zagaroth";
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 3"].wave[3].secondaryCallout = EBLangData.SecondPelFoe;
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 3"].wave[3].secondaryKillCount = 110;
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Phase 3"].wave[3].secondaryTimeToKill = 45;

-- Information for Pelargir - Fellowship
EpicBattleData["Retaking Pelargir - Fellowship"] = {};
EpicBattleData["Retaking Pelargir - Fellowship"].waves = 3;
EpicBattleData["Retaking Pelargir - Fellowship"].sides = {}; -- will hold the sides this space has
                                    
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 1"] = {};
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 1"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 1"].wave[1] = {}; -- indicates wave 1 on this side
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 1"].wave[1].killTimeRatio = 0.27;
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 1"].wave[1].maxTime = 270;
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 1"].wave[1].killCount = 65;
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 1"].wave[1].nextSide = "Phase 2";
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 1"].wave[1].delay = 25;
                                    
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 2"] = {};
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 2"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 2"].wave[2] = {}; -- indicates wave 2 on this side
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 2"].wave[2].killTimeRatio = 0.34;
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 2"].wave[2].maxTime = 530;
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 2"].wave[2].killCount = 48;
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 2"].wave[2].delay = 35;
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 2"].wave[2].nextSide = "Phase 3";
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 2"].wave[2].epicFoes = {};
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 2"].wave[2].epicFoes.killCount = 100;
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 2"].wave[2].epicFoes[1] = {};
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 2"].wave[2].epicFoes[1].name = "Kang-kethek the Sorcerer";
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 2"].wave[2].epicFoes[1].timeToKill = 45;
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 2"].wave[2].epicFoes[2] = {};
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 2"].wave[2].epicFoes[2].name = "Ugturu the Half-troll";
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 2"].wave[2].epicFoes[2].timeToKill = 60;
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 2"].wave[2].quests = {};
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 2"].wave[2].quests.killCount = 40;
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 2"].wave[2].quests[1] = "Backs to the Wall";
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 2"].wave[2].quests[2] = "Parade of Thieves";
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 2"].wave[2].secondary = "Kisung Teng";
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 2"].wave[2].secondaryKillCount = 165;
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 2"].wave[2].secondaryCallout = EBLangData.FirstPelFoe;
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 2"].wave[2].secondaryTimeToKill = 45;
                                    
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 3"] = {};
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 3"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 3"].wave[3] = {}; -- indicates wave 3 on this side
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 3"].wave[3].killTimeRatio = 0.3;
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 3"].wave[3].maxTime = 800;
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 3"].wave[3].killCount = 30;
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 3"].wave[3].delay = 75;
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 3"].wave[3].epicFoes = {};
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 3"].wave[3].epicFoes.killCount = 150;
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 3"].wave[3].epicFoes[1] = {};
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 3"].wave[3].epicFoes[1].name = "Okurayo the Minstrel";
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 3"].wave[3].epicFoes[1].timeToKill = 50;
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 3"].wave[3].epicFoes[2] = {};
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 3"].wave[3].epicFoes[2].name = "Archer Thisarti";
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 3"].wave[3].epicFoes[2].timeToKill = 50;
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 3"].wave[3].quests = {};
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 3"].wave[3].quests.killCount = 65;
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 3"].wave[3].quests[1] = "The Ship-slaves";
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 3"].wave[3].quests[2] = "The Thrice-blown Horn";
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 3"].wave[3].secondary = "Zagaroth";
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 3"].wave[3].secondaryKillCount = 175;
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 3"].wave[3].secondaryCallout = EBLangData.SecondPelFoe;
EpicBattleData["Retaking Pelargir - Fellowship"].sides["Phase 3"].wave[3].secondaryTimeToKill = 45;

-- Information for The Defence of Minas Tirith - Solo
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"] = {};
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"].waves = 2;
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"].sides = {}; -- will hold the sides this space has
                                    
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"].sides["Phase 1"] = {};
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"].sides["Phase 1"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"].sides["Phase 1"].wave[1] = {}; -- indicates wave 1 on this side
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"].sides["Phase 1"].wave[1].killTimeRatio = 0.33;
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"].sides["Phase 1"].wave[1].maxTime = 665;
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"].sides["Phase 1"].wave[1].killCount = 70;
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"].sides["Phase 1"].wave[1].delay = 104;
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"].sides["Phase 1"].wave[1].nextSide = "Phase 2";
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"].sides["Phase 1"].wave[1].epicFoes = {};
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"].sides["Phase 1"].wave[1].epicFoes["Epic Foe: Raghathai, Faramir's Bane"] = {};
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"].sides["Phase 1"].wave[1].epicFoes["Epic Foe: Raghathai, Faramir's Bane"].name = "Epic Foe: Raghathai, Faramir's Bane";
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"].sides["Phase 1"].wave[1].epicFoes["Epic Foe: Raghathai, Faramir's Bane"].timeToKill = 34;
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"].sides["Phase 1"].wave[1][1] = "Epic Foe: Raghathai, Faramir's Bane";
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"].sides["Phase 1"].wave[1][2] = "Awash with Flames";
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"].sides["Phase 1"].wave[1][3] = "Beasts of Harad";
                                    
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"].sides["Phase 2"] = {};
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"].sides["Phase 2"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"].sides["Phase 2"].wave[2] = {}; -- indicates wave 2 on this side
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"].sides["Phase 2"].wave[2].killTimeRatio = 0.48;
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"].sides["Phase 2"].wave[2].maxTime = 400;
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"].sides["Phase 2"].wave[2].killCount = 63;
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"].sides["Phase 2"].wave[2].delay = 90;
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"].sides["Phase 2"].wave[2].epicFoes = {};
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"].sides["Phase 2"].wave[2].epicFoes["Epic Foe: Ahartal, Hand of the First Blade"] = {};
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"].sides["Phase 2"].wave[2].epicFoes["Epic Foe: Ahartal, Hand of the First Blade"].name = "Epic Foe: Ahartal, Hand of the First Blade";
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"].sides["Phase 2"].wave[2].epicFoes["Epic Foe: Ahartal, Hand of the First Blade"].timeToKill = 34;
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"].sides["Phase 2"].wave[2][1] = "Epic Foe: Ahartal, Hand of the First Blade";
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"].sides["Phase 2"].wave[2][2] = "Rain of Death";
EpicBattleData["The Defence of Minas Tirith - Solo/Duo"].sides["Phase 2"].wave[2][3] = "Despair in the Streets";

-- Information for The Defence of Minas Tirith - Small Fellowship
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"] = {};
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"].waves = 2;
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"].sides = {}; -- will hold the sides this space has
                                    
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"].sides["Phase 1"] = {};
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"].sides["Phase 1"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"].sides["Phase 1"].wave[1] = {}; -- indicates wave 1 on this side
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"].sides["Phase 1"].wave[1].killTimeRatio = 0.33;
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"].sides["Phase 1"].wave[1].maxTime = 700;
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"].sides["Phase 1"].wave[1].killCount = 53;
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"].sides["Phase 1"].wave[1].delay = 104;
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"].sides["Phase 1"].wave[1].nextSide = "Phase 2";
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"].sides["Phase 1"].wave[1].epicFoes = {};
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"].sides["Phase 1"].wave[1].epicFoes["Epic Foe: Raghathai, Faramir's Bane"] = {};
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"].sides["Phase 1"].wave[1].epicFoes["Epic Foe: Raghathai, Faramir's Bane"].name = "Epic Foe: Raghathai, Faramir's Bane";
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"].sides["Phase 1"].wave[1].epicFoes["Epic Foe: Raghathai, Faramir's Bane"].timeToKill = 34;
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"].sides["Phase 1"].wave[1][1] = "Epic Foe: Raghathai, Faramir's Bane";
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"].sides["Phase 1"].wave[1][2] = "Awash with Flames";
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"].sides["Phase 1"].wave[1][3] = "Beasts of Harad";
                                    
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"].sides["Phase 2"] = {};
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"].sides["Phase 2"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"].sides["Phase 2"].wave[2] = {}; -- indicates wave 2 on this side
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"].sides["Phase 2"].wave[2].killTimeRatio = 0.52;
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"].sides["Phase 2"].wave[2].maxTime = 620;
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"].sides["Phase 2"].wave[2].killCount = 75;
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"].sides["Phase 2"].wave[2].delay = 90;
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"].sides["Phase 2"].wave[2].epicFoes = {};
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"].sides["Phase 2"].wave[2].epicFoes["Epic Foe: Ahartal, Hand of the First Blade"] = {};
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"].sides["Phase 2"].wave[2].epicFoes["Epic Foe: Ahartal, Hand of the First Blade"].name = "Epic Foe: Ahartal, Hand of the First Blade";
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"].sides["Phase 2"].wave[2].epicFoes["Epic Foe: Ahartal, Hand of the First Blade"].timeToKill = 34;
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"].sides["Phase 2"].wave[2][1] = "Epic Foe: Ahartal, Hand of the First Blade";
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"].sides["Phase 2"].wave[2][2] = "Rain of Death";
EpicBattleData["The Defence of Minas Tirith - Small Fellowship"].sides["Phase 2"].wave[2][3] = "Despair in the Streets";

-- Information for Hammer of the Underworld - Solo
EpicBattleData["Hammer of the Underworld - Solo/Duo"] = {};
EpicBattleData["Hammer of the Underworld - Solo/Duo"].waves = 3;
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides = {}; -- will hold the sides this space has
                                    
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 1"] = {};
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 1"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 1"].wave[1] = {}; -- indicates wave 1 on this side
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 1"].wave[1].killTimeRatio = 0.45;
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 1"].wave[1].maxTime = 650;
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 1"].wave[1].killCount = 65;
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 1"].wave[1].delay = 135;
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 1"].wave[1].nextSide = "Phase 2";
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 1"].wave[1].epicFoes = {};
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 1"].wave[1].epicFoes["Epic Foe: Ughash the Unslakable"] = {};
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 1"].wave[1].epicFoes["Epic Foe: Ughash the Unslakable"].name = "Epic Foe: Ughash the Unslakable";
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 1"].wave[1].epicFoes["Epic Foe: Ughash the Unslakable"].timeToKill = 34;
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 1"].wave[1][1] = "Epic Foe: Ughash the Unslakable";
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 1"].wave[1][2] = "Drums of War";
                                    
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 2"] = {};
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 2"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 2"].wave[2] = {}; -- indicates wave 2 on this side
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 2"].wave[2].killTimeRatio = 0.44;
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 2"].wave[2].maxTime = 570;
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 2"].wave[2].killCount = 70;
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 2"].wave[2].delay = 78;
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 2"].wave[2].nextSide = "Phase 3";
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 2"].wave[2].epicFoes = {};
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 2"].wave[2].epicFoes["Epic Foe: Masorgh, Cleaver of Heads"] = {};
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 2"].wave[2].epicFoes["Epic Foe: Masorgh, Cleaver of Heads"].name = "Epic Foe: Masorgh, Cleaver of Heads";
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 2"].wave[2].epicFoes["Epic Foe: Masorgh, Cleaver of Heads"].timeToKill = 34;
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 2"].wave[2][1] = "Epic Foe: Masorgh, Cleaver of Heads";
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 2"].wave[2][2] = "A Brutal Reversal";
                                    
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 3"] = {};
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 3"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 3"].wave[3] = {}; -- indicates wave 3 on this side
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 3"].wave[3].killTimeRatio = 0.4;
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 3"].wave[3].maxTime = 645;
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 3"].wave[3].killCount = 60;
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 3"].wave[3].delay = 38;
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 3"].wave[3].epicFoes = {};
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 3"].wave[3][1] = "Broken by Fear";
EpicBattleData["Hammer of the Underworld - Solo/Duo"].sides["Phase 3"].wave[3][2] = "On Black Wings";

-- Information for Hammer of the Underworld - Fellowship
EpicBattleData["Hammer of the Underworld - Fellowship"] = {};
EpicBattleData["Hammer of the Underworld - Fellowship"].waves = 3;
EpicBattleData["Hammer of the Underworld - Fellowship"].sides = {}; -- will hold the sides this space has
                                    
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 1"] = {};
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 1"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 1"].wave[1] = {}; -- indicates wave 1 on this side
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 1"].wave[1].killTimeRatio = 0.46;
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 1"].wave[1].maxTime = 734;
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 1"].wave[1].killCount = 78;
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 1"].wave[1].delay = 130;
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 1"].wave[1].nextSide = "Phase 2";
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 1"].wave[1].epicFoes = {};
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 1"].wave[1].epicFoes["Epic Foe: Ughash the Unslakable"] = {};
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 1"].wave[1].epicFoes["Epic Foe: Ughash the Unslakable"].name = "Epic Foe: Ughash the Unslakable";
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 1"].wave[1].epicFoes["Epic Foe: Ughash the Unslakable"].timeToKill = 34;
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 1"].wave[1][1] = "Epic Foe: Ughash the Unslakable";
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 1"].wave[1][2] = "Drums of War";
                                    
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 2"] = {};
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 2"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 2"].wave[2] = {}; -- indicates wave 2 on this side
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 2"].wave[2].killTimeRatio = 0.46;
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 2"].wave[2].maxTime = 710;
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 2"].wave[2].killCount = 76;
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 2"].wave[2].delay = 89;
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 2"].wave[2].nextSide = "Phase 3";
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 2"].wave[2].epicFoes = {};
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 2"].wave[2].epicFoes["Epic Foe: Masorgh, Cleaver of Heads"] = {};
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 2"].wave[2].epicFoes["Epic Foe: Masorgh, Cleaver of Heads"].name = "Epic Foe: Masorgh, Cleaver of Heads";
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 2"].wave[2].epicFoes["Epic Foe: Masorgh, Cleaver of Heads"].timeToKill = 34;
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 2"].wave[2][1] = "Epic Foe: Masorgh, Cleaver of Heads";
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 2"].wave[2][2] = "A Brutal Reversal";
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 2"].wave[2][3] = "Up From the Depths";
                                    
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 3"] = {};
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 3"].wave = {}; -- will store the information for each wave of the instance
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 3"].wave[3] = {}; -- indicates wave 3 on this side
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 3"].wave[3].killTimeRatio = 0.47;
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 3"].wave[3].maxTime = 900;
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 3"].wave[3].killCount = 75;
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 3"].wave[3].delay = 50;
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 3"].wave[3].epicFoes = {};
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 3"].wave[3][1] = "Broken by Fear";
EpicBattleData["Hammer of the Underworld - Fellowship"].sides["Phase 3"].wave[3][2] = "On Black Wings";