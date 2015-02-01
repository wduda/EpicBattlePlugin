EBLangData = {}

EBLangData.EpicBattleHeader = "Epic Battle Plugin";
EBLangData.WaveLabel = "Waves:";
EBLangData.Wave1Label = "1st";
EBLangData.Wave2Label = "2nd";
EBLangData.Wave3Label = "3rd";
EBLangData.InfoLabel = "This information is not exact.";
EBLangData.EndsIn = "Ends In: ";
EBLangData.KillCount = "Kill Count: ";
EBLangData.TilSideQuestStarts = "til Side Quest Starts: ";
EBLangData.QuestLabel = "Quests";
EBLangData.FirstQuestLabel = "1st Quest: ";
EBLangData.SecondQuestLabel = "2nd Quest: ";
EBLangData.ThirdQuestLabel = "3rd Quest: ";
EBLangData.RandomQuest = "Random Quest - Hover for Details";
EBLangData.UnknownQuest = "Not Yet Known - Hover for Details";
EBLangData.QuestName = "QUEST NAME";
EBLangData.TrapsLabel = "Traps:";
EBLangData.NoneLabel = "None";
EBLangData.NotYetKnown = "Not Yet Known";
EBLangData.Soon = "SOON!";
EBLangData.PotentialQuests = "Potential Quests";
EBLangData.StartNewEpicBattle = "Start ";
EBLangData.StartNewWave = "Start New Wave: ";
EBLangData.MenuWesternSide = "Western Side";
EBLangData.MenuEasternSide = "Eastern Side";
EBLangData.MenuHornburg = "Hornburg";
EBLangData.MenuGlitteringCaves = "Glittering Caves";
EBLangData.MenuCentreSide = "Centre Side";
EBLangData.MenuOnlySide = "Start New Wave";
EBLangData.MenuEndWave = "End Current Wave";

-- Need translations for all epic battle instances, use following format
EBLangData["Helm's Dike - Solo/Duo"] = "Helm's Dike - Solo/Duo";
EBLangData["Helm's Dike - Fellowship"] = "Helm's Dike - Fellowship";
EBLangData["Deeping Wall - Solo/Duo"] = "Deeping Wall - Solo/Duo";
EBLangData["Deeping Wall - Raid"] = "Deeping Wall - Raid";
EBLangData["The Deeping-coomb - Solo/Duo"] = "The Deeping-coomb - Solo/Duo";
EBLangData["Glittering Caves - Solo/Duo"] = "Glittering Caves - Solo/Duo";
EBLangData["Glittering Caves - Small Fellowship"] = "Glittering Caves - Small Fellowship";
EBLangData["The Hornburg - Solo/Duo"] = "The Hornburg - Solo/Duo";

-- Need translations for all side quests, use following format
EBLangData["Stone Obstruction"] = "Stone Obstruction";
EBLangData["Guarding the Watchtower"] = "Guarding the Watchtower";
EBLangData["Guarding the Watchtowers"] = "Guarding the Watchtowers";
EBLangData["Protect the Horses"] = "Protect the Horses";
EBLangData["Statue of Helm Hammerhand"] = "Statue of Helm Hammerhand";
EBLangData["Powder at the Gate"] = "Powder at the Gate";
EBLangData["Flames at the Gate"] = "Flames at the Gate";
EBLangData["Breaching the Hornburg"] = "Breaching the Hornburg";
EBLangData["Securing the Culvert"] = "Securing the Culvert";
EBLangData["The Vanguard Defilers"] = "The Vanguard Defilers";
EBLangData["Vandals in the Tower"] = "Vandals in the Tower";
EBLangData["Shells in the Air"] = "Shells in the Air";
EBLangData["Assault on the East Tower"] = "Assault on the East Tower";
EBLangData["A Flanking Foe"] = "A Flanking Foe";
EBLangData["Bred for Battle"] = "Bred for Battle";
EBLangData["Siege Under Fire"] = "Siege Under Fire";
EBLangData["Searching the Debris"] = "Searching the Debris";
EBLangData["Defilers in the Water"] = "Defilers in the Water";
EBLangData["A Pillage Denied"] = "A Pillage Denied";
EBLangData["Prepare to Fall Back"] = "Prepare to Fall Back";
EBLangData["Stalactites Over the Bridge"] = "Stalactites Over the Bridge";
EBLangData["Bombs and Bats"] = "Bombs and Bats";
EBLangData["Cave In"] = "Cave In";
EBLangData["Spider Assault"] = "Spider Assault";
EBLangData["Civilian Defence"] = "Civilian Defence";
EBLangData["Preparing the Charge"] = "Preparing the Charge";
EBLangData["Protecting the Gatehouse"] = "Protecting the Gatehouse";
EBLangData["Bring Down the Siege Ladders"] = "Bring Down the Siege Ladders";
EBLangData["Repair the Portcullis"] = "Repair the Portcullis";
EBLangData["Winches in the Windows"] = "Winches in the Windows";
EBLangData["The Final Blockade"] = "The Final Blockade";

