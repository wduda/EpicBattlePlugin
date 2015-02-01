import "SDRPlugins.EpicBattlePlugin";
import "Turbine.Gameplay";
import "Turbine.UI";
import "Turbine.UI.Lotro";
import "SDRPlugins.EpicBattlePlugin.ScalingLabel";
import "SDRPlugins.EpicBattlePlugin.OptionsWindow";

-- safely add a callback without overwriting any existing ones
function AddCallback(object, event, callback)
    if object[event] == nil then
        object[event] = callback;
    else
        if type(object[event]) == "table" then
            table.insert(object[event], callback);
        else
            object[event] = {object[event], callback};
        end
    end
end

-- safely remove a callback without clobbering any extras
function RemoveCallback(object, event, callback)
    if object[event] == callback then
        object[event] = nil;
    else
        if type(object[event]) == "table" then
            local size = table.getn(object[event]);
            for i = 1, size do
                if object[event][i] == callback then
                    table.remove(object[event], i);
                    break;
                end
            end
        end
    end
end

EBPlugin = class();

function EBPlugin:Constructor()
	OptionWindow = OptionWindow();

	import "SDRPlugins.EpicBattlePlugin.MainWindow";
end

function EBPlugin:RemoveCallbacks()
	RemoveCallback(Turbine.Chat, "Received", chatParser);
end

main = EBPlugin();

Turbine.Plugin.Load = function(self, sender, args)
	Turbine.Shell.WriteLine(self:GetName() .. " v" .. self:GetVersion() .. " by " .. self:GetAuthor() .. "; German Translations by Burgus;" .. " has loaded!");
	Version = self:GetVersion();
end

Turbine.Plugin.Unload = function(self, sender, args)
	main:RemoveCallbacks();
	-- save data
	saveState();
	-- do anything else needed
	OptionWindow:Close();
	collectgarbage();
end

---[[ create a new command line command for EBP options
if debuggingMode then
	EBPCommand = Turbine.ShellCommand();

	-- handle the chat commands
	function EBPCommand:Execute( name, shellCommand )
		if shellCommand == "data" then
			for i=1, #pastEpicBattles do
				printData(i);
			end
		elseif shellCommand == "delete" then
			pastEpicBattles = {};
		elseif shellCommand == "options" then
			OptionWindow:Show();
		elseif shellCommand == "memory" then
			Turbine.Shell.WriteLine(collectgarbage("count"));
		else 
			EBPCommand:GetHelp();
		end
	end

	-- The Help text that outputs when /ebp is typed
	help = "EpicBattlePlugin has the following command:\n" ..
		"   data - prints out the data.\n" ..
		"   delete - deletes EpicBattlePlugin saved data" ..
		"   options - shows the options for EBP";

	function EBPCommand:GetHelp()
		Turbine.Shell.WriteLine( help );
	end

	function printData(battleIndex)
		Turbine.Shell.WriteLine("#" .. battleIndex .. " Instance: " .. pastEpicBattles[battleIndex].spaceName);
		Turbine.Shell.WriteLine("   Total Waves: " .. pastEpicBattles[battleIndex].waves);
		Turbine.Shell.WriteLine("   Current Wave: " .. pastEpicBattles[battleIndex].currentWave);
		for i=1, pastEpicBattles[battleIndex].currentWave do
			Turbine.Shell.WriteLine("   Side: " .. pastEpicBattles[battleIndex].waveInformation[i].side);
			if pastEpicBattles[battleIndex].waveInformation[i].sideQuestTimeStart ~= nil then
				Turbine.Shell.WriteLine("      Start Time to Quest Start Time: " .. round((pastEpicBattles[battleIndex].waveInformation[i].sideQuestTimeStart - pastEpicBattles[battleIndex].waveInformation[i].startTime), 0));
			end
			if pastEpicBattles[battleIndex].waveInformation[i].endTime ~= nil then
				Turbine.Shell.WriteLine("      Estimated Wave Duration: " .. round((pastEpicBattles[battleIndex].waveInformation[i].endTime - pastEpicBattles[battleIndex].waveInformation[i].startTime), 0));
			end
			if pastEpicBattles[battleIndex].waveInformation[i].actualEndTime ~= nil then
				Turbine.Shell.WriteLine("      Actual Wave Duration: " .. round((pastEpicBattles[battleIndex].waveInformation[i].actualEndTime - pastEpicBattles[battleIndex].waveInformation[i].startTime), 0));
		end
			if pastEpicBattles[battleIndex].waveInformation[i].sideQuestKillCountStart ~= nil then
				Turbine.Shell.WriteLine("      Actual Kill Count at Side Quest Start: " .. pastEpicBattles[battleIndex].waveInformation[i].sideQuestKillCountStart);
			end
			if pastEpicBattles[battleIndex].waveInformation[i].sideQuestEstKillCountStart ~= nil then
				Turbine.Shell.WriteLine("      Estimated Kill Count at Side Quest Start: " .. round(pastEpicBattles[battleIndex].waveInformation[i].sideQuestEstKillCountStart));
			end
			if pastEpicBattles[battleIndex].waveInformation[i].sideQuestStart ~= nil then
				Turbine.Shell.WriteLine("      Needed Est Kill Count: " .. pastEpicBattles[battleIndex].waveInformation[i].sideQuestStart);
			end
			if pastEpicBattles[battleIndex].waveInformation[i].delayCalc ~= nil then
				Turbine.Shell.WriteLine("      Delay between wave start and first kill: " .. round(pastEpicBattles[battleIndex].waveInformation[i].delayCalc - pastEpicBattles[battleIndex].waveInformation[i].startTime));
			end
			if pastEpicBattles[battleIndex].waveInformation[i].hasEnded then
				Turbine.Shell.WriteLine("      Wave successfully ended.");
			else Turbine.Shell.WriteLine("      Wave did not successfully end.");
			end
		end
	end

	-- add the command to the shell
	Turbine.Shell.AddCommand( "ebp", EBPCommand );

else -- add /ebp options command for non-debugging versions
	EBPCommand = Turbine.ShellCommand();

	-- handle the chat commands
	function EBPCommand:Execute( name, shellCommand )
		if shellCommand == EBLangData.OptionsCommand then
			OptionWindow:Show();
		elseif shellCommand == "memory" then
			Turbine.Shell.WriteLine(collectgarbage("count"));
		else 
			EBPCommand:GetHelp();
		end
	end

	-- The Help text that outputs when /ebp is typed;
	function EBPCommand:GetHelp()
		Turbine.Shell.WriteLine( EBLangData.HelpOutput );
	end

	-- add the command to the shell
	Turbine.Shell.AddCommand( "ebp", EBPCommand );
end
--]]--