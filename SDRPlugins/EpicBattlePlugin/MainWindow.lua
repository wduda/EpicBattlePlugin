import "Turbine";
import "Turbine.Gameplay";
import "Turbine.UI";
import "Turbine.UI.Lotro";

-- General functions
function round(num, idp)
  local mult = 10^(idp or 0);
  return math.floor(num * mult + 0.5) / mult;
end

function styleLabel(lbl, x, y, w, h, font, color, align, text)
	lbl:SetPosition(x,y);
	lbl:SetSize(w,h);
	lbl:SetFont(font);
	lbl:SetText(text);
	lbl:SetTextAlignment(align);
	lbl:SetForeColor(color);
	lbl:SetMouseVisible(false);
	lbl:SetZOrder(3);
end

function getMinsAndSeconds(totalSeconds)
	totalSeconds = round(totalSeconds, 0);
	local secRemaining = totalSeconds % 60;
	local minsRemaining = (totalSeconds - secRemaining) / 60;
	return minsRemaining, secRemaining;
end

-- Window Dragging functions
is_dragging = false;
function startDrag(sender, args)
	if ( args.Button ~= Turbine.UI.MouseButton.Left ) then return; end
	startX = args.X;
	startY = args.Y;
	is_dragging = true;
end

winHasMoved = false;
function endDrag(sender, args)
	if ( is_dragging ) then
		main_window:SetLeft(main_window:GetLeft() + (args.X - startX));
		main_window:SetTop(main_window:GetTop() + (args.Y - startY));
		is_dragging = false;
		if main_window:GetLeft() < 0 then
			main_window:SetLeft(0);
		elseif main_window:GetLeft() + main_window:GetWidth() > Turbine.UI.Display:GetWidth() then
			main_window:SetLeft(Turbine.UI.Display:GetWidth()-main_window:GetWidth());
		end
		if main_window:GetTop() < 0 then
			main_window:SetTop(0);
		elseif main_window:GetTop() + main_window:GetHeight() > Turbine.UI.Display:GetHeight() then
			main_window:SetTop(Turbine.UI.Display:GetHeight()-main_window:GetHeight());
		end
		if winHasMoved and OptionWindow.saveCallsToggle:IsChecked() then saveState(); end
		winHasMoved = false;
	end
end

function doDrag(sender, args)
	if ( is_dragging ) then
		main_window:SetLeft(main_window:GetLeft() + (args.X - startX));
		main_window:SetTop(main_window:GetTop() + (args.Y - startY));
		winHasMoved = true;
	end
end

function attachDragListener(target)
	target.MouseDown = startDrag;
	target.MouseUp = endDrag;
	target.MouseMove = doDrag;
end

-- Persistance functions
function saveState()
	local obj = Turbine.Object();
	-- place needed variables into obj here
	obj.window_x = main_window:GetTop();
	obj.window_y = main_window:GetLeft();
	obj.startWinMin = OptionWindow.loadMinToggle:IsChecked();
	obj.opacity = OptionWindow.transparencyScrollbar:GetValue()/100;
	obj.scaleWindow = OptionWindow.scaleScrollbar:GetValue();
	obj.minAfterBattle = OptionWindow.minAfterBattleToggle:IsChecked();
	obj.maxForBattle = OptionWindow.maxForBattleToggle:IsChecked();
	obj.additionalSaves = OptionWindow.saveCallsToggle:IsChecked();
	if hasDWRA then obj.loadDWRA = OptionWindow.loadDWRAToggle:IsChecked(); end
	if pastEpicBattles ~= nil and debuggingMode then
		Turbine.PluginData.Save(Turbine.DataScope.Account, "EBPData", pastEpicBattles, nil);
	end
	pcall(function() PatchDataSave( Turbine.DataScope.Character, "EBPSaveData", obj) end);
end

function loadState()
	local euroFormat=(tonumber("1,000")==1); -- will be true if the number is formatted with a comma for decimal place, false otherwise
	-- create a function for automatically converting a number in string format to its correct numeric value
	if euroFormat then
 		function euroNormalize(value)
   			return tonumber((string.gsub(value,"%.",",")));
		end
	else
   		function euroNormalize(value)
   			return tonumber((string.gsub(value,",",".")));
  		end
	end
	pcall(
		function () 
			local persist = PatchDataLoad( Turbine.DataScope.Character, "EBPSaveData");
			if persist ~= nil then
				-- set required variables here

				-- set window position
				persist.window_x = euroNormalize(persist.window_x) or 150;
				persist.window_y = euroNormalize(persist.window_y) or 150;
				main_window:SetTop(persist.window_x);
				main_window:SetLeft(persist.window_y);

				-- set if window should start minimized
				persist.startWinMin = persist.startWinMin or false;
				if persist.startWinMin then
					main_window:SetSize(20,20);
					winIsMin = true;
					OptionWindow.loadMinToggle:SetChecked(true);
				end

				-- set window opacity
				persist.opacity = euroNormalize(persist.opacity) or 100;
				if not persist.startWinMin then
					main_window:SetOpacity(persist.opacity);
				end
				OptionWindow.transparencyScrollbar:SetValue(persist.opacity * 100);

				-- set window scale
				persist.scaleWindow = euroNormalize(persist.scaleWindow) or 100;
				if persist.scaleWindow < 100 and not persist.startWinMin then scaleMainWindow(persist.scaleWindow); end
				OptionWindow.scaleScrollbar:SetValue(persist.scaleWindow);

				-- set if window should minimize after a battle
				persist.minAfterBattle = persist.minAfterBattle or false;
				OptionWindow.minAfterBattleToggle:SetChecked(persist.minAfterBattle);

				-- set if a window should maximize on the start of a battle
				persist.maxForBattle = persist.maxForBattle or false;
				OptionWindow.maxForBattleToggle:SetChecked(persist.maxForBattle);

				-- set if the plugin should make additional save calls
				persist.additionalSaves = persist.additionalSaves or false;
				OptionWindow.saveCallsToggle:SetChecked(persist.additionalSaves);

				-- set if DWRA should be loaded
				persist.loadDWRA = persist.loadDWRA or false;
				OptionWindow.loadDWRAToggle:SetChecked(persist.loadDWRA);
				if persist.loadDWRA then
					--Turbine.PluginManager.LoadPlugin("DeepingWallRaidAssistant");
				end
			end
		end
	);
	if debuggingMode then pastEpicBattles = Turbine.PluginData.Load(Turbine.DataScope.Account, "EBPData", nil); end
end

-- scale the window function

function scaleMainWindow(scale)
	if scale < 50 then scale = 50; end
	if scale > 100 then scale = 100; end
	scale = scale / 100;

	-- scale each element (other than the minimize button)
	main_window:SetSize(450*scale,135*scale);
	epicBattleLabel:SetSize(450*scale, 20*scale);
	waveLabel:SetSize(75*scale, 20*scale);
	waveLabel:SetPosition(0,epicBattleLabel:GetTop()+epicBattleLabel:GetHeight());
	wave1Label:SetSize(40*scale, 20*scale);
	wave2Label:SetSize(40*scale, 20*scale);
	wave3Label:SetSize(40*scale, 20*scale);
	wave1Label:SetPosition(waveLabel:GetWidth(),epicBattleLabel:GetTop()+epicBattleLabel:GetHeight());
	wave2Label:SetPosition(wave1Label:GetLeft() + wave1Label:GetWidth(),epicBattleLabel:GetTop()+epicBattleLabel:GetHeight());
	wave3Label:SetPosition(wave2Label:GetLeft() + wave2Label:GetWidth(),epicBattleLabel:GetTop()+epicBattleLabel:GetHeight());
	infoLabel:SetSize(255*scale, 20*scale);
	local rowWidth = waveLabel:GetWidth()+wave1Label:GetWidth()+wave2Label:GetWidth()+wave3Label:GetWidth()+infoLabel:GetWidth();
	-- to make sure each row the same width, make sure the last label is wide enough to fill the rest of the room
	if (rowWidth<epicBattleLabel:GetWidth()) then
		infoLabel:SetWidth(epicBattleLabel:GetWidth()-(rowWidth-infoLabel:GetWidth()));
	end
	infoLabel:SetPosition(wave3Label:GetLeft() + wave3Label:GetWidth(),epicBattleLabel:GetTop()+epicBattleLabel:GetHeight());
	timerLabel:SetSize(115*scale, 15*scale);
	timerLabel:SetPosition(0,waveLabel:GetTop()+waveLabel:GetHeight());
	killCountLabel:SetSize(135*scale, 15*scale);
	killCountLabel:SetPosition(timerLabel:GetLeft() + timerLabel:GetWidth(),waveLabel:GetTop()+waveLabel:GetHeight());
	killQuestCountLabel:SetSize(200*scale, 15*scale);
	killQuestCountLabel:SetPosition(killCountLabel:GetLeft() + killCountLabel:GetWidth(),waveLabel:GetTop()+waveLabel:GetHeight());
	local rowWidth = timerLabel:GetWidth()+killCountLabel:GetWidth()+killQuestCountLabel:GetWidth();
	if (rowWidth<epicBattleLabel:GetWidth()) then
		killQuestCountLabel:SetWidth(epicBattleLabel:GetWidth()-(rowWidth-killQuestCountLabel:GetWidth()));
	end
	questLabel:SetSize(450*scale, 20*scale);
	questLabel:SetPosition(0,timerLabel:GetTop()+timerLabel:GetHeight());
	quest1Label:SetSize(450*scale, 15*scale);
	quest1Label:SetPosition(0,questLabel:GetTop()+questLabel:GetHeight());
	quest2Label:SetSize(450*scale, 15*scale);
	quest2Label:SetPosition(0,quest1Label:GetTop()+quest1Label:GetHeight());
	quest3Label:SetSize(450*scale, 15*scale);
	quest3Label:SetPosition(0,quest2Label:GetTop()+quest2Label:GetHeight());
	quest1Control:SetSize(450*scale, 15*scale);
	--quest1Control:SetPosition(0,questLabel:GetTop()+questLabel:GetHeight());
	quest2Control:SetSize(450*scale, 15*scale);
	--quest2Control:SetPosition(0,quest1Label:GetTop()+quest1Label:GetHeight());
	quest3Control:SetSize(450*scale, 15*scale);
	--quest3Control:SetPosition(0,quest2Label:GetTop()+quest2Label:GetHeight());
	trapsLabel:SetSize(50*scale, 15*scale);
	trapsLabel:SetPosition(0,quest3Label:GetTop()+quest3Label:GetHeight());
	trap1Label:SetSize(133*scale, 15*scale);
	trap2Label:SetSize(134*scale, 15*scale);
	trap3Label:SetSize(133*scale, 15*scale);
	local rowWidth = trapsLabel:GetWidth()+trap1Label:GetWidth()+trap2Label:GetWidth()+trap3Label:GetWidth();
	if (rowWidth<epicBattleLabel:GetWidth()) then
		trap3Label:SetWidth(epicBattleLabel:GetWidth()-(rowWidth-trap3Label:GetWidth()));
	end
	trap1Label:SetPosition(trapsLabel:GetLeft()+trapsLabel:GetWidth(),quest3Label:GetTop()+quest3Label:GetHeight());
	trap2Label:SetPosition(trap1Label:GetLeft()+trap1Label:GetWidth(),quest3Label:GetTop()+quest3Label:GetHeight());
	trap3Label:SetPosition(trap2Label:GetLeft()+trap2Label:GetWidth(),quest3Label:GetTop()+quest3Label:GetHeight());
	resizingControl:SetPosition(main_window:GetWidth()-15,main_window:GetHeight()-15);

	-- calculate what size the font needs to be in order to fit into the window
	epicBattleLabel:CalcSmallestFont("TrajanProBold", 22, true);
	waveLabel:CalcSmallestFont("TrajanProBold", 16, true);
	wave1Label:CalcSmallestFont("TrajanProBold", 16, true);
	wave2Label:CalcSmallestFont("TrajanProBold", 16, true);
	wave3Label:CalcSmallestFont("TrajanProBold", 16, true);
	infoLabel:CalcSmallestFont("TrajanPro", 13, true);
	timerLabel:CalcSmallestFont("TrajanPro", 15, true);
	killCountLabel:CalcSmallestFont("TrajanPro", 15, true);
	killQuestCountLabel:CalcSmallestFont("TrajanPro", 15, true);
	questLabel:CalcSmallestFont("TrajanProBold", 16, true);
	quest1Label:CalcSmallestFont("TrajanPro", 15, true);
	quest2Label:CalcSmallestFont("TrajanPro", 15, true);
	quest3Label:CalcSmallestFont("TrajanPro", 15, true);
	trapsLabel:CalcSmallestFont("TrajanPro", 15, true);
	trap1Label:CalcSmallestFont("TrajanPro", 15, true);
	trap2Label:CalcSmallestFont("TrajanPro", 15, true);
	trap3Label:CalcSmallestFont("TrajanPro", 15, true);
