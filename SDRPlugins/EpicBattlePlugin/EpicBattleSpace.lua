EpicBattleSpace = class();

-- EpicBattleSpace objects have the following internal variables:

-- EpicBattleSpace.spaceName -- the instance name

-- EpicBattleSpace.waves -- the number of waves this space has
-- EpicBattleSpace.currentWave -- the current wave number

-- waveInformation will store each wave information in this type of an array:
-- waveInformation[1] -- each wave will simply be the index in the array
--		.startTime -- the start time of the wave
--		.side -- the side/section the wave is on
--		.killCount -- the number of monster kills for this wave
--		.sideQuestStart -- the kill count at which the side quest will start
--		.endTime -- the end time of the wave
--		.hasEnded -- true if the wave is over (the callout has happened)
--		.killTimeRatio -- the kill/time ratio for this side/wave
--		.lastKillCountUpdate -- the last time the estimated kill count was updated
--		.delay -- the delay between the start of the wave and the arrival of the mobs
-- EpicBattleSpace.waveInformation -- will store the information on each wave, such as side/section wave is on, timers, kill counts, etc
-- EpicBattleSpace.DWRaidMatrix - It is help to idetify the 3. quest after we know the 2. position

function EpicBattleSpace:Constructor(spaceName)
	self.spaceName = spaceName;
	self.waves = EpicBattleData[self.spaceName].waves;
	self.waveInformation = {};
	self.currentWave = 0;
	self.promotionPoint = 0;
	self.DWRaidMatrix = {};	
	self.DWRaidMatrix["Western"] = 1;
	self.DWRaidMatrix["Eastern"] = 1;
	self.DWRaidMatrix["Centre"] = 1;
	QuestDetailData = {};
	RandomQuestData = {};
	
end

-- update this function to create a new wave but not set to the current wave, as the current wave will be set when the callout for the wave ending happens
function EpicBattleSpace:SetNewWave(waveNum, startTime, side)
	self.waveInformation[waveNum] = {};
	self.waveInformation[waveNum].startTime = startTime;
	self.waveInformation[waveNum].side = side;
	self.waveInformation[waveNum].killCount = 0;
	self.waveInformation[waveNum].estKillCount = 0;
	self.waveInformation[waveNum].sideQuestStart = EpicBattleData[self.spaceName].sides[side].wave[waveNum].killCount;
	self.waveInformation[waveNum].endTime = startTime + EpicBattleData[self.spaceName].sides[side].wave[waveNum].maxTime;
	self.waveInformation[waveNum].actualEndTime = startTime + EpicBattleData[self.spaceName].sides[side].wave[waveNum].maxTime;
	self.waveInformation[waveNum].hasEnded = false;
	self.waveInformation[waveNum].killTimeRatio = EpicBattleData[self.spaceName].sides[side].wave[waveNum].killTimeRatio;
	self.waveInformation[waveNum].lastKillCountUpdate = startTime + EpicBattleData[self.spaceName].sides[side].wave[waveNum].delay;
	self.waveInformation[waveNum].delay = EpicBattleData[self.spaceName].sides[side].wave[waveNum].delay;
	self.waveInformation[waveNum].Reward = 0;

end

-- create a function that will increase the kill count for a specific wave
function EpicBattleSpace:IncreaseKillCount(waveNum, killAmount)
	if self.waveInformation[waveNum] ~= nil then
		self.waveInformation[waveNum].killCount = self.waveInformation[waveNum].killCount + killAmount;
	end
end

-- create a function that will increase the eastimated kill count for a specific wave
function EpicBattleSpace:IncreaseEstKillCount(waveNum, killAmount)
	if self.waveInformation[waveNum] ~= nil then
		self.waveInformation[waveNum].estKillCount = self.waveInformation[waveNum].estKillCount + killAmount;
	end
end