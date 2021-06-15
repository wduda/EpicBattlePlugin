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
			
		elseif(args.Message:find(EBLangData.RetakingPelargir) ~= nil) then
			if(args.Message:find(EBLangData.Fellowship) ~= nil) then
				-- it's Pelargir fellowship
				setUpEBObj("Retaking Pelargir - Fellowship");
			else -- it's the Pelargir solo
				setUpEBObj("Retaking Pelargir - Solo/Duo");
			end
		
		-- Minas Tirith fix (1/2/16)
		elseif(args.Message:find(EBLangData.HammerMinasTirith) ~= nil) then
			-- it's Hammer of the Underworld, need to figure out if it's a solo or non-solo instance
			if confirmHDSizeWindow ~= nil then
				confirmHDSizeWindow:SetVisible(false);
				confirmHDSizeWindow = nil;
			end
			confirmHDSizeWindow = ConfirmInstanceWindow(EBLangData.HammerMinasTirith);
			confirmHDSizeWindow:Show();
			
--			if(Turbine.Gameplay.LocalPlayer:GetInstance():GetParty() ~= nil) then -- the player is in a fellowship, it may be duo or not
--				if(Turbine.Gameplay.LocalPlayer:GetInstance():GetParty():GetMemberCount() > 2) then -- there are more than 2 players in the group, it is the non-solo version
--					setUpEBObj("Hammer of the Underworld - Fellowship");
--				else -- there are 2 players in the fellowship, it is the solo version
--					setUpEBObj("Hammer of the Underworld - Solo/Duo");
--				end
--			else -- the player is not in a party, thus it is a solo instance
--				setUpEBObj("Hammer of the Underworld - Solo/Duo");
--			end
			
		-- Minas Tirith fix (1/2/16)
		elseif(args.Message:find(EBLangData.DefenceMinasTirith) ~= nil) then
			-- it's The Defence of Minas Tirith, need to figure out if it's a solo or non-solo instance
			if confirmHDSizeWindow ~= nil then
				confirmHDSizeWindow:SetVisible(false);
				confirmHDSizeWindow = nil;
			end
			confirmHDSizeWindow = ConfirmInstanceWindow(EBLangData.DefenceMinasTirith);
			confirmHDSizeWindow:Show();
			