end

-- Window functions
function createMainWindow()
	-- main window
	main_window = Turbine.UI.Window();
	main_window:SetPosition(150,150);
	main_window:SetSize(450,135);
	attachDragListener(main_window);
	main_window.MouseClick = showContextMenu;

	minimizeControl = Turbine.UI.Control();
	minimizeControl:SetSize(20, 20);
	minimizeControl:SetParent(main_window);
	minimizeControl:SetVisible(true);
	minimizeControl:SetPosition(0,0);
	minimizeControl:SetBackground("SDRPlugins/EpicBattlePlugin/EBP_symbol.jpg");
	minimizeControl:SetZOrder(100);
	attachDragListener(minimizeControl);
	minimizeControl.MouseClick = showContextMenu;
	
	winIsMin = false;
	minimizeControl.MouseDoubleClick = function(sender, args)
		if winIsMin then
			scaleMainWindow(OptionWindow.scaleScrollbar:GetValue());
			main_window:SetOpacity(OptionWindow.transparencyScrollbar:GetValue()/100);
		else
			main_window:SetSize(20,20);
			main_window:SetOpacity(1);
		end
		winIsMin = not winIsMin;
	end

	-- Create labels for data here

	-- label that says "Epic Battle: " then the actual epic battle space we are in, " - ", then the size we are in
	-- for example, "Epic Battle: Helm's Dike - Solo/Duo"
	epicBattleLabel = ScalingLabel();
	epicBattleLabel:SetMultiline(false);
	styleLabel(epicBattleLabel, 0, 0, 450, 20, Turbine.UI.Lotro.Font.TrajanProBold22, Turbine.UI.Color(0,0,0), Turbine.UI.ContentAlignment.MiddleCenter, EBLangData.EpicBattleHeader);
	epicBattleLabel:CalcSmallestFontW("TrajanProBold", 22);
	epicBattleLabel:SetBackColor(Turbine.UI.Color(.9,.9,.9));
	epicBattleLabel:SetParent(main_window);

	-- label that says "Waves:"
	waveLabel = ScalingLabel();
	waveLabel:SetMultiline(false);
	styleLabel(waveLabel, 0, 20, 75, 20, Turbine.UI.Lotro.Font.TrajanProBold16, Turbine.UI.Color(0,0,0), Turbine.UI.ContentAlignment.MiddleCenter, EBLangData.WaveLabel);
	waveLabel:CalcSmallestFontW("TrajanProBold", 16);
	waveLabel:SetBackColor(Turbine.UI.Color(.8,.8,.8));
	waveLabel:SetParent(main_window);

	wave1Label = ScalingLabel();
	wave1Label:SetMultiline(false);
	styleLabel(wave1Label, 75, 20, 40, 20, Turbine.UI.Lotro.Font.TrajanProBold16, Turbine.UI.Color(0,0,0), Turbine.UI.ContentAlignment.MiddleCenter, EBLangData.Wave1Label);
	wave1Label:CalcSmallestFontW("TrajanProBold", 16);
	wave1Label:SetBackColor(Turbine.UI.Color(.7,.7,.7));
	wave1Label:SetParent(main_window);

	wave2Label = ScalingLabel();
	wave2Label:SetMultiline(false);
	styleLabel(wave2Label, 115, 20, 40, 20, Turbine.UI.Lotro.Font.TrajanProBold16, Turbine.UI.Color(0,0,0), Turbine.UI.ContentAlignment.MiddleCenter, EBLangData.Wave2Label);
	wave2Label:CalcSmallestFontW("TrajanProBold", 16);
	wave2Label:SetBackColor(Turbine.UI.Color(.7,.7,.7));
	wave2Label:SetParent(main_window);

	wave3Label = ScalingLabel();
	wave3Label:SetMultiline(false);
	styleLabel(wave3Label, 155, 20, 40, 20, Turbine.UI.Lotro.Font.TrajanProBold16, Turbine.UI.Color(0,0,0), Turbine.UI.ContentAlignment.MiddleCenter, EBLangData.Wave3Label);
	wave3Label:CalcSmallestFontW("TrajanProBold", 16);
	wave3Label:SetBackColor(Turbine.UI.Color(.7,.7,.7));
	wave3Label:SetParent(main_window);

	infoLabel = ScalingLabel();
	infoLabel:SetMultiline(false);
	styleLabel(infoLabel, 195, 20, 255, 20, Turbine.UI.Lotro.Font.TrajanPro13, Turbine.UI.Color(0,0,0), Turbine.UI.ContentAlignment.MiddleCenter, EBLangData.InfoLabel);
	infoLabel:CalcSmallestFontW("TrajanPro", 13);
	infoLabel:SetBackColor(Turbine.UI.Color(1,.9,.9));
	infoLabel:SetParent(main_window);

	-- label that says "Ends In: " then a countdown to the end of the wave
	-- for example, "Ends In: 5:01"
	timerLabel = ScalingLabel();
	timerLabel:SetMultiline(false);
	styleLabel(timerLabel, 0, 40, 115, 15, Turbine.UI.Lotro.Font.TrajanPro15, Turbine.UI.Color(0,0,0), Turbine.UI.ContentAlignment.MiddleCenter, EBLangData.EndsIn .. EBLangData.NotAvailable);
	timerLabel:CalcSmallestFontW("TrajanPro", 15);
	timerLabel:SetBackColor(Turbine.UI.Color(1,.9,.9));
	timerLabel:SetParent(main_window);

	-- label that says "Kill Count: " then the kill count
	-- for example, "Kill Count: 152"
	killCountLabel = ScalingLabel();
	killCountLabel:SetMultiline(false);
	styleLabel(killCountLabel, 115, 40, 135, 15, Turbine.UI.Lotro.Font.TrajanPro15, Turbine.UI.Color(0,0,0), Turbine.UI.ContentAlignment.MiddleCenter, EBLangData.KillCount .. EBLangData.NotAvailable);
	killCountLabel:CalcSmallestFontW("TrajanPro", 15);
	killCountLabel:SetBackColor(Turbine.UI.Color(1,.9,.9));
	killCountLabel:SetParent(main_window);

	-- label that says "til Side Quest Starts: " then a countdown til the side quest starts based off kills
	-- for example, "til Side Quest Starts: 2:30"
	killQuestCountLabel = ScalingLabel();
	killQuestCountLabel:SetMultiline(false);
	styleLabel(killQuestCountLabel, 250, 40, 200, 15, Turbine.UI.Lotro.Font.TrajanPro15, Turbine.UI.Color(0,0,0), Turbine.UI.ContentAlignment.MiddleCenter, EBLangData.TilSideQuestStarts .. EBLangData.NotAvailable);
	killQuestCountLabel:CalcSmallestFontW("TrajanPro", 15);
	killQuestCountLabel:SetBackColor(Turbine.UI.Color(1,.9,.9));
	killQuestCountLabel:SetParent(main_window);

	-- label that says "Quests"
	questLabel = ScalingLabel();
	questLabel:SetMultiline(false);
	styleLabel(questLabel, 0, 55, 450, 20, Turbine.UI.Lotro.Font.TrajanProBold16, Turbine.UI.Color(0,0,0), Turbine.UI.ContentAlignment.MiddleCenter, EBLangData.QuestLabel);
	questLabel:CalcSmallestFontW("TrajanProBold", 16);
	questLabel:SetBackColor(Turbine.UI.Color(.8,.8,.8));
	questLabel:SetParent(main_window);

	-- label that says "1st Quest: " then the first quest name
	quest1Label = ScalingLabel();
	quest1Label:SetMultiline(false);
	styleLabel(quest1Label, 0, 75, 450, 15, Turbine.UI.Lotro.Font.TrajanPro15, Turbine.UI.Color(0,0,0), Turbine.UI.ContentAlignment.MiddleCenter, EBLangData.FirstQuestLabel .. "[" .. EBLangData.QuestName .. "]");
	quest1Label:CalcSmallestFontW("TrajanPro", 15);
	quest1Label:SetBackColor(Turbine.UI.Color(.7,.7,.7));
	quest1Label:SetParent(main_window);

	quest1Control = Turbine.UI.Control();
	quest1Control:SetSize(450, 15);
	quest1Control:SetParent(quest1Label);
	quest1Control:SetVisible(true);
	quest1Control:SetPosition(0,0);
	attachDragListener(quest1Control);
	quest1Control.MouseClick = showContextMenu;

	-- creates the hint for the first quest label
	quest1Control.MouseHover = function( sender, args )
		if ebObj ~= nil and quest1Control.tooltip == nil then
			quest1Control.tooltip = createQuestTooltip(sender, 1, args);
		end
	end

	-- when the mouse leaves the quickslot, make the window nil to close the tooltip
	quest1Control.MouseLeave = function( sender, args )
		if quest1Control.tooltip ~= nil then
			quest1Control.tooltip:Close();
			quest1Control.tooltip = nil;
		end
	end

	-- label that says "2nd Quest: " then the second quest name
	quest2Label = ScalingLabel();
	quest2Label:SetMultiline(false);
	styleLabel(quest2Label, 0, 90, 450, 15, Turbine.UI.Lotro.Font.TrajanPro15, Turbine.UI.Color(0,0,0), Turbine.UI.ContentAlignment.MiddleCenter, EBLangData.SecondQuestLabel .. "[" .. EBLangData.QuestName .. "]");
	quest2Label:CalcSmallestFontW("TrajanPro", 15);
	quest2Label:SetBackColor(Turbine.UI.Color(.7,.7,.7));
	quest2Label:SetParent(main_window);

	quest2Control = Turbine.UI.Control();
	quest2Control:SetSize(450, 15);
	quest2Control:SetParent(quest2Label);
	quest2Control:SetVisible(true);
	quest2Control:SetPosition(0,0);
	attachDragListener(quest2Control);
	quest2Control.MouseClick = showContextMenu;

	-- creates the hint for the first quest label
	quest2Control.MouseHover = function( sender, args )
		if ebObj ~= nil and quest2Control.tooltip == nil then
			quest2Control.tooltip = createQuestTooltip(sender, 2, args);
		end
	end

	-- when the mouse leaves the quickslot, make the window nil to close the tooltip
	quest2Control.MouseLeave = function( sender, args )
		if quest2Control.tooltip ~= nil then
			quest2Control.tooltip:Close();
			quest2Control.tooltip = nil;
		end
	end

	-- label that says "3rd Quest: " then the third quest name
	quest3Label = ScalingLabel();
	quest3Label:SetMultiline(false);
	styleLabel(quest3Label, 0, 105, 450, 15, Turbine.UI.Lotro.Font.TrajanPro15, Turbine.UI.Color(0,0,0), Turbine.UI.ContentAlignment.MiddleCenter, EBLangData.ThirdQuestLabel .. "[" .. EBLangData.QuestName .. "]");
	quest3Label:CalcSmallestFontW("TrajanPro", 15);
	quest3Label:SetBackColor(Turbine.UI.Color(.7,.7,.7));
	quest3Label:SetParent(main_window);

	quest3Control = Turbine.UI.Control();
	quest3Control:SetSize(450, 15);
	quest3Control:SetParent(quest3Label);
	quest3Control:SetVisible(true);
	quest3Control:SetPosition(0,0);
	attachDragListener(quest3Control);
	quest3Control.MouseClick = showContextMenu;

	-- creates the hint for the first quest label
	quest3Control.MouseHover = function( sender, args )
		if ebObj ~= nil and quest3Control.tooltip == nil then
			quest3Control.tooltip = createQuestTooltip(sender, 3, args);
		end
	end

	-- when the mouse leaves the quickslot, make the window nil to close the tooltip
	quest3Control.MouseLeave = function( sender, args )
		if quest3Control.tooltip ~= nil then
			quest3Control.tooltip:Close();
			quest3Control.tooltip = nil;
		end
	end

	trapsTable = {};

	-- label that says "Traps: "
	trapsLabel = ScalingLabel();
	trapsLabel:SetMultiline(false);
	styleLabel(trapsLabel, 0, 120, 50, 15, Turbine.UI.Lotro.Font.TrajanPro15, Turbine.UI.Color(0,0,0), Turbine.UI.ContentAlignment.MiddleCenter, EBLangData.TrapsLabel);
	trapsLabel:CalcSmallestFontW("TrajanPro", 15);
	trapsLabel:SetBackColor(Turbine.UI.Color(.9,.9,.9));
	trapsLabel:SetParent(main_window);

	-- label for the oldest trap
	trap1Label = ScalingLabel();
	trap1Label:SetMultiline(false);
	styleLabel(trap1Label, 50, 120, 133, 15, Turbine.UI.Lotro.Font.TrajanPro15, Turbine.UI.Color(0,0,0), Turbine.UI.ContentAlignment.MiddleCenter, EBLangData.NoneLabel);
	trap1Label:CalcSmallestFontW("TrajanPro", 15);
	trap1Label:SetBackColor(Turbine.UI.Color(.9,1,1));
	trap1Label:SetParent(main_window);

	-- label for the 2nd oldest trap
	trap2Label = ScalingLabel();
	trap2Label:SetMultiline(false);
	styleLabel(trap2Label, 183, 120, 134, 15, Turbine.UI.Lotro.Font.TrajanPro15, Turbine.UI.Color(0,0,0), Turbine.UI.ContentAlignment.MiddleCenter, EBLangData.NoneLabel);
	trap2Label:CalcSmallestFontW("TrajanPro", 15);
	trap2Label:SetBackColor(Turbine.UI.Color(1,.9,1));
	trap2Label:SetParent(main_window);

	-- label for the 3rd oldest trap
	trap3Label = ScalingLabel();
	trap3Label:SetMultiline(false);
	styleLabel(trap3Label, 317, 120, 133, 15, Turbine.UI.Lotro.Font.TrajanPro15, Turbine.UI.Color(0,0,0), Turbine.UI.ContentAlignment.MiddleCenter, EBLangData.NoneLabel);
	trap3Label:CalcSmallestFontW("TrajanPro", 15);
	trap3Label:SetBackColor(Turbine.UI.Color(1,1,.9));
	trap3Label:SetParent(main_window);

	-- create a resizing control
	resizingControl = Turbine.UI.Label();
	resizingControl:SetZOrder(100);
	resizingControl:SetSize(15, 15);
	resizingControl:SetParent(main_window);
	resizingControl:SetVisible(true);
	resizingControl:SetPosition(main_window:GetWidth()-15,main_window:GetHeight()-15);
	resizingControl.MouseClick = showContextMenu;

	resizingControl.MouseDown = function(sender, args)
		if ( args.Button ~= Turbine.UI.MouseButton.Left ) then return; end
		resizingControl.startX, resizingControl.startY = sender:GetMousePosition();
		resizingControl.startX, resizingControl.startY = sender:PointToScreen(resizingControl.startX, resizingControl.startY);
		resizingControl.is_dragging = true;
	end

	resizingControl.resizeHasOccurred = false;
	resizingControl.MouseMove = function(sender, args)
		if ( resizingControl.is_dragging ) then
			local mouseX, mouseY = sender:GetMousePosition();
			mouseX, mouseY = sender:PointToScreen(mouseX, mouseY);
			if mouseX < resizingControl.startX and mouseY < resizingControl.startY then -- the user is making the window smaller
				local distance = math.sqrt((mouseX - resizingControl.startX)^2 + (mouseY - resizingControl.startY)^2);
				resizingControl.newScale = OptionWindow.scaleScrollbar:GetValue() - (distance * 0.213);
				scaleMainWindow(resizingControl.newScale);
			elseif mouseX > resizingControl.startX and mouseY > resizingControl.startY then -- the user is making the window larger
				local distance = math.sqrt((mouseX - resizingControl.startX)^2 + (mouseY - resizingControl.startY)^2);
				resizingControl.newScale = OptionWindow.scaleScrollbar:GetValue() + (distance * 0.213);
				scaleMainWindow(resizingControl.newScale);
			end
			resizingControl.resizeHasOccurred = true;
		end
	end

	resizingControl.MouseUp = function(sender, args)
		if ( resizingControl.is_dragging ) then
			resizingControl.is_dragging = false;
			-- set scrollbar in optionswindow to correct value
			OptionWindow.scaleScrollbar:SetValue(resizingControl.newScale);
			if resizingControl.resizeHasOccurred and OptionWindow.saveCallsToggle:IsChecked() then saveState(); end
			resizingControl.resizeHasOccurred = false;
		end
	end

	-- shows the resizing button when the mouse enters the area
	resizingControl.MouseEnter = function( sender, args )
		resizingControl:SetBackColor(Turbine.UI.Color(0,1,0));
	end

	-- when the mouse leaves the resizing button area, hide it
	resizingControl.MouseLeave = function( sender, args )
		resizingControl:SetBackColor(nil);
	end

	import "SDRPlugins.EpicBattlePlugin.EpicBattleSpace";
	import "SDRPlugins.EpicBattlePlugin.EBPLogger";
