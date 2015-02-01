-- monitors chat for different things
function chatParser(sender, args)
	-- check for certain things in chat here
	--[[ eventually I'd like to split this into different chat parsers so it isn't doing all of it in one function
		For example, have the main chat parser look for the instance starting, then once it has been found, 
		load the chat parser that will work for that instance. Separate chat parsers into Quest finder, wave callouts,
		deaths, etc. This way each time an unfiltered chat event happens, it doesn't have to check 10 different 
		callouts to see if they match.
	--]]

	-- check to find quests, such as the main quest and side quests
	if args.ChatType == Turbine.ChatType.Quest then

		if(args.Message:find(EBLangData.HelmsDike) ~= nil) then
			if(args.Message:find(EBLangData.Fellowship) ~= nil) then
				setUpEBObj("Helm's Dike - Fellowship");
			else -- it's the HD solo space
				setUpEBObj("Helm's Dike - Solo/Duo");
			end

		elseif(args.Message:find(EBLangData.GlitteringCaves) ~= nil) then
			if(args.Message:find(EBLangData.SmallFellowship) ~= nil) then
				-- it's the GC Small Fellowship space
				setUpEBObj("Glittering Caves - Small Fellowship");
			else -- it's the GC solo space
				setUpEBObj("Glittering Caves - Solo/Duo");
			end

		elseif(args.Message:find(EBLangData.DeepingWall) ~= nil) then
			if(args.Message:find(EBLangData.Raid) ~= nil) then
				-- it's the Deeping Wall Raid space
				setUpEBObj("Deeping Wall - Raid");
			else -- it's the DW solo space
				setUpEBObj("Deeping Wall - Solo/Duo");
			end

		elseif(args.Message:find(EBLangData.DeepingCoomb) ~= nil) then
			-- it's the Deeping-coomb solo space
			setUpEBObj("The Deeping-coomb - Solo/Duo");

		elseif(args.Message:find(EBLangData.Hornburg) ~= nil) then
			-- it's the Hornburg solo space
			setUpEBObj("The Hornburg - Solo/Duo");

		-- finds side quests when they start (won't need once the logging is no longer needed)
		elseif(args.Message:find("New Quest:") ~= nil) and debuggingMode then
			if ebObj ~= nil then
				if ebObj.waveInformation[ebObj.currentWave] ~= nil then
					ebObj.waveInformation[ebObj.currentWave].sideQuestKillCountStart = ebObj.waveInformation[ebObj.currentWave].killCount;
					ebObj.waveInformation[ebObj.currentWave].sideQuestEstKillCountStart = ebObj.waveInformation[ebObj.currentWave].estKillCount;
					ebObj.waveInformation[ebObj.currentWave].sideQuestTimeStart = Turbine.Engine:GetGameTime();
				end
			end

		end
	
	elseif ebObj ~= nil then -- prevents errors when running EBP while not in an EB

		if ebObj.currentWave ~= 0 and (not ebObj.waveInformation[ebObj.currentWave].hasEnded) then

			if args.ChatType == Turbine.ChatType.PlayerCombat then
				-- check to see if it is an emeny dying
				local defeatedStartIndex, defeatedEndIndex = args.Message:find(EBLangData.Defeated, 1, true);
				local defeatedNum = 0;
				if defeatedStartIndex ~= nil then
					local firstSpaceAfterDefeatedIndex = args.Message:find(" ", defeatedEndIndex); -- find the first space after defeated
					defeatedNum = tonumber(args.Message:sub(firstSpaceAfterDefeatedIndex+1, (args.Message:find(" ", firstSpaceAfterDefeatedIndex+1)-1) ));

					if(args.Message:find(EBLangData.Warrior, defeatedEndIndex, true) ~= nil) then
						if ebObj.waveInformation[ebObj.currentWave+1] ~= nil then
							ebObj:IncreaseKillCount(ebObj.currentWave+1, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave+1, defeatedNum);
						else
							ebObj:IncreaseKillCount(ebObj.currentWave, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave, defeatedNum);
						end

					elseif(args.Message:find(EBLangData.Berserker, defeatedEndIndex, true) ~= nil) then
						if ebObj.waveInformation[ebObj.currentWave+1] ~= nil then
							ebObj:IncreaseKillCount(ebObj.currentWave+1, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave+1, defeatedNum);
						else
							ebObj:IncreaseKillCount(ebObj.currentWave, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave, defeatedNum);
						end

					elseif(args.Message:find(EBLangData.Archer, defeatedEndIndex, true) ~= nil) then
						if ebObj.waveInformation[ebObj.currentWave+1] ~= nil then
							ebObj:IncreaseKillCount(ebObj.currentWave+1, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave+1, defeatedNum);
						else
							ebObj:IncreaseKillCount(ebObj.currentWave, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave, defeatedNum);
						end

					elseif(args.Message:find(EBLangData.Sapper, defeatedEndIndex, true) ~= nil) then
						if ebObj.waveInformation[ebObj.currentWave+1] ~= nil then
							ebObj:IncreaseKillCount(ebObj.currentWave+1, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave+1, defeatedNum);
						else
							ebObj:IncreaseKillCount(ebObj.currentWave, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave, defeatedNum);
						end
	
					elseif(args.Message:find(EBLangData.Commander, defeatedEndIndex, true) ~= nil) then
						if ebObj.waveInformation[ebObj.currentWave+1] ~= nil then
							ebObj:IncreaseKillCount(ebObj.currentWave+1, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave+1, defeatedNum);
						else
							ebObj:IncreaseKillCount(ebObj.currentWave, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave, defeatedNum);
						end
					end
					updateUI();
				end

				-- check to see if the player placed a trap
				local trapStartIndex, trapEndIndex = args.Message:find(EBLangData.TrapCombatChat, 1, false);
				if trapEndIndex ~= nil then
					if args.Message:find(EBLangData.BearTrap, 1, true) then
						table.insert(trapsTable, TrapObject(EBLangData.BearTrap, Turbine.Engine:GetGameTime()));
					elseif args.Message:find(EBLangData.Tripwire, 1, true) then
						table.insert(trapsTable, TrapObject(EBLangData.Tripwire, Turbine.Engine:GetGameTime()));
					else
						table.insert(trapsTable, TrapObject(EBLangData.Caltrop, Turbine.Engine:GetGameTime()));
					end
					updateUI();
				end

			---[[ This section will no longer be needed once logging is no longer needed
			elseif args.ChatType == Turbine.ChatType.Death and debuggingMode then
				local defeatedStartIndex, defeatedEndIndex = args.Message:find("defeated", 1, true);
				if defeatedEndIndex ~= nil then
					if(args.Message:find("Warrior", defeatedEndIndex, true) ~= nil) then
						ebObj:IncreaseKillCount(ebObj.currentWave, 1);
						setDelayTime();

					elseif(args.Message:find("Berserker", defeatedEndIndex, true) ~= nil) then
						ebObj:IncreaseKillCount(ebObj.currentWave, 1);
						setDelayTime();
	
					elseif(args.Message:find("Archer", defeatedEndIndex, true) ~= nil) then
						ebObj:IncreaseKillCount(ebObj.currentWave, 1);
						setDelayTime();

					elseif(args.Message:find("Sapper", defeatedEndIndex, true) ~= nil) then
						ebObj:IncreaseKillCount(ebObj.currentWave, 1);
						setDelayTime();

					elseif(args.Message:find("Commander", defeatedEndIndex, true) ~= nil) then
						ebObj:IncreaseKillCount(ebObj.currentWave, 1);
						setDelayTime();
					end
					updateUI();
				end--]]--
			end

		end -- ends if currentWave ~= 0

		-- find callouts to which side is being marched upon
		if args.ChatType == Turbine.ChatType.Unfiltered then

			-- split wave callouts into distinct instances, to prevent errors
			if (ebObj.spaceName == "Helm's Dike - Solo/Duo") or (ebObj.spaceName == "Helm's Dike - Fellowship") then
				-- Eastern/Western/Centre wave starting
				if(args.Message:find(EBLangData.EasternEnd, 1, true) ~= nil) then
					waveHasStarted("Eastern");
				elseif(args.Message:find(EBLangData.WesternEnd, 1, true) ~= nil) then
					waveHasStarted("Western");
				elseif(args.Message:find(EBLangData.HDCentre, 1, true) ~= nil) then
					waveHasStarted("Centre");
			
				-- 1st/2nd waves ending
				elseif(args.Message:find(EBLangData.HDWaveEnding1, 1, true) ~= nil) then
					waveHasEnded();
				-- 3rd wave ending
				elseif(args.Message:find(EBLangData.HDWaveEnding2, 1, true) ~= nil) then
					waveHasEnded();
				end

			elseif (ebObj.spaceName == "Glittering Caves - Solo/Duo") or (ebObj.spaceName == "Glittering Caves - Small Fellowship") then
				-- East/West/Centre wave starting
				if(args.Message:find(EBLangData.EasternTunnel, 1, true) ~= nil) then
					waveHasStarted("Eastern");
				elseif(args.Message:find(EBLangData.WesternIsland, 1, true) ~= nil) then
					waveHasStarted("Western");
				elseif(args.Message:find(EBLangData.GCCentre, 1, true) ~= nil) then
					waveHasStarted("Centre");

				-- Waves ending
				elseif(args.Message:find(EBLangData.GCWaveEnding1, 1, true) ~= nil) then
					waveHasEnded();
				elseif(args.Message:find(EBLangData.GCWaveEnding2, 1, true) ~= nil) then
					waveHasEnded();
				elseif(args.Message:find(EBLangData.GCWaveEnding3, 1, true) ~= nil) then
					waveHasEnded();
				end

			elseif ebObj.spaceName== "Deeping Wall - Solo/Duo" then
				-- 1st/2nd wave starting
				if(args.Message:find(EBLangData.DWStart1, 1, true) ~= nil) then
					waveHasStarted("Only");
				elseif(args.Message:find(EBLangData.DWStart2, 1, true) ~= nil) then
					waveHasStarted("Only");

				-- waves ending
				elseif(args.Message:find(EBLangData.DWWaveEnding1, 1, true) ~= nil) then
					waveHasEnded();
				elseif(args.Message:find(EBLangData.DWWaveEnding2, 1, true) ~= nil) then
					waveHasEnded();
				end
			
			elseif ebObj.spaceName == "Deeping Wall - Raid" then
				-- waves starting
				if(args.Message:find(EBLangData.EasternWall, 1, true) ~= nil) then
					waveHasStarted("Eastern");
				elseif(args.Message:find(EBLangData.WesternWall, 1, true) ~= nil) then
					waveHasStarted("Western");
				elseif(args.Message:find(EBLangData.CentreWall, 1, true) ~= nil) then
					waveHasStarted("Centre");

				-- 1st/2nd waves ending
				elseif(args.Message:find(EBLangData.DWWaveEnding1, 1, true) ~= nil) then
					waveHasEnded();
				-- 3rd wave ending
				elseif(args.Message:find(EBLangData.DWWaveEnding2, 1, true) ~= nil) then
					waveHasEnded();
				end

			elseif ebObj.spaceName == "The Deeping-coomb - Solo/Duo" then
				-- waves starting
				if(args.Message:find(EBLangData.HornburgSide, 1, true) ~= nil) then
					waveHasStarted("Hornburg");
				elseif(args.Message:find(EBLangData.GlitteringSide, 1, true) ~= nil) then
					waveHasStarted("Glittering Caves");

				-- waves ending
				elseif(args.Message:find(EBLangData.DCWaveEnding1, 1, true) ~= nil) then
					waveHasEnded();
				elseif(args.Message:find(EBLangData.DCWaveEnding2, 1, true) ~= nil) then
					waveHasEnded();
				end

			elseif ebObj.spaceName == "The Hornburg - Solo/Duo" then
				-- 1st/2nd wave starting
				if(args.Message:find(EBLangData.HBStart, 1, true) ~= nil) then
					waveHasStarted("Only");

				-- 1st/2nd wave ending
				elseif(args.Message:find(EBLangData.HBWaveEnding, 1, true) ~= nil) then
					waveHasEnded();
				end
			end
		elseif args.ChatType == Turbine.ChatType.Standard then
			if args.Message:find(EBLangData.EnteredChatChannel) then
				ebObj = nil;
				if OptionWindow.minAfterBattleToggle:IsChecked() and not winIsMin then
					main_window:SetSize(20,20);
					main_window:SetOpacity(1);
					winIsMin = true;
				end
				updateUI();
			end
		end

	end -- ends if ebObj ~= nil
end

AddCallback(Turbine.Chat, "Received", chatParser);

-- function that sets up the EpicBattleSpace obj
function setUpEBObj(spaceName)
	if debuggingMode and pastEpicBattles == nil then
		pastEpicBattles = {};
	end
	ebObj = EpicBattleSpace(spaceName);
	if debuggingMode then table.insert(pastEpicBattles, ebObj); end
	if OptionWindow.maxForBattleToggle:IsChecked() and winIsMin then
		scaleMainWindow(OptionWindow.scaleScrollbar:GetValue());
		main_window:SetOpacity(OptionWindow.transparencyScrollbar:GetValue()/100);
		winIsMin = false;
	end
	updateUI();
end

-- function that works out wave start callouts
function waveHasStarted(sideName)
	ebObj:SetNewWave(ebObj.currentWave+1, Turbine.Engine:GetGameTime(), sideName);
	if ebObj.currentWave == 0 then
		ebObj.currentWave = 1;
	elseif ebObj.waveInformation[ebObj.currentWave].hasEnded then
		ebObj.currentWave = ebObj.currentWave + 1;
	end
	updateUI();
end

-- function that works out wave ending callouts
function waveHasEnded()
	if ebObj.currentWave ~= 0 then
		ebObj.waveInformation[ebObj.currentWave].hasEnded = true;
		ebObj.waveInformation[ebObj.currentWave].actualEndTime = Turbine.Engine:GetGameTime();
	end
	if ebObj.waveInformation[ebObj.currentWave+1] ~= nil then
		ebObj.currentWave = ebObj.currentWave + 1;
	elseif ebObj.currentWave == ebObj.waves then
		ebObj = nil;
		if OptionWindow.minAfterBattleToggle:IsChecked() and not winIsMin then
			main_window:SetSize(20,20);
			main_window:SetOpacity(1);
			winIsMin = true;
		end
	end
	updateUI();
end

-- function that sets the delay amount if needed
function setDelayTime()
	if ebObj.waveInformation[ebObj.currentWave] ~= nil and ebObj.waveInformation[ebObj.currentWave].delayCalc == nil then
		ebObj.waveInformation[ebObj.currentWave].delayCalc = Turbine.Engine:GetGameTime();
	end
end