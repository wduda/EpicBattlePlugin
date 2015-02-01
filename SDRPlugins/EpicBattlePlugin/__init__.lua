debuggingMode = false;

-- Check and load the LanguageData (Note: Searchstrings and Names should be changed there)
GLocale = Turbine.Engine.GetLanguage();
if GLocale == 268435460 then 
	GLocale = "de";
	import "SDRPlugins.EpicBattlePlugin.Language_de";
--  elseif GLocale == 268435459 then GLocale = "fr";
--  elseif GLocale == 268435463 then GLocale = "ru";
else
	GLocale = "en";
	import "SDRPlugins.EpicBattlePlugin.Language_en";
	import "SDRPlugins.EpicBattlePlugin.Language_ext_en";
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


ChatData = {};
ChatData.chat = "/RA";
ChatData.wave = 0;
ChatData.detail = 1;
ChatData.language = "hu";

QuestDetailData = {};
QuestRewardData = {};
RandomQuestData = {};

QuestRewardData[1] = "reward_bronze.tga";
QuestRewardData[2] = "reward_silver.tga";
QuestRewardData[3] = "reward_gold.tga";
QuestRewardData[4] = "reward_platinum.tga";

EpicBattleData = {};

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
EpicBattleData["The Hornburg - Solo/Duo"].sides["Only"].wave[1][1] = "Bring Down the Siege Ladders";
EpicBattleData["The Hornburg - Solo/Duo"].sides["Only"].wave[1][2] = "Repair the Portcullis";
EpicBattleData["The Hornburg - Solo/Duo"].sides["Only"].wave[2] = {}; -- indicates wave 2 on this side
EpicBattleData["The Hornburg - Solo/Duo"].sides["Only"].wave[2].killTimeRatio = 0.75;
EpicBattleData["The Hornburg - Solo/Duo"].sides["Only"].wave[2].maxTime = 680;
EpicBattleData["The Hornburg - Solo/Duo"].sides["Only"].wave[2].killCount = 111;
EpicBattleData["The Hornburg - Solo/Duo"].sides["Only"].wave[2].delay = 102;
EpicBattleData["The Hornburg - Solo/Duo"].sides["Only"].wave[2][1] = "Protecting the Gatehouse";
EpicBattleData["The Hornburg - Solo/Duo"].sides["Only"].wave[2][2] = "Winches in the Windows";
EpicBattleData["The Hornburg - Solo/Duo"].sides["Only"].wave[2][3] = "The Final Blockade";


-- Pelangir

-- Information for Retaking Pelargir
EpicBattleData["Retaking Pelargir - Solo/Duo"] = {};
EpicBattleData["Retaking Pelargir - Solo/Duo"].waves = 3;
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides = {}; -- will hold the sides this space has
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Only"] = {};
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Only"].wave = {}; 
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Only"].wave[1] = {}; 
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Only"].wave[1].killTimeRatio = 0.5;
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Only"].wave[1].maxTime = 2000; 
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Only"].wave[1].killCount = 10; 
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Only"].wave[1].nextSide = "Only"; 
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Only"].wave[1].delay = 500; 
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Only"].wave[1][1] = "Kang-kethek the Sorcerer";
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Only"].wave[1][2] = "Ugturu the Half-troll";
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Only"].wave[2] = {};
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Only"].wave[2].killTimeRatio = 0.5; 
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Only"].wave[2].maxTime = 600; 
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Only"].wave[2].killCount = 10; 
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Only"].wave[2].nextSide = "Only"; 
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Only"].wave[2].delay = 120; 
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Only"].wave[2][1] = "Parade of Thieves";
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Only"].wave[2][2] = "Backs to the Wall";
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Only"].wave[3] = {}; -- indicates wave 3 on this side
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Only"].wave[3].killTimeRatio = 0.5; 
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Only"].wave[3].maxTime = 600; 
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Only"].wave[3].killCount = 10; 
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Only"].wave[3].delay = 120; 
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Only"].wave[3][1] = "Archer Thisarti";
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Only"].wave[3][2] = "Okurayo the Minstrel";
EpicBattleData["Retaking Pelargir - Solo/Duo"].sides["Only"].wave[3][3] = "The Thrice Blown Horn";