--			if(Turbine.Gameplay.LocalPlayer:GetInstance():GetParty() ~= nil) then -- the player is in a fellowship, it may be duo or not
--				if(Turbine.Gameplay.LocalPlayer:GetInstance():GetParty():GetMemberCount() > 2) then -- there are more than 2 players in the group, it is the non-solo version
--					setUpEBObj("The Defence of Minas Tirith - Small Fellowship");
--				else -- there are 2 players in the fellowship, it is the solo version
--					setUpEBObj("The Defence of Minas Tirith - Solo/Duo");
--				end
--			else -- the player is not in a party, thus it is a solo instance
--				setUpEBObj("The Defence of Minas Tirith - Solo/Duo");
--			end
			
		-- Pel/MT to find when epic foes appear and start the timer
		elseif args.Message:find(EBLangData.NewQuest) ~= nil then
			if ebObj ~= nil then
				if ebObj.spaceName == "Retaking Pelargir - Solo/Duo" or ebObj.spaceName == "Retaking Pelargir - Fellowship" then
					if ebObj.waveInformation[ebObj.currentWave] ~= nil then
						local isQuest = true;
						for foes = 1, #EpicBattleData[ebObj.spaceName].sides[ebObj.waveInformation[ebObj.currentWave].side].wave[ebObj.currentWave].epicFoes do
							--Turbine.Shell.WriteLine(EpicBattleData[ebObj.spaceName].sides[ebObj.waveInformation[ebObj.currentWave].side].wave[ebObj.currentWave].epicFoes[foes].name);
							if args.Message:find(EBLangData.PelSearchableQuest[EpicBattleData[ebObj.spaceName].sides[ebObj.waveInformation[ebObj.currentWave].side].wave[ebObj.currentWave].epicFoes[foes].name]) ~= nil then
								ebObj.waveInformation[ebObj.currentWave].killEndTime = Turbine.Engine:GetGameTime() + EpicBattleData[ebObj.spaceName].sides[ebObj.waveInformation[ebObj.currentWave].side].wave[ebObj.currentWave].epicFoes[foes].timeToKill;
								ebObj.waveInformation[ebObj.currentWave].isEpicFoe = 2;
								ebObj.waveInformation[ebObj.currentWave].foeName = EpicBattleData[ebObj.spaceName].sides[ebObj.waveInformation[ebObj.currentWave].side].wave[ebObj.currentWave].epicFoes[foes].name;
								ebObj.waveInformation[ebObj.currentWave].part = 2;
								
								isQuest = false;
								
								-- if we're debugging stuff, add the start time of the epic foe
								if debuggingMode then
									ebObj.waveInformation[ebObj.currentWave].epicFoeKillCountStart = ebObj.waveInformation[ebObj.currentWave].killCount;
									ebObj.waveInformation[ebObj.currentWave].epicFoeEstKillCountStart = ebObj.waveInformation[ebObj.currentWave].estKillCount;
									ebObj.waveInformation[ebObj.currentWave].epicFoeTimeStart = Turbine.Engine:GetGameTime();
								end
							end
						end
						
						if isQuest then
							ebObj.waveInformation[ebObj.currentWave].part = 1;
							
							if debuggingMode then
								ebObj.waveInformation[ebObj.currentWave].sideQuestKillCountStart = ebObj.waveInformation[ebObj.currentWave].killCount;
								ebObj.waveInformation[ebObj.currentWave].sideQuestEstKillCountStart = ebObj.waveInformation[ebObj.currentWave].estKillCount;
								ebObj.waveInformation[ebObj.currentWave].sideQuestTimeStart = Turbine.Engine:GetGameTime();
							end
						end
					end
				
				-- Minas Tirith fix (1/2/16)
				elseif ebObj.spaceName == "The Defence of Minas Tirith - Solo/Duo" or ebObj.spaceName == "The Defence of Minas Tirith - Small Fellowship" or ebObj.spaceName == "Hammer of the Underworld - Solo/Duo" or ebObj.spaceName == "Hammer of the Underworld - Fellowship" then
					-- determine if the side quest is an epic foe, and set the kill timer if so
					if ebObj.waveInformation[ebObj.currentWave] ~= nil then
						for questIndex = 1, #EpicBattleData[ebObj.spaceName].sides[ebObj.waveInformation[ebObj.currentWave].side].wave[ebObj.currentWave] do
							local questName = EpicBattleData[ebObj.spaceName].sides[ebObj.waveInformation[ebObj.currentWave].side].wave[ebObj.currentWave][questIndex];
							if(EBLangData.MTSearchableQuest[questName] ~= nil and args.Message:find(EBLangData.MTSearchableQuest[questName]) ~= nil) then
								ebObj.waveInformation[ebObj.currentWave].killEndTime = Turbine.Engine:GetGameTime() + EpicBattleData[ebObj.spaceName].sides[ebObj.waveInformation[ebObj.currentWave].side].wave[ebObj.currentWave].epicFoes[questName].timeToKill;
								ebObj.waveInformation[ebObj.currentWave].foeName = EpicBattleData[ebObj.spaceName].sides[ebObj.waveInformation[ebObj.currentWave].side].wave[ebObj.currentWave].epicFoes[questName].name;
							end
						end
						
						-- if we're debugging stuff, add the start time of the epic foe
						if debuggingMode then
							ebObj.waveInformation[ebObj.currentWave].sideQuestKillCountStart = ebObj.waveInformation[ebObj.currentWave].killCount;
							ebObj.waveInformation[ebObj.currentWave].sideQuestEstKillCountStart = ebObj.waveInformation[ebObj.currentWave].estKillCount;
							ebObj.waveInformation[ebObj.currentWave].sideQuestTimeStart = Turbine.Engine:GetGameTime();
						end
					end
				
				elseif debuggingMode then
					if ebObj.waveInformation[ebObj.currentWave] ~= nil then
						ebObj.waveInformation[ebObj.currentWave].sideQuestKillCountStart = ebObj.waveInformation[ebObj.currentWave].killCount;
						ebObj.waveInformation[ebObj.currentWave].sideQuestEstKillCountStart = ebObj.waveInformation[ebObj.currentWave].estKillCount;
						ebObj.waveInformation[ebObj.currentWave].sideQuestTimeStart = Turbine.Engine:GetGameTime();
					end
				end
			end
		
		-- Minas Tirith fix (1/2/16)
		elseif(ebObj ~= nil and (ebObj.spaceName == "Hammer of the Underworld - Solo/Duo" or ebObj.spaceName == "Hammer of the Underworld - Fellowship")) then
				-- 3rd phase ending
			if(args.Message:find(EBLangData.HammerPhase3End) ~= nil) then
				waveHasEnded();
			end
		
		end
				

		-- finds side quests when they start (won't need once the logging is no longer needed)
		--if(args.Message:find("New Quest:") ~= nil) and debuggingMode then
			--if ebObj ~= nil then
				--if ebObj.waveInformation[ebObj.currentWave] ~= nil then
					--ebObj.waveInformation[ebObj.currentWave].sideQuestKillCountStart = ebObj.waveInformation[ebObj.currentWave].killCount;
					--ebObj.waveInformation[ebObj.currentWave].sideQuestEstKillCountStart = ebObj.waveInformation[ebObj.currentWave].estKillCount;
					--ebObj.waveInformation[ebObj.currentWave].sideQuestTimeStart = Turbine.Engine:GetGameTime();
				--end
			--end

		--end
	
	elseif ebObj ~= nil then -- prevents errors when running EBP while not in an EB

		if ebObj.currentWave ~= 0 and (not ebObj.waveInformation[ebObj.currentWave].hasEnded) then

			if args.ChatType == Turbine.ChatType.PlayerCombat then
				-- check to see if it is an emeny dying out on the field
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
					
					-- Pel Fix
					elseif(args.Message:find(EBLangData.CorsairRaider, defeatedEndIndex, true) ~= nil) then
						if ebObj.waveInformation[ebObj.currentWave+1] ~= nil then
							ebObj:IncreaseKillCount(ebObj.currentWave+1, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave+1, defeatedNum);
						else
							ebObj:IncreaseKillCount(ebObj.currentWave, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave, defeatedNum);
						end
						
					elseif(args.Message:find(EBLangData.HaradrimMarksman, defeatedEndIndex, true) ~= nil) then
						if ebObj.waveInformation[ebObj.currentWave+1] ~= nil then
							ebObj:IncreaseKillCount(ebObj.currentWave+1, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave+1, defeatedNum);
						else
							ebObj:IncreaseKillCount(ebObj.currentWave, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave, defeatedNum);
						end
					
					elseif(args.Message:find(EBLangData.HaradrimMarauder, defeatedEndIndex, true) ~= nil) then
						if ebObj.waveInformation[ebObj.currentWave+1] ~= nil then
							ebObj:IncreaseKillCount(ebObj.currentWave+1, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave+1, defeatedNum);
						else
							ebObj:IncreaseKillCount(ebObj.currentWave, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave, defeatedNum);
						end
						
					elseif(args.Message:find(EBLangData.HalftrollCrusher, defeatedEndIndex) ~= nil) then
						if ebObj.waveInformation[ebObj.currentWave+1] ~= nil then
							ebObj:IncreaseKillCount(ebObj.currentWave+1, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave+1, defeatedNum);
						else
							ebObj:IncreaseKillCount(ebObj.currentWave, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave, defeatedNum);
						end
						
					elseif(args.Message:find(EBLangData.CorsairCaptain, defeatedEndIndex, true) ~= nil) then
						if ebObj.waveInformation[ebObj.currentWave+1] ~= nil then
							ebObj:IncreaseKillCount(ebObj.currentWave+1, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave+1, defeatedNum);
						else
							ebObj:IncreaseKillCount(ebObj.currentWave, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave, defeatedNum);
						end
						
					elseif(args.Message:find(EBLangData.HaradrimSorcerer, defeatedEndIndex, true) ~= nil) then
						if ebObj.waveInformation[ebObj.currentWave+1] ~= nil then
							ebObj:IncreaseKillCount(ebObj.currentWave+1, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave+1, defeatedNum);
						else
							ebObj:IncreaseKillCount(ebObj.currentWave, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave, defeatedNum);
						end
					
					-- Minas Tirith fix (1/2/16)
					elseif(args.Message:find(EBLangData.SuhalarReaver, defeatedEndIndex) ~= nil) then
						if ebObj.waveInformation[ebObj.currentWave+1] ~= nil then
							ebObj:IncreaseKillCount(ebObj.currentWave+1, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave+1, defeatedNum);
						else
							ebObj:IncreaseKillCount(ebObj.currentWave, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave, defeatedNum);
						end
					elseif(args.Message:find(EBLangData.SuhalarAxeThrower, defeatedEndIndex) ~= nil) then
						if ebObj.waveInformation[ebObj.currentWave+1] ~= nil then
							ebObj:IncreaseKillCount(ebObj.currentWave+1, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave+1, defeatedNum);
						else
							ebObj:IncreaseKillCount(ebObj.currentWave, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave, defeatedNum);
						end
					elseif(args.Message:find(EBLangData.SuhalarShieldsman, defeatedEndIndex) ~= nil) then
						if ebObj.waveInformation[ebObj.currentWave+1] ~= nil then
							ebObj:IncreaseKillCount(ebObj.currentWave+1, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave+1, defeatedNum);
						else
							ebObj:IncreaseKillCount(ebObj.currentWave, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave, defeatedNum);
						end
					elseif(args.Message:find(EBLangData.SuhalarBladeMaster, defeatedEndIndex) ~= nil) then
						if ebObj.waveInformation[ebObj.currentWave+1] ~= nil then
							ebObj:IncreaseKillCount(ebObj.currentWave+1, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave+1, defeatedNum);
						else
							ebObj:IncreaseKillCount(ebObj.currentWave, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave, defeatedNum);
						end
					elseif(args.Message:find(EBLangData.MordorSoldier, defeatedEndIndex, true) ~= nil) then
						if ebObj.waveInformation[ebObj.currentWave+1] ~= nil then
							ebObj:IncreaseKillCount(ebObj.currentWave+1, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave+1, defeatedNum);
						else
							ebObj:IncreaseKillCount(ebObj.currentWave, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave, defeatedNum);
						end
					elseif(args.Message:find(EBLangData.MordorDefiler, defeatedEndIndex, true) ~= nil) then
						if ebObj.waveInformation[ebObj.currentWave+1] ~= nil then
							ebObj:IncreaseKillCount(ebObj.currentWave+1, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave+1, defeatedNum);
						else
							ebObj:IncreaseKillCount(ebObj.currentWave, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave, defeatedNum);
						end
					elseif(args.Message:find(EBLangData.MordorWarrior, defeatedEndIndex, true) ~= nil) then
						if ebObj.waveInformation[ebObj.currentWave+1] ~= nil then
							ebObj:IncreaseKillCount(ebObj.currentWave+1, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave+1, defeatedNum);
						else
							ebObj:IncreaseKillCount(ebObj.currentWave, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave, defeatedNum);
						end
					elseif(args.Message:find(EBLangData.MordorDrudge, defeatedEndIndex, true) ~= nil) then
						if ebObj.waveInformation[ebObj.currentWave+1] ~= nil then
							ebObj:IncreaseKillCount(ebObj.currentWave+1, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave+1, defeatedNum);
						else
							ebObj:IncreaseKillCount(ebObj.currentWave, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave, defeatedNum);
						end
					elseif(args.Message:find(EBLangData.MordorWarleader, defeatedEndIndex, true) ~= nil) then
						if ebObj.waveInformation[ebObj.currentWave+1] ~= nil then
							ebObj:IncreaseKillCount(ebObj.currentWave+1, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave+1, defeatedNum);
						else
							ebObj:IncreaseKillCount(ebObj.currentWave, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave, defeatedNum);
						end
					elseif(args.Message:find(EBLangData.MorgulArcher, defeatedEndIndex, true) ~= nil) then
						if ebObj.waveInformation[ebObj.currentWave+1] ~= nil then
							ebObj:IncreaseKillCount(ebObj.currentWave+1, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave+1, defeatedNum);
						else
							ebObj:IncreaseKillCount(ebObj.currentWave, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave, defeatedNum);
						end
					elseif(args.Message:find(EBLangData.MorgulCaptain, defeatedEndIndex, true) ~= nil) then
						if ebObj.waveInformation[ebObj.currentWave+1] ~= nil then
							ebObj:IncreaseKillCount(ebObj.currentWave+1, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave+1, defeatedNum);
						else
							ebObj:IncreaseKillCount(ebObj.currentWave, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave, defeatedNum);
						end
					elseif(args.Message:find(EBLangData.MorgulRunner, defeatedEndIndex, true) ~= nil) then
						if ebObj.waveInformation[ebObj.currentWave+1] ~= nil then
							ebObj:IncreaseKillCount(ebObj.currentWave+1, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave+1, defeatedNum);
						else
							ebObj:IncreaseKillCount(ebObj.currentWave, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave, defeatedNum);
						end
					elseif(args.Message:find(EBLangData.MorgulBerserker, defeatedEndIndex, true) ~= nil) then
						if ebObj.waveInformation[ebObj.currentWave+1] ~= nil then
							ebObj:IncreaseKillCount(ebObj.currentWave+1, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave+1, defeatedNum);
						else
							ebObj:IncreaseKillCount(ebObj.currentWave, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave, defeatedNum);
						end
					elseif(args.Message:find(EBLangData.HaradrimSpearman, defeatedEndIndex, true) ~= nil) then
						if ebObj.waveInformation[ebObj.currentWave+1] ~= nil then
							ebObj:IncreaseKillCount(ebObj.currentWave+1, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave+1, defeatedNum);
						else
							ebObj:IncreaseKillCount(ebObj.currentWave, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave, defeatedNum);
						end
					elseif(args.Message:find(EBLangData.HaradrimWarmaster, defeatedEndIndex) ~= nil) then
						if ebObj.waveInformation[ebObj.currentWave+1] ~= nil then
							ebObj:IncreaseKillCount(ebObj.currentWave+1, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave+1, defeatedNum);
						else
							ebObj:IncreaseKillCount(ebObj.currentWave, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave, defeatedNum);
						end
					elseif(args.Message:find(EBLangData.HaradrimArcher, defeatedEndIndex, true) ~= nil) then
						if ebObj.waveInformation[ebObj.currentWave+1] ~= nil then
							ebObj:IncreaseKillCount(ebObj.currentWave+1, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave+1, defeatedNum);
						else
							ebObj:IncreaseKillCount(ebObj.currentWave, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave, defeatedNum);
						end
					elseif(args.Message:find(EBLangData.HalftrollSlayer, defeatedEndIndex) ~= nil) then
						if ebObj.waveInformation[ebObj.currentWave+1] ~= nil then
							ebObj:IncreaseKillCount(ebObj.currentWave+1, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave+1, defeatedNum);
						else
							ebObj:IncreaseKillCount(ebObj.currentWave, defeatedNum);
							ebObj:IncreaseEstKillCount(ebObj.currentWave, defeatedNum);
						end
					-- end Minas Tirith mobs
					
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
						
					elseif(args.Message:find("Corsair Raider", defeatedEndIndex, true) ~= nil) then
						ebObj:IncreaseKillCount(ebObj.currentWave, 1);
						setDelayTime();
						
					elseif(args.Message:find("Haradrim Marksman", defeatedEndIndex, true) ~= nil) then
						ebObj:IncreaseKillCount(ebObj.currentWave, 1);
						setDelayTime();
						
					elseif(args.Message:find("Haradrim Marauder", defeatedEndIndex, true) ~= nil) then
						ebObj:IncreaseKillCount(ebObj.currentWave, 1);
						setDelayTime();
						
					elseif(args.Message:find("Half%-troll Crusher", defeatedEndIndex) ~= nil) then
						ebObj:IncreaseKillCount(ebObj.currentWave, 1);
						setDelayTime();
						
					elseif(args.Message:find("Corsair Captain", defeatedEndIndex, true) ~= nil) then
						ebObj:IncreaseKillCount(ebObj.currentWave, 1);
						setDelayTime();
						
					elseif(args.Message:find("Haradrim Sorcerer", defeatedEndIndex, true) ~= nil) then
						ebObj:IncreaseKillCount(ebObj.currentWave, 1);
						setDelayTime();
						
					-- Minas Tirith fix (1/2/16)
					elseif(args.Message:find("S.-halar Reaver", defeatedEndIndex) ~= nil) then
						ebObj:IncreaseKillCount(ebObj.currentWave, 1);
						setDelayTime();
					elseif(args.Message:find("S.-halar Axe.Thrower", defeatedEndIndex) ~= nil) then
						ebObj:IncreaseKillCount(ebObj.currentWave, 1);
						setDelayTime();
					elseif(args.Message:find("S.-halar Shieldsman", defeatedEndIndex) ~= nil) then
						ebObj:IncreaseKillCount(ebObj.currentWave, 1);
						setDelayTime();
					elseif(args.Message:find("S.-halar Blade.master", defeatedEndIndex) ~= nil) then
						ebObj:IncreaseKillCount(ebObj.currentWave, 1);
						setDelayTime();
					elseif(args.Message:find("Mordor Solider", defeatedEndIndex, true) ~= nil) then
						ebObj:IncreaseKillCount(ebObj.currentWave, 1);
						setDelayTime();
					elseif(args.Message:find("Mordor Defiler", defeatedEndIndex, true) ~= nil) then
						ebObj:IncreaseKillCount(ebObj.currentWave, 1);
						setDelayTime();
					elseif(args.Message:find("Mordor Warrior", defeatedEndIndex, true) ~= nil) then
						ebObj:IncreaseKillCount(ebObj.currentWave, 1);
						setDelayTime();
					elseif(args.Message:find("Mordor Drudge", defeatedEndIndex, true) ~= nil) then
						ebObj:IncreaseKillCount(ebObj.currentWave, 1);
						setDelayTime();
					elseif(args.Message:find("Mordor Warleader", defeatedEndIndex, true) ~= nil) then
						ebObj:IncreaseKillCount(ebObj.currentWave, 1);
						setDelayTime();
					elseif(args.Message:find("Morgul Archer", defeatedEndIndex, true) ~= nil) then
						ebObj:IncreaseKillCount(ebObj.currentWave, 1);
						setDelayTime();
					elseif(args.Message:find("Morgul Captain", defeatedEndIndex, true) ~= nil) then
						ebObj:IncreaseKillCount(ebObj.currentWave, 1);
						setDelayTime();
					elseif(args.Message:find("Morgul Runner", defeatedEndIndex, true) ~= nil) then
						ebObj:IncreaseKillCount(ebObj.currentWave, 1);
						setDelayTime();
					elseif(args.Message:find("Morgul Berserker", defeatedEndIndex, true) ~= nil) then
						ebObj:IncreaseKillCount(ebObj.currentWave, 1);
						setDelayTime();
					elseif(args.Message:find("Haradrim Spearman", defeatedEndIndex, true) ~= nil) then
						ebObj:IncreaseKillCount(ebObj.currentWave, 1);
						setDelayTime();
					elseif(args.Message:find("Haradrim War.master", defeatedEndIndex) ~= nil) then
						ebObj:IncreaseKillCount(ebObj.currentWave, 1);
						setDelayTime();
					elseif(args.Message:find("Haradrim Archer", defeatedEndIndex, true) ~= nil) then
						ebObj:IncreaseKillCount(ebObj.currentWave, 1);
						setDelayTime();
					elseif(args.Message:find("Half.troll Slayer", defeatedEndIndex) ~= nil) then
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
				
			elseif ebObj.spaceName == "Retaking Pelargir - Solo/Duo" or ebObj.spaceName == "Retaking Pelargir - Fellowship" then
				-- 1st phase starting
				if(args.Message:find(EBLangData.PelPhase1Start, 1, true) ~= nil) then
					waveHasStarted("Phase 1");
				
				-- 2nd phase starting
				elseif(args.Message:find(EBLangData.PelPhase2Start, 1, true) ~= nil) then
					waveHasStarted("Phase 2");
					
				-- 3rd phase starting
				elseif(args.Message:find(EBLangData.PelPhase3Start, 1, true) ~= nil) then
					waveHasStarted("Phase 3");

				-- 1st phase ending
				elseif(args.Message:find(EBLangData.PelPhase1End, 1, true) ~= nil) then
					waveHasEnded();
				
				-- 2nd phase ending
				elseif(args.Message:find(EBLangData.PelPhase2End, 1, true) ~= nil) then
					waveHasEnded();
					
				-- 3rd phase ending
				elseif(args.Message:find(EBLangData.PelPhase3End, 1, true) ~= nil) then
					waveHasEnded();
				
				-- check to see if the secondary epic foes are starting
				elseif ebObj.waveInformation[ebObj.currentWave] ~= nil and EpicBattleData[ebObj.spaceName].sides[ebObj.waveInformation[ebObj.currentWave].side].wave[ebObj.currentWave].secondary ~= nil then
					if args.Message:find(EpicBattleData[ebObj.spaceName].sides[ebObj.waveInformation[ebObj.currentWave].side].wave[ebObj.currentWave].secondaryCallout) ~= nil then
						ebObj.waveInformation[ebObj.currentWave].killEndTime = Turbine.Engine:GetGameTime() + EpicBattleData[ebObj.spaceName].sides[ebObj.waveInformation[ebObj.currentWave].side].wave[ebObj.currentWave].secondaryTimeToKill;
						ebObj.waveInformation[ebObj.currentWave].isEpicFoe = 3;
						ebObj.waveInformation[ebObj.currentWave].foeName = EpicBattleData[ebObj.spaceName].sides[ebObj.waveInformation[ebObj.currentWave].side].wave[ebObj.currentWave].secondary;
						ebObj.waveInformation[ebObj.currentWave].part = 3;
						
						-- if we're debugging stuff, add the start time of the secondary foe
							if debuggingMode then
								ebObj.waveInformation[ebObj.currentWave].foeKillCountStart = ebObj.waveInformation[ebObj.currentWave].killCount;
								ebObj.waveInformation[ebObj.currentWave].foeEstKillCountStart = ebObj.waveInformation[ebObj.currentWave].estKillCount;
								ebObj.waveInformation[ebObj.currentWave].foeTimeStart = Turbine.Engine:GetGameTime();
							end
					end
				end
				
			-- Minas Tirith fix (1/2/16)
			elseif ebObj.spaceName == "Hammer of the Underworld - Solo/Duo" or ebObj.spaceName == "Hammer of the Underworld - Fellowship" then
				-- 1st phase starting
				if(args.Message:find(EBLangData.HammerPhase1Start, 1, true) ~= nil) then
					waveHasStarted("Phase 1");

				-- 1st phase ending (and 2nd phase starting)
				elseif(args.Message:find(EBLangData.HammerPhase1End, 1, true) ~= nil) then
					waveHasEnded();
					waveHasStarted("Phase 2");
				
				-- 2nd phase ending (and 3rd phase starting)
				elseif(args.Message:find(EBLangData.HammerPhase2End, 1, true) ~= nil) then
					waveHasEnded();
					waveHasStarted("Phase 3");
					
				-- 3rd phase ending
				elseif(args.Message:find(EBLangData.HammerPhase3End, 1, true) ~= nil) then
					waveHasEnded();
				end
				
			elseif ebObj.spaceName == "The Defence of Minas Tirith - Solo/Duo" or ebObj.spaceName == "The Defence of Minas Tirith - Small Fellowship" then
				-- 1st phase starting
				if(args.Message:find(EBLangData.DefencePhase1Start, 1, true) ~= nil) then
					waveHasStarted("Phase 1");

				-- 1st phase ending (and 2nd phase starting)
				elseif(args.Message:find(EBLangData.DefencePhase1End, 1, true) ~= nil) then
					waveHasEnded();
					waveHasStarted("Phase 2");
				
				-- 2nd phase ending
				elseif(args.Message:find(EBLangData.DefencePhase2End, 1, true) ~= nil) then
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
	if confirmHDSizeWindow ~= nil then
		confirmHDSizeWindow:SetVisible(false);
		confirmHDSizeWindow = nil;
	end

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