end

function createQuestTooltip(control, questLabelNumber, args)

	local headerLabel = ScalingLabel();
	headerLabel:SetMultiline(false);
	styleLabel(headerLabel, 10, 5, 230, 25, Turbine.UI.Lotro.Font.TrajanProBold22, Turbine.UI.Color(1,1,1), Turbine.UI.ContentAlignment.MiddleCenter, EBLangData.PotentialQuests);
	headerLabel:SetBackColor(Turbine.UI.Color(0,0,0));
	headerLabel:CalcSmallestFontW("TrajanProBold", 22);

	local questsLabel = ScalingLabel();
	styleLabel(questsLabel, 10, 35, 230, 10, Turbine.UI.Lotro.Font.Verdana16, Turbine.UI.Color(1,1,1), Turbine.UI.ContentAlignment.TopLeft, "");	
	questsLabel:SetBackColor(Turbine.UI.Color(0,0,0));
	
	if ebObj.currentWave == 0 and (ebObj.spaceName ~= "Retaking Pelargir - Solo/Duo" or ebObj.spaceName ~= "Retaking Pelargir - Fellowship") then
		-- show possible combinations for quest number
		for key, value in pairs(EpicBattleData[ebObj.spaceName].sides) do
			if EpicBattleData[ebObj.spaceName].sides[key].wave[questLabelNumber] ~= nil then
				for questIndex = 1, #EpicBattleData[ebObj.spaceName].sides[key].wave[questLabelNumber] do
					if questsLabel:GetTextLength() > 0 then
						questsLabel:AppendText("\n\n");
					end
					-- check to see if it's an epic foe, add "Epic Foe" before quest if it is (MT Fix - 1/2/16)
					local questName = EpicBattleData[ebObj.spaceName].sides[key].wave[questLabelNumber][questIndex];
					if EpicBattleData[ebObj.spaceName].sides[key].wave[questLabelNumber].epicFoes ~= nil and EpicBattleData[ebObj.spaceName].sides[key].wave[questLabelNumber].epicFoes[questName] ~= nil then
						questsLabel:AppendText(EBLangData.PelEpicFoe .. EBLangData[EpicBattleData[ebObj.spaceName].sides[key].wave[questLabelNumber][questIndex]]);
					else
						questsLabel:AppendText(EBLangData[EpicBattleData[ebObj.spaceName].sides[key].wave[questLabelNumber][questIndex]]);
					end
				end
			end
		end
	else
		-- Pel fix
		if ebObj.spaceName == "Retaking Pelargir - Solo/Duo" or ebObj.spaceName == "Retaking Pelargir - Fellowship" then
			if ebObj.currentWave == 2 then
				
				if questLabelNumber == 1 then
					for questIndex = 1, #EpicBattleData[ebObj.spaceName].sides["Phase 2"].wave[2].quests do
						if questsLabel:GetTextLength() > 0 then
							questsLabel:AppendText("\n\n");
						end
						questsLabel:AppendText(EBLangData[EpicBattleData[ebObj.spaceName].sides["Phase 2"].wave[2].quests[questIndex]]);
					end
					
				elseif questLabelNumber == 2 then
					for questIndex = 1, #EpicBattleData[ebObj.spaceName].sides["Phase 2"].wave[2].epicFoes do
						if questsLabel:GetTextLength() > 0 then
							questsLabel:AppendText("\n\n");
						end
						questsLabel:AppendText(EBLangData[EpicBattleData[ebObj.spaceName].sides["Phase 2"].wave[2].epicFoes[questIndex].name]);
					end
				
				end
			
			elseif ebObj.currentWave == 3 then
				if questLabelNumber == 1 and EpicBattleData[ebObj.spaceName].sides["Phase 3"].wave[3].quests ~= nil then
					for questIndex = 1, #EpicBattleData[ebObj.spaceName].sides["Phase 3"].wave[3].quests do
						if questsLabel:GetTextLength() > 0 then
							questsLabel:AppendText("\n\n");
						end
						questsLabel:AppendText(EBLangData[EpicBattleData[ebObj.spaceName].sides["Phase 3"].wave[3].quests[questIndex]]);
					end
					
				elseif questLabelNumber == 2 then
					for questIndex = 1, #EpicBattleData[ebObj.spaceName].sides["Phase 3"].wave[3].epicFoes do
						if questsLabel:GetTextLength() > 0 then
							questsLabel:AppendText("\n\n");
						end
						questsLabel:AppendText(EBLangData[EpicBattleData[ebObj.spaceName].sides["Phase 3"].wave[3].epicFoes[questIndex].name]);
					end
				
				end
			
			end
		
		else
			-- only show more information if the quest isn't known
			for key, value in pairs(EpicBattleData[ebObj.spaceName].sides) do
				if EpicBattleData[ebObj.spaceName].sides[key].wave[questLabelNumber] ~= nil then
					if #EpicBattleData[ebObj.spaceName].sides[key].wave[questLabelNumber] > 1 then
						for questIndex = 1, #EpicBattleData[ebObj.spaceName].sides[key].wave[questLabelNumber] do
							if questsLabel:GetTextLength() > 0 then
								questsLabel:AppendText("\n\n");
							end
							-- check to see if it's an epic foe, add "Epic Foe" before quest if it is (MT Fix - 1/2/16)
							local questName = EpicBattleData[ebObj.spaceName].sides[key].wave[questLabelNumber][questIndex];
							if EpicBattleData[ebObj.spaceName].sides[key].wave[questLabelNumber].epicFoes ~= nil and EpicBattleData[ebObj.spaceName].sides[key].wave[questLabelNumber].epicFoes[questName] ~= nil then
								questsLabel:AppendText(EBLangData.PelEpicFoe .. EBLangData[EpicBattleData[ebObj.spaceName].sides[key].wave[questLabelNumber][questIndex]]);
							else
								questsLabel:AppendText(EBLangData[EpicBattleData[ebObj.spaceName].sides[key].wave[questLabelNumber][questIndex]]);
							end
						end
					elseif ebObj.spaceName == "Deeping Wall - Raid" and ebObj.currentWave < 3 and questLabelNumber > ebObj.currentWave then
						if ebObj.currentWave == 1 and ebObj.waveInformation[1].side ~= key then -- only add the quests from the sides that are not from the side of the first wave
							if questsLabel:GetTextLength() > 0 then
								questsLabel:AppendText("\n\n");
							end
							questsLabel:AppendText(EBLangData[EpicBattleData[ebObj.spaceName].sides[key].wave[questLabelNumber][1]]);
						elseif ebObj.currentWave == 2 and ebObj.waveInformation[1].side ~= key and ebObj.waveInformation[2].side ~= key then -- only add the quests from the side that is not from first/second wave side (technically there should only ever be one
							--if questsLabel:GetTextLength() > 0 then
							--	questsLabel:AppendText("\n\n");
							--end
							--questsLabel:AppendText(EBLangData[EpicBattleData[ebObj.spaceName].sides[key].wave[questLabelNumber][1]]);
						end
					end
				end
			end
		end
	end
	questsLabel:CalcSmallestHeight();

	window = Turbine.UI.Window();
	window:SetZOrder(250); -- make sure tooltip appears above everything else
	window:SetBackColor(Turbine.UI.Color(0,0,0));
	window:SetOpacity(.9);
	window:SetSize( 250, headerLabel:GetHeight()+questsLabel:GetHeight() + 5 );
	
	-- Pel fix
	if ebObj.spaceName == "Retaking Pelargir - Solo/Duo" or ebObj.spaceName == "Retaking Pelargir - Fellowship" then
		if questsLabel:GetTextLength() == 0 then
			window:SetSize(0,0);
		end
	elseif questsLabel:GetTextLength() == 0 or (ebObj.currentWave >= questLabelNumber and (ebObj.waveInformation[questLabelNumber] ~= nil and ebObj.waveInformation[questLabelNumber].hasEnded)) then
		window:SetSize(0,0);
	end
	window:SetVisible( true );

	headerLabel:SetParent(window);
	questsLabel:SetParent(window);

	local displayWidth = Turbine.UI.Display:GetWidth();
	local displayHeight = Turbine.UI.Display:GetHeight();

	local x, y = args.X, args.Y; -- get the mouse position
	x = x + 15; -- we want to offset the window a bit from the mouse pointer
	y = y + 15; -- we want to offset the window a bit from the mouse pointer
	
	x, y = control:GetParent():PointToScreen(x, y); -- convert the point to the screen coordinate

	-- if the tooltip will go off the side of the screen, move it to the left enough so that it doesn't
	if x+window:GetWidth() > displayWidth then
		x = x - window:GetWidth() - 15;
	end
	-- if the tooltip would go off the bottom of the screen, move it to above the mouse pointer
	if y+window:GetHeight() > displayHeight then
		y = y - 15 - window:GetHeight();
	end

	window:SetPosition(x, y);

	return window;
end

function endOldWaveAndStartNewWave(waveSide)
	if ebObj.currentWave ~= 0 then
		waveHasEnded();
		waveHasStarted(waveSide);
	else waveHasStarted(waveSide);
	end
end

function showContextMenu(sender, args)

	if ( args.Button == Turbine.UI.MouseButton.Right ) and sender == main_window then
		if args.Y > 0 and args.Y < (20*(OptionWindow.scaleScrollbar:GetValue()/100)) then -- the user right clicked on the main heading - allow them to setup a specific instance
			local context_menu = Turbine.UI.ContextMenu();
			local items = context_menu:GetItems();
			items:Add(Turbine.UI.MenuItem(EBLangData.StartNewEpicBattle .. EBLangData["Helm's Dike - Solo/Duo"]));
			items:Add(Turbine.UI.MenuItem(EBLangData.StartNewEpicBattle .. EBLangData["Helm's Dike - Fellowship"]));
			items:Add(Turbine.UI.MenuItem(EBLangData.StartNewEpicBattle .. EBLangData["Deeping Wall - Solo/Duo"]));
			items:Add(Turbine.UI.MenuItem(EBLangData.StartNewEpicBattle .. EBLangData["Deeping Wall - Raid"]));
			items:Add(Turbine.UI.MenuItem(EBLangData.StartNewEpicBattle .. EBLangData["The Deeping-coomb - Solo/Duo"]));
			items:Add(Turbine.UI.MenuItem(EBLangData.StartNewEpicBattle .. EBLangData["Glittering Caves - Solo/Duo"]));
			items:Add(Turbine.UI.MenuItem(EBLangData.StartNewEpicBattle .. EBLangData["Glittering Caves - Small Fellowship"]));
			items:Add(Turbine.UI.MenuItem(EBLangData.StartNewEpicBattle .. EBLangData["The Hornburg - Solo/Duo"]));
			items:Add(Turbine.UI.MenuItem(EBLangData.StartNewEpicBattle .. EBLangData["Retaking Pelargir - Solo/Duo"]));
			items:Add(Turbine.UI.MenuItem(EBLangData.StartNewEpicBattle .. EBLangData["Retaking Pelargir - Fellowship"]));
			items:Add(Turbine.UI.MenuItem(EBLangData.StartNewEpicBattle .. EBLangData["The Defence of Minas Tirith - Solo/Duo"]));
			items:Add(Turbine.UI.MenuItem(EBLangData.StartNewEpicBattle .. EBLangData["The Defence of Minas Tirith - Small Fellowship"]));
			items:Add(Turbine.UI.MenuItem(EBLangData.StartNewEpicBattle .. EBLangData["Hammer of the Underworld - Solo/Duo"]));
			items:Add(Turbine.UI.MenuItem(EBLangData.StartNewEpicBattle .. EBLangData["Hammer of the Underworld - Fellowship"]));
			items:Add(Turbine.UI.MenuItem(EBLangData.OptionsMenu));
			if hasDWRA then
				items:Add(Turbine.UI.MenuItem("Load DWRA"));
				items:Get(12).Click = function(s,a) Turbine.PluginManager.LoadPlugin("DeepingWallRaidAssistant"); end
			end

			items:Get(1).Click = function(s, a) setUpEBObj("Helm's Dike - Solo/Duo"); end
			items:Get(2).Click = function(s, a) setUpEBObj("Helm's Dike - Fellowship"); end
			items:Get(3).Click = function(s, a) setUpEBObj("Deeping Wall - Solo/Duo"); end
			items:Get(4).Click = function(s, a) setUpEBObj("Deeping Wall - Raid"); end
			items:Get(5).Click = function(s, a) setUpEBObj("The Deeping-coomb - Solo/Duo"); end
			items:Get(6).Click = function(s, a) setUpEBObj("Glittering Caves - Solo/Duo"); end
			items:Get(7).Click = function(s, a) setUpEBObj("Glittering Caves - Small Fellowship"); end
			items:Get(8).Click = function(s, a) setUpEBObj("The Hornburg - Solo/Duo"); end
			items:Get(9).Click = function(s, a) setUpEBObj("Retaking Pelargir - Solo/Duo"); end
			items:Get(10).Click = function(s, a) setUpEBObj("Retaking Pelargir - Fellowship"); end
			items:Get(11).Click = function(s, a) setUpEBObj("The Defence of Minas Tirith - Solo/Duo"); end
			items:Get(12).Click = function(s, a) setUpEBObj("The Defence of Minas Tirith - Small Fellowship"); end
			items:Get(13).Click = function(s, a) setUpEBObj("Hammer of the Underworld - Solo/Duo"); end
			items:Get(14).Click = function(s, a) setUpEBObj("Hammer of the Underworld - Fellowship"); end
			items:Get(15).Click = function(s, a) OptionWindow:Show(); end

    			context_menu:ShowMenu();
		elseif ebObj ~= nil and args.Y > (20*(OptionWindow.scaleScrollbar:GetValue()/100)) and args.Y < (40*(OptionWindow.scaleScrollbar:GetValue()/100)) then -- the user may be clicking on the waves - allow them to setup specific waves
			if args.X > 0 and args.X < (195*(OptionWindow.scaleScrollbar:GetValue()/100)) then -- they right clicked on the wave buttons

				local context_menu = Turbine.UI.ContextMenu();
				local items = context_menu:GetItems();

				-- need to start wave
				local waveNumber = ebObj.currentWave;
				if EpicBattleData[ebObj.spaceName].sides["Western"] ~= nil and (waveNumber < 2 or ebObj.spaceName == "Deeping Wall - Raid") then
					local menuItem = Turbine.UI.MenuItem(EBLangData.StartNewWave .. EBLangData.MenuWesternSide);
					menuItem.Click = function(s, a) endOldWaveAndStartNewWave("Western"); end
					items:Add(menuItem);
				end

				if EpicBattleData[ebObj.spaceName].sides["Eastern"] ~= nil and (waveNumber < 2 or ebObj.spaceName == "Deeping Wall - Raid") then
					local menuItem = Turbine.UI.MenuItem(EBLangData.StartNewWave .. EBLangData.MenuEasternSide);
					menuItem.Click = function(s,a) endOldWaveAndStartNewWave("Eastern"); end
					items:Add(menuItem);
				end

				if EpicBattleData[ebObj.spaceName].sides["Hornburg"] ~= nil and waveNumber ~= 2 then
					local menuItem = Turbine.UI.MenuItem(EBLangData.StartNewWave .. EBLangData.MenuHornburg);
					menuItem.Click = function(s,a) endOldWaveAndStartNewWave("Hornburg"); end
					items:Add(menuItem);
				end

				if EpicBattleData[ebObj.spaceName].sides["Glittering Caves"] ~= nil and waveNumber ~= 2 then
					local menuItem = Turbine.UI.MenuItem(EBLangData.StartNewWave .. EBLangData.MenuGlitteringCaves);
					menuItem.Click = function(s,a) endOldWaveAndStartNewWave("Glittering Caves"); end
					items:Add(menuItem);
				end

				if ebObj.spaceName == "Deeping Wall - Raid" then
					local menuItem = Turbine.UI.MenuItem(EBLangData.StartNewWave .. EBLangData.MenuCentreSide);
					menuItem.Click = function(s,a) endOldWaveAndStartNewWave("Centre"); end
					items:Add(menuItem);
				elseif waveNumber == 2 and EpicBattleData[ebObj.spaceName].sides["Centre"] ~= nil then
					local menuItem = Turbine.UI.MenuItem(EBLangData.StartNewWave .. EBLangData.MenuCentreSide);
					menuItem.Click = function(s,a) endOldWaveAndStartNewWave("Centre"); end
					items:Add(menuItem);
				end

				if EpicBattleData[ebObj.spaceName].sides["Only"] ~= nil and waveNumber ~= 2 then
					local menuItem = Turbine.UI.MenuItem(EBLangData.StartNewWave .. EBLangData.MenuOnlySide);
					menuItem.Click = function(s,a) endOldWaveAndStartNewWave("Only"); end
					items:Add(menuItem);
				end
				
				-- Pel fix
				if ebObj.spaceName == "Retaking Pelargir - Solo/Duo" or ebObj.spaceName == "Retaking Pelargir - Fellowship" then
					if waveNumber == 0 then
						local menuItem = Turbine.UI.MenuItem(EBLangData.StartNewWave .. EBLangData.MenuPhase1);
						menuItem.Click = function(s,a) endOldWaveAndStartNewWave("Phase 1"); end
						items:Add(menuItem);
					elseif waveNumber == 1 then
						local menuItem = Turbine.UI.MenuItem(EBLangData.StartNewWave .. EBLangData.MenuPhase2);
						menuItem.Click = function(s,a) endOldWaveAndStartNewWave("Phase 2"); end
						items:Add(menuItem);
					elseif waveNumber == 2 then
						local menuItem = Turbine.UI.MenuItem(EBLangData.StartNewWave .. EBLangData.MenuPhase3);
						menuItem.Click = function(s,a) endOldWaveAndStartNewWave("Phase 3"); end
						items:Add(menuItem);
					end
				end
				
				-- MT Epic battles (1/2/16)
				if ebObj.spaceName == "The Defence of Minas Tirith - Solo/Duo" or ebObj.spaceName == "The Defence of Minas Tirith - Small Fellowship" then
					if waveNumber == 0 then
						local menuItem = Turbine.UI.MenuItem(EBLangData.StartNewWave .. EBLangData.MenuPhase1);
						menuItem.Click = function(s,a) endOldWaveAndStartNewWave("Phase 1"); end
						items:Add(menuItem);
					elseif waveNumber == 1 then
						local menuItem = Turbine.UI.MenuItem(EBLangData.StartNewWave .. EBLangData.MenuPhase2);
						menuItem.Click = function(s,a) endOldWaveAndStartNewWave("Phase 2"); end
						items:Add(menuItem);
					elseif waveNumber == 2 then
						local menuItem = Turbine.UI.MenuItem(EBLangData.StartNewWave .. EBLangData.MenuPhase3);
						menuItem.Click = function(s,a) endOldWaveAndStartNewWave("Phase 3"); end
						items:Add(menuItem);
					end
				end
				if ebObj.spaceName == "Hammer of the Underworld - Solo/Duo" or ebObj.spaceName == "Hammer of the Underworld - Fellowship" then
					if waveNumber == 0 then
						local menuItem = Turbine.UI.MenuItem(EBLangData.StartNewWave .. EBLangData.MenuPhase1);
						menuItem.Click = function(s,a) endOldWaveAndStartNewWave("Phase 1"); end
						items:Add(menuItem);
					elseif waveNumber == 1 then
						local menuItem = Turbine.UI.MenuItem(EBLangData.StartNewWave .. EBLangData.MenuPhase2);
						menuItem.Click = function(s,a) endOldWaveAndStartNewWave("Phase 2"); end
						items:Add(menuItem);
					elseif waveNumber == 2 then
						local menuItem = Turbine.UI.MenuItem(EBLangData.StartNewWave .. EBLangData.MenuPhase3);
						menuItem.Click = function(s,a) endOldWaveAndStartNewWave("Phase 3"); end
						items:Add(menuItem);
					end
				end

				if waveNumber ~= 0 and ebObj.waveInformation[waveNumber] ~= nil and not ebObj.waveInformation[waveNumber].hasEnded then
					local menuItem = Turbine.UI.MenuItem(EBLangData.MenuEndWave);
					menuItem.Click = function(s,a) waveHasEnded(); end
					items:Add(menuItem);
				end

				local menuItem = Turbine.UI.MenuItem(EBLangData.OptionsMenu);
				menuItem.Click = function(s, a) OptionWindow:Show(); end
				items:Add(menuItem);

				if hasDWRA then
					local menuItem = Turbine.UI.MenuItem("Load DWRA");
					menuItem.Click = function(s,a) Turbine.PluginManager.LoadPlugin("DeepingWallRaidAssistant"); end
					items:Add(menuItem);
				end

				context_menu:ShowMenu();
			else
				local context_menu = Turbine.UI.ContextMenu();
				local items = context_menu:GetItems();
				local menuItem = Turbine.UI.MenuItem(EBLangData.OptionsMenu);
				menuItem.Click = function(s, a) OptionWindow:Show(); end
				items:Add(menuItem);

				if hasDWRA then
					local menuItem = Turbine.UI.MenuItem("Load DWRA");
					menuItem.Click = function(s,a) Turbine.PluginManager.LoadPlugin("DeepingWallRaidAssistant"); end
					items:Add(menuItem);
				end

				context_menu:ShowMenu();
			end
		else
			local context_menu = Turbine.UI.ContextMenu();
			local items = context_menu:GetItems();
			local menuItem = Turbine.UI.MenuItem(EBLangData.OptionsMenu);
			menuItem.Click = function(s, a) OptionWindow:Show(); end
			items:Add(menuItem);

			if hasDWRA then
				local menuItem = Turbine.UI.MenuItem("Load DWRA");
				menuItem.Click = function(s,a) Turbine.PluginManager.LoadPlugin("DeepingWallRaidAssistant"); end
				items:Add(menuItem);
			end

			context_menu:ShowMenu();
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		local context_menu = Turbine.UI.ContextMenu();
		local items = context_menu:GetItems();
		local menuItem = Turbine.UI.MenuItem(EBLangData.OptionsMenu);
		menuItem.Click = function(s, a) OptionWindow:Show(); end
		items:Add(menuItem);

		if hasDWRA then
			local menuItem = Turbine.UI.MenuItem("Load DWRA");
			menuItem.Click = function(s,a) Turbine.PluginManager.LoadPlugin("DeepingWallRaidAssistant"); end
			items:Add(menuItem);
		end

		context_menu:ShowMenu();
	end

end

function setQuestLabel(waveNum, text, includeQuestLabel)
	includeQuestLabel = includeQuestLabel == nil and true or includeQuestLabel;
	-- Pel fix
	if ebObj.spaceName == "Retaking Pelargir - Solo/Duo" or ebObj.spaceName == "Retaking Pelargir - Fellowship" then
		if waveNum == 1 then
			quest1Label:SetText(text);
		
		elseif waveNum == 2 then
			quest2Label:SetText(text);
			
		elseif waveNum == 3 then
			quest3Label:SetText(text);
		end
	else
		if waveNum == 1 then
			if includeQuestLabel then
				quest1Label:SetText(EBLangData.FirstQuestLabel .. text);
			else
				quest1Label:SetText(text);
			end
		elseif waveNum == 2 then
			if includeQuestLabel then
				quest2Label:SetText(EBLangData.SecondQuestLabel .. text);
			else
				quest2Label:SetText(text);
			end
		elseif waveNum == 3 then
			if includeQuestLabel then
				quest3Label:SetText(EBLangData.ThirdQuestLabel .. text);
			else
				quest3Label:SetText(text);
			end
		end
	end
end

-- update all parts of the UI when needed
function updateUI()
	-- only update main UI if there is an EB going on
	if ebObj ~= nil then

		-- update main label
		epicBattleLabel:SetText(EBLangData[ebObj.spaceName]);
		
		-- change the wave/quest labels to Phase/Phase Info in Pel, or to Wave/Quest in other spaces
		if ebObj.spaceName == "Retaking Pelargir - Solo/Duo" or ebObj.spaceName == "Retaking Pelargir - Fellowship" then
			styleLabel(questLabel, 0, 55, 450, 20, Turbine.UI.Lotro.Font.TrajanProBold16, Turbine.UI.Color(0,0,0), Turbine.UI.ContentAlignment.MiddleCenter, EBLangData.PelQuestLabel);
			styleLabel(waveLabel, 0, 20, 75, 20, Turbine.UI.Lotro.Font.TrajanProBold16, Turbine.UI.Color(0,0,0), Turbine.UI.ContentAlignment.MiddleCenter, EBLangData.PelWaveLabel);
		else
			styleLabel(questLabel, 0, 55, 450, 20, Turbine.UI.Lotro.Font.TrajanProBold16, Turbine.UI.Color(0,0,0), Turbine.UI.ContentAlignment.MiddleCenter, EBLangData.QuestLabel);
			styleLabel(waveLabel, 0, 20, 75, 20, Turbine.UI.Lotro.Font.TrajanProBold16, Turbine.UI.Color(0,0,0), Turbine.UI.ContentAlignment.MiddleCenter, EBLangData.WaveLabel);
		end

		-- set quests if possible, only set quests and such once after at least the first wave has started
		if ebObj.currentWave > 0 then
			-- set quests if needed/possible
			local nextWaveSide = ebObj.waveInformation[ebObj.currentWave].side;
			
			--Pel fix
			if ebObj.spaceName == "Retaking Pelargir - Solo/Duo" or ebObj.spaceName == "Retaking Pelargir - Fellowship" then
				if ebObj.currentWave > 1 then
					if EpicBattleData[ebObj.spaceName].sides[nextWaveSide].wave[ebObj.currentWave].quests == nil then
						setQuestLabel(1, EBLangData.PelQuest .. EBLangData.NoneLabel);
					elseif #EpicBattleData[ebObj.spaceName].sides[nextWaveSide].wave[ebObj.currentWave].quests > 1 then
						setQuestLabel(1, EBLangData.PelQuest .. EBLangData.RandomQuest);
					else
						setQuestLabel(1, EBLangData.PelQuest .. EBLangData[EpicBattleData[ebObj.spaceName].sides[nextWaveSide].wave[ebObj.currentWave].quests[1]]);
					end
					if #EpicBattleData[ebObj.spaceName].sides[nextWaveSide].wave[ebObj.currentWave].epicFoes > 1 then
						setQuestLabel(2, EBLangData.PelEpicFoe .. EBLangData.PelHoverForDetails);
					else
						setQuestLabel(2, EBLangData.PelEpicFoe .. EBLangData[EpicBattleData[ebObj.spaceName].sides[nextWaveSide].wave[ebObj.currentWave].epicFoes[1].name]);
					end
					setQuestLabel(3, EBLangData.PelSecondaryFoe .. EBLangData[EpicBattleData[ebObj.spaceName].sides[nextWaveSide].wave[ebObj.currentWave].secondary]);
				else
					setQuestLabel(1, EBLangData.PelQuest .. EBLangData.NoneLabel);
					setQuestLabel(2, EBLangData.PelEpicFoe .. EBLangData.NoneLabel);
					setQuestLabel(3, EBLangData.PelSecondaryFoe .. EBLangData.NoneLabel);
				end
			
			else
				for i = ebObj.currentWave, ebObj.waves do
					-- if we can't know which side will be next, we can't place quest names yet
					if nextWaveSide ~= nil then
						-- only one quest, set that to the label
						-- the current quest variable is used for my DWRA plugin
						if #EpicBattleData[ebObj.spaceName].sides[nextWaveSide].wave[i] == 1 then
							setQuestLabel(i, EBLangData[EpicBattleData[ebObj.spaceName].sides[nextWaveSide].wave[i][1]]);
							currentQuest = EpicBattleData[ebObj.spaceName].sides[nextWaveSide].wave[i][1];
			
						-- multiple quests, set "Random" to the label
						elseif #EpicBattleData[ebObj.spaceName].sides[nextWaveSide].wave[i] > 1 then
							setQuestLabel(i, EBLangData.RandomQuest);
						end
						nextWaveSide = EpicBattleData[ebObj.spaceName].sides[nextWaveSide].wave[i].nextSide;
					else -- unknown (only used for Deeping Wall raid)
						if ebObj.currentWave == 2 then -- set the 3rd quest label to whatever the 3rd wave quest will be (as it is known once the 2nd wave starts)
							for key, value in pairs(EpicBattleData[ebObj.spaceName].sides) do
								if EpicBattleData[ebObj.spaceName].sides[key].wave[i] ~= nil and ebObj.waveInformation[1].side ~= key and ebObj.waveInformation[2].side ~= key then
									setQuestLabel(i, EBLangData[EpicBattleData[ebObj.spaceName].sides[key].wave[i][1]]);
								end
							end
						else
							setQuestLabel(i, EBLangData.UnknownQuest);
						end
					end
				end
				if ebObj.waves < 3 then
					setQuestLabel(3, EBLangData.NoneLabel);
					wave3Label:SetBackColor(Turbine.UI.Color(.3,.3,.3));
					quest3Label:SetBackColor(Turbine.UI.Color(.3,.3,.3));
				end
			end

			if ebObj.currentWave == 1 then
				if ebObj.waveInformation[ebObj.currentWave].hasEnded then
					wave1Label:SetBackColor(Turbine.UI.Color(.4,0,0));
					quest1Label:SetBackColor(Turbine.UI.Color(.4,0,0));
				else
					wave1Label:SetBackColor(Turbine.UI.Color(.5,1,.5));
					quest1Label:SetBackColor(Turbine.UI.Color(.5,1,.5));
				end
				if ebObj.waveInformation[ebObj.currentWave+1] ~= nil then
					wave2Label:SetBackColor(Turbine.UI.Color(.8,.8,0));
				end
			elseif ebObj.currentWave == 2 then
				wave1Label:SetBackColor(Turbine.UI.Color(.4,0,0));
				quest1Label:SetBackColor(Turbine.UI.Color(.4,0,0));
				if ebObj.waveInformation[ebObj.currentWave].hasEnded then
					wave2Label:SetBackColor(Turbine.UI.Color(.4,0,0));
					quest2Label:SetBackColor(Turbine.UI.Color(.4,0,0));
				else
					wave2Label:SetBackColor(Turbine.UI.Color(.5,1,.5));
					quest2Label:SetBackColor(Turbine.UI.Color(.5,1,.5));
				end
				if ebObj.waveInformation[ebObj.currentWave+1] ~= nil then
					wave3Label:SetBackColor(Turbine.UI.Color(.8,.8,0));
				end
			elseif ebObj.currentWave == 3 then
				wave2Label:SetBackColor(Turbine.UI.Color(.4,0,0));
				quest2Label:SetBackColor(Turbine.UI.Color(.4,0,0));
				if ebObj.waveInformation[ebObj.currentWave].hasEnded then
					wave3Label:SetBackColor(Turbine.UI.Color(.4,0,0));
					quest3Label:SetBackColor(Turbine.UI.Color(.4,0,0));
				else
					wave3Label:SetBackColor(Turbine.UI.Color(.5,1,.5));
					quest3Label:SetBackColor(Turbine.UI.Color(.5,1,.5));
				end
			end
			
			if ebObj.spaceName == "Retaking Pelargir - Solo/Duo" or ebObj.spaceName == "Retaking Pelargir - Fellowship" then
				-- fix for colors of the quest labels
				if ebObj.currentWave > 1 then
					if ebObj.waveInformation[ebObj.currentWave].hasEnded then
						quest1Label:SetBackColor(Turbine.UI.Color(.3,.3,.3));
						quest2Label:SetBackColor(Turbine.UI.Color(.3,.3,.3));
						quest3Label:SetBackColor(Turbine.UI.Color(.3,.3,.3));
					
					elseif EpicBattleData[ebObj.spaceName].sides[nextWaveSide].wave[ebObj.currentWave].quests ~= nil then
						if ebObj.waveInformation[ebObj.currentWave].part == 0 then
							quest1Label:SetBackColor(Turbine.UI.Color(.8,.8,0));
							quest2Label:SetBackColor(Turbine.UI.Color(.8,.8,0));
							quest3Label:SetBackColor(Turbine.UI.Color(.8,.8,0));
						elseif ebObj.waveInformation[ebObj.currentWave].part == 1 then
							quest1Label:SetBackColor(Turbine.UI.Color(.5,1,.5));
							quest2Label:SetBackColor(Turbine.UI.Color(.8,.8,0));
							quest3Label:SetBackColor(Turbine.UI.Color(.8,.8,0));
						elseif ebObj.waveInformation[ebObj.currentWave].part == 2 then
							quest1Label:SetBackColor(Turbine.UI.Color(.4,0,0));
							quest2Label:SetBackColor(Turbine.UI.Color(.5,1,.5));
							quest3Label:SetBackColor(Turbine.UI.Color(.8,.8,0));
						else
							quest1Label:SetBackColor(Turbine.UI.Color(.4,0,0));
							quest2Label:SetBackColor(Turbine.UI.Color(.4,0,0));
							quest3Label:SetBackColor(Turbine.UI.Color(.5,1,.5));
						end
					
						--[[
						if EpicBattleData[ebObj.spaceName].sides[nextWaveSide].wave[ebObj.currentWave].quests.killCount - ebObj.waveInformation[ebObj.currentWave].estKillCount < 0 then
							if EpicBattleData[ebObj.spaceName].sides[nextWaveSide].wave[ebObj.currentWave].epicFoes ~= nil then
								if EpicBattleData[ebObj.spaceName].sides[nextWaveSide].wave[ebObj.currentWave].epicFoes.killCount - ebObj.waveInformation[ebObj.currentWave].estKillCount < 0 then
									quest1Label:SetBackColor(Turbine.UI.Color(1,.6,.6));
									quest2Label:SetBackColor(Turbine.UI.Color(1,.6,.6));
									quest3Label:SetBackColor(Turbine.UI.Color(.5,1,.5));
								else
									quest1Label:SetBackColor(Turbine.UI.Color(1,.6,.6));
									quest2Label:SetBackColor(Turbine.UI.Color(.5,1,.5));
									quest3Label:SetBackColor(Turbine.UI.Color(.8,.8,0));
								end
							end
						else
							quest1Label:SetBackColor(Turbine.UI.Color(.5,1,.5));
							quest2Label:SetBackColor(Turbine.UI.Color(.8,.8,0));
							quest3Label:SetBackColor(Turbine.UI.Color(.8,.8,0));
						end
						]]--
					
					elseif EpicBattleData[ebObj.spaceName].sides[nextWaveSide].wave[ebObj.currentWave].epicFoes ~= nil then
						if ebObj.waveInformation[ebObj.currentWave].part == 0 then
							quest1Label:SetBackColor(Turbine.UI.Color(.3,.3,.3));
							quest2Label:SetBackColor(Turbine.UI.Color(.8,.8,0));
							quest3Label:SetBackColor(Turbine.UI.Color(.8,.8,0));
						elseif ebObj.waveInformation[ebObj.currentWave].part == 2 then
							quest1Label:SetBackColor(Turbine.UI.Color(.3,.3,.3));
							quest2Label:SetBackColor(Turbine.UI.Color(.5,1,.5));
							quest3Label:SetBackColor(Turbine.UI.Color(.8,.8,0));
						else
							quest1Label:SetBackColor(Turbine.UI.Color(.3,.3,.3));
							quest2Label:SetBackColor(Turbine.UI.Color(.4,0,0));
							quest3Label:SetBackColor(Turbine.UI.Color(.5,1,.5));
						end
					
						--[[
						if EpicBattleData[ebObj.spaceName].sides[nextWaveSide].wave[ebObj.currentWave].epicFoes.killCount - ebObj.waveInformation[ebObj.currentWave].estKillCount < 0 then
							quest1Label:SetBackColor(Turbine.UI.Color(.3,.3,.3));
							quest2Label:SetBackColor(Turbine.UI.Color(1,.6,.6));
							quest3Label:SetBackColor(Turbine.UI.Color(.5,1,.5));
						else
							quest1Label:SetBackColor(Turbine.UI.Color(.3,.3,.3));
							quest2Label:SetBackColor(Turbine.UI.Color(.5,1,.5));
							quest3Label:SetBackColor(Turbine.UI.Color(.8,.8,0));
						end
						]]--
					end
				else
					quest1Label:SetBackColor(Turbine.UI.Color(.3,.3,.3));
					quest2Label:SetBackColor(Turbine.UI.Color(.3,.3,.3));
					quest3Label:SetBackColor(Turbine.UI.Color(.3,.3,.3));
				end
			end
			
			timerControl:SetWantsUpdates(true);
		else
			-- Pel Fix
			if ebObj.spaceName == "Retaking Pelargir - Solo/Duo" or ebObj.spaceName == "Retaking Pelargir - Fellowship" then
				setQuestLabel(1, EBLangData.PelQuest .. EBLangData.NoneLabel);
				setQuestLabel(2, EBLangData.PelEpicFoe .. EBLangData.NoneLabel);
				setQuestLabel(3, EBLangData.PelSecondaryFoe .. EBLangData.NoneLabel);
			else
				setQuestLabel(1, EBLangData.UnknownQuest);
				setQuestLabel(2, EBLangData.UnknownQuest);
				setQuestLabel(3, EBLangData.UnknownQuest);
			end
			timerLabel:SetText(EBLangData.EndsIn .. EBLangData.NotAvailable);
			killCountLabel:SetText(EBLangData.KillCount .. EBLangData.NotAvailable);
			killQuestCountLabel:SetText(EBLangData.TilSideQuestStarts .. EBLangData.NotAvailable);
			trapsTable = {};
			trap1Label:SetText(EBLangData.NoneLabel);
			trap2Label:SetText(EBLangData.NoneLabel);
			trap3Label:SetText(EBLangData.NoneLabel);
			wave1Label:SetBackColor(Turbine.UI.Color(.7,.7,.7));
			wave2Label:SetBackColor(Turbine.UI.Color(.7,.7,.7));
			wave3Label:SetBackColor(Turbine.UI.Color(.7,.7,.7));
			quest1Label:SetBackColor(Turbine.UI.Color(.7,.7,.7));
			quest2Label:SetBackColor(Turbine.UI.Color(.7,.7,.7));
			quest3Label:SetBackColor(Turbine.UI.Color(.7,.7,.7));
		end
	else
		-- reset to default look after a battle
		epicBattleLabel:SetText(EBLangData.EpicBattleHeader);
		timerLabel:SetText(EBLangData.EndsIn .. EBLangData.NotAvailable);
		killCountLabel:SetText(EBLangData.KillCount .. EBLangData.NotAvailable);
		killQuestCountLabel:SetText(EBLangData.TilSideQuestStarts .. EBLangData.NotAvailable);
		quest1Label:SetText(EBLangData.FirstQuestLabel .. "[" .. EBLangData.QuestName .. "]");
		quest2Label:SetText(EBLangData.SecondQuestLabel .. "[" .. EBLangData.QuestName .. "]");
		quest3Label:SetText(EBLangData.ThirdQuestLabel .. "[" .. EBLangData.QuestName .. "]");
		trapsTable = {};
		trap1Label:SetText(EBLangData.NoneLabel);
		trap2Label:SetText(EBLangData.NoneLabel);
		trap3Label:SetText(EBLangData.NoneLabel);
		wave1Label:SetBackColor(Turbine.UI.Color(.7,.7,.7));
		wave2Label:SetBackColor(Turbine.UI.Color(.7,.7,.7));
		wave3Label:SetBackColor(Turbine.UI.Color(.7,.7,.7));
		quest1Label:SetBackColor(Turbine.UI.Color(.7,.7,.7));
		quest2Label:SetBackColor(Turbine.UI.Color(.7,.7,.7));
		quest3Label:SetBackColor(Turbine.UI.Color(.7,.7,.7));
		styleLabel(questLabel, 0, 55, 450, 20, Turbine.UI.Lotro.Font.TrajanProBold16, Turbine.UI.Color(0,0,0), Turbine.UI.ContentAlignment.MiddleCenter, EBLangData.QuestLabel);
		styleLabel(waveLabel, 0, 20, 75, 20, Turbine.UI.Lotro.Font.TrajanProBold16, Turbine.UI.Color(0,0,0), Turbine.UI.ContentAlignment.MiddleCenter, EBLangData.WaveLabel);
	end
end

-- Global vars
main_window = nil;

-- Load plugin
createMainWindow();
loadState();

-- Run
main_window:SetVisible(true);

-- timer controller monitors the game time and updates the timer
timerControl = Turbine.UI.Control();

function setTimerLabel(label, additionalText, timeInSec)
	local rounded = round(timeInSec, 0);
	local m, s = getMinsAndSeconds(rounded);
	if s > 9 then
		label:SetText(additionalText .. m .. ":" .. s);
	else
		label:SetText(additionalText .. m .. ":0" .. s);
	end
end

timerControl.Update = function(sender, args)
	local gameTime = Turbine.Engine:GetGameTime();

	if ebObj ~= nil and ebObj.currentWave > 0 then

		for wave = 1, #ebObj.waveInformation do
			if not ebObj.waveInformation[wave].hasEnded and ebObj.waveInformation[wave].startTime + ebObj.waveInformation[wave].delay < gameTime and gameTime - ebObj.waveInformation[wave].lastKillCountUpdate > 1 then
				local addKillCount = (gameTime - ebObj.waveInformation[wave].lastKillCountUpdate) * ebObj.waveInformation[wave].killTimeRatio;
				ebObj:IncreaseEstKillCount(wave, addKillCount);
				ebObj.waveInformation[wave].lastKillCountUpdate = gameTime;
			end
		end

		local currentKillCount = round(ebObj.waveInformation[ebObj.currentWave].estKillCount, 0);
		killCountLabel:SetText(EBLangData.KillCount .. currentKillCount);

		local timeRemaining = ebObj.waveInformation[ebObj.currentWave].actualEndTime - gameTime;
		
		if timeRemaining < 0 then
			timerControl:SetWantsUpdates(false);
			timerLabel:SetText(EBLangData.EndsIn .. EBLangData.Soon);
		else
			setTimerLabel(timerLabel, EBLangData.EndsIn, ebObj.waveInformation[ebObj.currentWave].endTime - gameTime);
		end

		if ebObj.waveInformation[ebObj.currentWave].killTimeRatio > 0 then
		
			-- Pel fix
			if ebObj.spaceName == "Retaking Pelargir - Solo/Duo" or ebObj.spaceName == "Retaking Pelargir - Fellowship" then
				if ebObj.currentWave > 1 then
					local timerLabel = EBLangData.TilSideQuestStarts;
					if EpicBattleData[ebObj.spaceName].sides[ebObj.waveInformation[ebObj.currentWave].side].wave[ebObj.currentWave].quests ~= nil then
						local secondsTilSideQuest = (EpicBattleData[ebObj.spaceName].sides[ebObj.waveInformation[ebObj.currentWave].side].wave[ebObj.currentWave].quests.killCount - ebObj.waveInformation[ebObj.currentWave].estKillCount)/ebObj.waveInformation[ebObj.currentWave].killTimeRatio;
					
						if secondsTilSideQuest < 0 then 
							if EpicBattleData[ebObj.spaceName].sides[ebObj.waveInformation[ebObj.currentWave].side].wave[ebObj.currentWave].epicFoes ~= nil then
								timerLabel = EBLangData.TilEpicFoe;
								secondsTilSideQuest = (EpicBattleData[ebObj.spaceName].sides[ebObj.waveInformation[ebObj.currentWave].side].wave[ebObj.currentWave].epicFoes.killCount - ebObj.waveInformation[ebObj.currentWave].estKillCount)/ebObj.waveInformation[ebObj.currentWave].killTimeRatio;
								if secondsTilSideQuest < 0 then
									timerLabel = EBLangData.TilSecondaryFoe;
									secondsTilSideQuest = (EpicBattleData[ebObj.spaceName].sides[ebObj.waveInformation[ebObj.currentWave].side].wave[ebObj.currentWave].secondaryKillCount - ebObj.waveInformation[ebObj.currentWave].estKillCount)/ebObj.waveInformation[ebObj.currentWave].killTimeRatio;
									if secondsTilSideQuest < 0 then
										secondsTilSideQuest = 0;
									end
								end
							else secondsTilSideQuest = 0;
							end
						end
					
						if gameTime - ebObj.waveInformation[ebObj.currentWave].startTime < ebObj.waveInformation[ebObj.currentWave].delay then
							secondsTilSideQuest = secondsTilSideQuest + (ebObj.waveInformation[ebObj.currentWave].delay - (gameTime - ebObj.waveInformation[ebObj.currentWave].startTime)); -- add the delay into the seconds so that the quest timer will count down correctly
						end

						if secondsTilSideQuest <= 0 then
							killQuestCountLabel:SetText(EBLangData.TilSideQuestStarts .. EBLangData.Soon);
							if ebObj.waveInformation[ebObj.currentWave].sideQuestTimerTotal == nil then
								ebObj.waveInformation[ebObj.currentWave].sideQuestTimerTotal = gameTime - ebObj.waveInformation[ebObj.currentWave].startTime;
							end
						else
							setTimerLabel(killQuestCountLabel, timerLabel, secondsTilSideQuest);
						end
				
					elseif EpicBattleData[ebObj.spaceName].sides[ebObj.waveInformation[ebObj.currentWave].side].wave[ebObj.currentWave].epicFoes ~= nil then
						
						timerLabel = EBLangData.TilEpicFoe;
						local secondsTilSideQuest = (EpicBattleData[ebObj.spaceName].sides[ebObj.waveInformation[ebObj.currentWave].side].wave[ebObj.currentWave].epicFoes.killCount - ebObj.waveInformation[ebObj.currentWave].estKillCount)/ebObj.waveInformation[ebObj.currentWave].killTimeRatio;
					
						if secondsTilSideQuest < 0 then
							timerLabel = EBLangData.TilSecondaryFoe;
							secondsTilSideQuest = (EpicBattleData[ebObj.spaceName].sides[ebObj.waveInformation[ebObj.currentWave].side].wave[ebObj.currentWave].secondaryKillCount - ebObj.waveInformation[ebObj.currentWave].estKillCount)/ebObj.waveInformation[ebObj.currentWave].killTimeRatio;
							if secondsTilSideQuest < 0 then
								secondsTilSideQuest = 0;
							end
						end
					
						if gameTime - ebObj.waveInformation[ebObj.currentWave].startTime < ebObj.waveInformation[ebObj.currentWave].delay then
							secondsTilSideQuest = secondsTilSideQuest + (ebObj.waveInformation[ebObj.currentWave].delay - (gameTime - ebObj.waveInformation[ebObj.currentWave].startTime)); -- add the delay into the seconds so that the quest timer will count down correctly
						end

						if secondsTilSideQuest <= 0 then
							killQuestCountLabel:SetText(EBLangData.TilSideQuestStarts .. EBLangData.Soon);
							if ebObj.waveInformation[ebObj.currentWave].sideQuestTimerTotal == nil then
								ebObj.waveInformation[ebObj.currentWave].sideQuestTimerTotal = gameTime - ebObj.waveInformation[ebObj.currentWave].startTime;
							end
						else
							setTimerLabel(killQuestCountLabel, timerLabel, secondsTilSideQuest);
						end
					end
					
					updateUI();
					
					-- add the number of seconds left to kill the epic foe
					if ebObj.waveInformation[ebObj.currentWave].killEndTime ~= nil then
						local remainingFoeTime = ebObj.waveInformation[ebObj.currentWave].killEndTime - Turbine.Engine:GetGameTime();
						if remainingFoeTime < 0 then
							ebObj.waveInformation[ebObj.currentWave].killEndTime = nil; -- will stop the seconds from showing once the countdown reaches 0
						end
						remainingFoeTime = round(remainingFoeTime, 0);
						setQuestLabel(ebObj.waveInformation[ebObj.currentWave].isEpicFoe, EBLangData[ebObj.waveInformation[ebObj.currentWave].foeName] .. " (" .. remainingFoeTime .. " " .. EBLangData.SecondsToKill .. ")");
					end
				end
			
			else
				local secondsTilSideQuest = (ebObj.waveInformation[ebObj.currentWave].sideQuestStart - ebObj.waveInformation[ebObj.currentWave].estKillCount)/ebObj.waveInformation[ebObj.currentWave].killTimeRatio;
				if secondsTilSideQuest < 0 then secondsTilSideQuest = 0; end
				if gameTime - ebObj.waveInformation[ebObj.currentWave].startTime < ebObj.waveInformation[ebObj.currentWave].delay then
					secondsTilSideQuest = secondsTilSideQuest + (ebObj.waveInformation[ebObj.currentWave].delay - (gameTime - ebObj.waveInformation[ebObj.currentWave].startTime)); -- add the delay into the seconds so that the quest timer will count down correctly
				end

				if secondsTilSideQuest <= 0 then
					killQuestCountLabel:SetText(EBLangData.TilSideQuestStarts .. EBLangData.Soon);
					if ebObj.waveInformation[ebObj.currentWave].sideQuestTimerTotal == nil then
						ebObj.waveInformation[ebObj.currentWave].sideQuestTimerTotal = gameTime - ebObj.waveInformation[ebObj.currentWave].startTime;
					end
				else
					setTimerLabel(killQuestCountLabel, EBLangData.TilSideQuestStarts, secondsTilSideQuest);
				end
				
				-- add the number of seconds left to kill the epic foe - used for MT (1/2/16)
				if ebObj.waveInformation[ebObj.currentWave].killEndTime ~= nil then
					local remainingFoeTime = ebObj.waveInformation[ebObj.currentWave].killEndTime - Turbine.Engine:GetGameTime();
					if remainingFoeTime < 0 then
						ebObj.waveInformation[ebObj.currentWave].killEndTime = nil; -- will stop the seconds from showing once the countdown reaches 0
					end
					remainingFoeTime = round(remainingFoeTime, 0);
					setQuestLabel(ebObj.currentWave, EBLangData[ebObj.waveInformation[ebObj.currentWave].foeName] .. " (" .. remainingFoeTime .. " " .. EBLangData.SecondsToKill .. ")", false);
				end
			end
			
		end

		-- set trap information
		if trapsTable[1] ~= nil then
			local trapDurRemaining = trapsTable[1].endTime - gameTime;
			if trapDurRemaining < 0 then
				table.remove(trapsTable, 1);
				updateUI();
			else
				setTimerLabel(trap1Label, trapsTable[1].name .. ": ", trapDurRemaining);
			end
			if trapsTable[2] ~= nil then
				trapDurRemaining = trapsTable[2].endTime - gameTime;
				if trapDurRemaining < 0 then
					table.remove(trapsTable, 2);
					updateUI();
				else
					setTimerLabel(trap2Label, trapsTable[2].name .. ": ", trapDurRemaining);
				end
				if trapsTable[3] ~= nil then
					trapDurRemaining = trapsTable[3].endTime - gameTime;
					if trapDurRemaining < 0 then
						table.remove(trapsTable, 3);
						updateUI();
					else
						setTimerLabel(trap3Label, trapsTable[3].name .. ": ", trapDurRemaining);
					end
				else trap3Label:SetText(EBLangData.NoneLabel);
				end
			else trap2Label:SetText(EBLangData.NoneLabel);
			end
		else trap1Label:SetText(EBLangData.NoneLabel);
		end

	else
		timerControl:SetWantsUpdates(false);
	end
end