-- Need traps translations, these should match exactly how they are in game
EBLangData.BearTrap = "Bear";
EBLangData.Caltrop = "Caltrop";
EBLangData.Tripwire = "Tripwire";
EBLangData.TrapCombatChat = "applied a .*benefit.* with Trap"; -- the .* capture the color codes that you can't see in game

-- Need main quest translations - these must match exactly how they appear in the chat in game
EBLangData.HelmsDike = "New Quest: Helm's Dike";
EBLangData.GlitteringCaves = "New Quest: The Glittering Caves";
EBLangData.DeepingWall = "New Quest: The Deeping Wall";
EBLangData.DeepingCoomb = "New Quest: The Deeping%-coomb";
EBLangData.Hornburg = "New Quest: The Hornburg";
EBLangData.Retaking = "New Quest: Retaking Pelargir";

-- Need in-game translations of these keywords to determine if the main quest is a Small Fellowship, Fellowship, or Raid
EBLangData.Fellowship = "Fellowship";
EBLangData.SmallFellowship = "Small";
EBLangData.Raid = "Raid";

-- Need in-game translations of these keywords to determine when an enemy has been defeated
EBLangData.Defeated = "defeated";
EBLangData.Warrior = "Warrior";
EBLangData.Berserker = "Berserker";
EBLangData.Archer = "Archer";
EBLangData.Sapper = "Sapper";
EBLangData.Commander = "Commander";
EBLangData.Haradrim = "Haradrim";
EBLangData.Corsair = "Corsair";

-- Need in-game translations to see which side is being attacked, when a wave ends, etc. Must exactly match.
-- In Helm's Dike:
EBLangData.EasternEnd = "eastern end";
EBLangData.WesternEnd = "western end";
EBLangData.HDCentre = "They are coming down the centre";
EBLangData.HDWaveEnding1 = "They are thinning. We will soon have a break. Make the best of it";
EBLangData.HDWaveEnding2 = "Their main force marches. Fall back!";
-- In Glittering Caves:
EBLangData.EasternTunnel = "eastern tunnel";
EBLangData.WesternIsland = "western island";
EBLangData.GCCentre = "Defend the women and children, they come for the centre";
EBLangData.GCWaveEnding1 = "They are thinning. We will soon have a break. Make the best of it";
EBLangData.GCWaveEnding2 = "Fall back to the centre. The women and children must be protected";
EBLangData.GCWaveEnding3 = "We have driven them back";
--Deeping Wall Solo/Raid
EBLangData.DWStart1 = "Prepare yourself, our enemy approaches! They have catapults";
EBLangData.DWStart2 = "The battle will soon be rejoined. They come again! More siege approaches";
EBLangData.EasternWall = "eastern wall";
EBLangData.WesternWall = "western wall";
EBLangData.CentreWall = "They are attacking the centre of the wall!";
EBLangData.DWWaveEnding1 = "It looks like we shall soon have a respite. Use it wisely";
EBLangData.DWWaveEnding2 = "Clear the wall! They're going to blow it";
-- Deeping-coomb
EBLangData.HornburgSide = "They march towards the Hornburg";
EBLangData.GlitteringSide = "They are heading towards the Glittering Caves";
EBLangData.DCWaveEnding1 = "The coming respite will not last long";
EBLangData.DCWaveEnding2 = "We cannot hold here, they number too many. Retreat";
-- Hornburg
EBLangData.HBStart = "The enemy is massing and preparing his assault. Ready your defences";
EBLangData.HBWaveEnding = "They are thinning. We will soon have a break. Make the best of it";
-- Retaking Pelargir - Solo/Duo
EBLangData.RPStart1 = "Within Pelargir's walls, just as you promised!";
EBLangData.RPStart = "New Quest:";
EBLangData.RPWaveEnding = "Completed:";



-- Need in game translations to see when the players enters a chat channel - this means they have left the epic battle instance
EBLangData.EnteredChatChannel = "Entered the .- channel";

-- Translation for shorthand "Not Available" - N/A
EBLangData.NotAvailable = "N/A";

EBLangData.OptionsCommand = "options"; -- used to type /ebp options to bring up the options panel
EBLangData.HelpOutput = "EpicBattlePlugin has the following command:\n   options: Opens up the EBP options panel."; -- options should match the above
EBLangData.Opacity = "Opacity";
EBLangData.AlwaysLoadMin = "Always Load Minimized";
EBLangData.ScaleWindow = "Scale Window";

EBLangData.OptionsMenu = "Show Options";
EBLangData.MinAfterBattle = "Minimize Window After Battle";
EBLangData.MaxForBattle = "Maximize Window for Battle";

EBLangData.OptionsWindow = "Options Window";
EBLangData.SaveCalls = "Make Additional Save Calls";