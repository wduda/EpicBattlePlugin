import "Turbine.UI";

OptionWindow = class(Turbine.UI.Lotro.Window);

function OptionWindow:Constructor()
	Turbine.UI.Lotro.Window.Constructor(self);

	local displayWidth = Turbine.UI.Display:GetWidth();
	local displayHeight = Turbine.UI.Display:GetHeight();

	-- create the Window
	if hasDWRA then self:SetSize(400,340); else self:SetSize( 400, 300 ); end
	self:SetPosition((displayWidth-self:GetWidth())/2,(displayHeight-self:GetHeight())/2);
	self:SetBlendMode(Turbine.UI.BlendMode.Undefined);
	self:SetText(EBLangData.OptionsWindow);
	self.Closing = function()
		saveState();
	end

	-- create a label for the transparency slider
	self.transparencyLabel = ScalingLabel();
	self.transparencyLabel:SetMultiline(false);
	self.transparencyLabel:SetParent(self);
	self.transparencyLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro20);
	self.transparencyLabel:SetSize(10,20);
	self.transparencyLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.transparencyLabel:SetText(EBLangData.Opacity);
	self.transparencyLabel:CalcSmallestWidth();
	self.transparencyLabel:SetPosition( ((self:GetWidth()-self.transparencyLabel:GetWidth()-5-200)/2), 50);

	-- create scrollbar for the transparency
	self.transparencyScrollbar=Turbine.UI.Lotro.ScrollBar();
	self.transparencyScrollbar:SetParent(self);
	self.transparencyScrollbar:SetOrientation(Turbine.UI.Orientation.Horizontal);
	self.transparencyScrollbar:SetPosition(self.transparencyLabel:GetLeft()+self.transparencyLabel:GetWidth()+5,self.transparencyLabel:GetTop()+4);
	self.transparencyScrollbar:SetSize(200,12);
	self.transparencyScrollbar:SetBackColor(Turbine.UI.Color(.3,.3,.7));
	self.transparencyScrollbar:SetMinimum(10);
	self.transparencyScrollbar:SetMaximum(100); -- we will divide the value by 100 to get our 0-1 scale with 2 decimal places
	self.transparencyScrollbar:SetValue(100);
	self.transparencyScrollbar.ValueChanged=function()
	    if not winIsMin then main_window:SetOpacity(self.transparencyScrollbar:GetValue()/100); end
	end

	-- create the scale label
	self.scaleLabel = ScalingLabel();
	self.scaleLabel:SetMultiline(false);
	self.scaleLabel:SetParent(self);
	self.scaleLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro20);
	self.scaleLabel:SetSize(10,20);
	self.scaleLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.scaleLabel:SetText(EBLangData.ScaleWindow);
	self.scaleLabel:CalcSmallestWidth();
	self.scaleLabel:SetPosition( ((self:GetWidth()-self.scaleLabel:GetWidth()-5-200)/2),90);

	-- create the scale scrollbar
	self.scaleScrollbar=Turbine.UI.Lotro.ScrollBar();
	self.scaleScrollbar:SetParent(self);
	self.scaleScrollbar:SetOrientation(Turbine.UI.Orientation.Horizontal);
	self.scaleScrollbar:SetPosition(self.scaleLabel:GetLeft()+self.scaleLabel:GetWidth()+5,self.scaleLabel:GetTop()+4);
	self.scaleScrollbar:SetSize(200,12);
	self.scaleScrollbar:SetBackColor(Turbine.UI.Color(.3,.3,.7));
	self.scaleScrollbar:SetMinimum(50);
	self.scaleScrollbar:SetMaximum(100);
	self.scaleScrollbar:SetValue(100);
	self.scaleScrollbar.ValueChanged=function()
	    if not winIsMin then scaleMainWindow(self.scaleScrollbar:GetValue()); end
	end

	-- create the always load minimized checkbox
	self.loadMinToggle = Turbine.UI.Lotro.CheckBox();
	self.loadMinToggle:SetCheckAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.loadMinToggle:SetParent(self);
	self.loadMinToggle:SetBackColor(Turbine.UI.Color( 0.1, 0.1, 0.1 ));
	self.loadMinToggle:SetSize(16,16);
	self.loadMinToggle:SetChecked(false);
	self.loadMinToggle:SetText("");
	self.loadMinToggle.CheckedChanged=function()
	end

	-- create the always load minimized label
	self.loadMinLabel = ScalingLabel();
	self.loadMinLabel:SetMultiline(false);
	self.loadMinLabel:SetParent(self);
	self.loadMinLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro20);
	self.loadMinLabel:SetSize(10,20);
	self.loadMinLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.loadMinLabel:SetText(EBLangData.AlwaysLoadMin);
	self.loadMinLabel:CalcSmallestWidth();
	self.loadMinLabel:SetPosition( ((self:GetWidth()-self.loadMinLabel:GetWidth()+18)/2),130);
	self.loadMinToggle:SetPosition( self.loadMinLabel:GetLeft()-18,132);

	-- create the minimize after battle checkbox
	self.minAfterBattleToggle = Turbine.UI.Lotro.CheckBox();
	self.minAfterBattleToggle:SetCheckAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.minAfterBattleToggle:SetParent(self);
	self.minAfterBattleToggle:SetBackColor(Turbine.UI.Color( 0.1, 0.1, 0.1 ));
	self.minAfterBattleToggle:SetSize(16,16);
	self.minAfterBattleToggle:SetChecked(false);
	self.minAfterBattleToggle:SetText("");
	self.minAfterBattleToggle.CheckedChanged=function()
	end

	-- create the minimize after battle label
	self.minAfterBattleLabel = ScalingLabel();
	self.minAfterBattleLabel:SetMultiline(false);
	self.minAfterBattleLabel:SetParent(self);
	self.minAfterBattleLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro20);
	self.minAfterBattleLabel:SetSize(10,20);
	self.minAfterBattleLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.minAfterBattleLabel:SetText(EBLangData.MinAfterBattle);
	self.minAfterBattleLabel:CalcSmallestWidth();
	self.minAfterBattleLabel:SetPosition( ((self:GetWidth()-self.minAfterBattleLabel:GetWidth()+18)/2),170);
	self.minAfterBattleToggle:SetPosition( self.minAfterBattleLabel:GetLeft()-18,172);

	-- create the maximize for battle checkbox
	self.maxForBattleToggle = Turbine.UI.Lotro.CheckBox();
	self.maxForBattleToggle:SetCheckAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.maxForBattleToggle:SetParent(self);
	self.maxForBattleToggle:SetBackColor(Turbine.UI.Color( 0.1, 0.1, 0.1 ));
	self.maxForBattleToggle:SetSize(16,16);
	self.maxForBattleToggle:SetChecked(false);
	self.maxForBattleToggle:SetText("");
	self.maxForBattleToggle.CheckedChanged=function()
	end

	-- create the maximize for battle label
	self.maxForBattleLabel = ScalingLabel();
	self.maxForBattleLabel:SetMultiline(false);
	self.maxForBattleLabel:SetParent(self);
	self.maxForBattleLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro20);
	self.maxForBattleLabel:SetSize(10,20);
	self.maxForBattleLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.maxForBattleLabel:SetText(EBLangData.MaxForBattle);
	self.maxForBattleLabel:CalcSmallestWidth();
	self.maxForBattleLabel:SetPosition( ((self:GetWidth()-self.maxForBattleLabel:GetWidth()+18)/2),210);
	self.maxForBattleToggle:SetPosition( self.maxForBattleLabel:GetLeft()-18,212);

	-- create the additional save calls checkbox
	self.saveCallsToggle = Turbine.UI.Lotro.CheckBox();
	self.saveCallsToggle:SetCheckAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.saveCallsToggle:SetParent(self);
	self.saveCallsToggle:SetBackColor(Turbine.UI.Color( 0.1, 0.1, 0.1 ));
	self.saveCallsToggle:SetSize(16,16);
	self.saveCallsToggle:SetChecked(false);
	self.saveCallsToggle:SetText("");
	self.saveCallsToggle.CheckedChanged=function()
	end

	-- create the additional save calls label
	self.saveCallsLabel = ScalingLabel();
	self.saveCallsLabel:SetMultiline(false);
	self.saveCallsLabel:SetParent(self);
	self.saveCallsLabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro20);
	self.saveCallsLabel:SetSize(10,20);
	self.saveCallsLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.saveCallsLabel:SetText(EBLangData.SaveCalls);
	self.saveCallsLabel:CalcSmallestWidth();
	self.saveCallsLabel:SetPosition( ((self:GetWidth()-self.saveCallsLabel:GetWidth()+18)/2),250);
	self.saveCallsToggle:SetPosition( self.saveCallsLabel:GetLeft()-18,252);

	-- create the always load DWRA checkbox/label
	if hasDWRA then
		self.loadDWRALabel = ScalingLabel();
		self.loadDWRALabel:SetMultiline(false);
		self.loadDWRALabel:SetParent(self);
		self.loadDWRALabel:SetFont(Turbine.UI.Lotro.Font.TrajanPro20);
		self.loadDWRALabel:SetSize(10,20);
		self.loadDWRALabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
		self.loadDWRALabel:SetText("Always Load DWRA");
		self.loadDWRALabel:CalcSmallestWidth();
		self.loadDWRALabel:SetPosition( ((self:GetWidth()-self.loadDWRALabel:GetWidth()+18)/2),290);		

		self.loadDWRAToggle = Turbine.UI.Lotro.CheckBox();
		self.loadDWRAToggle:SetCheckAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
		self.loadDWRAToggle:SetParent(self);
		self.loadDWRAToggle:SetBackColor(Turbine.UI.Color( 0.1, 0.1, 0.1 ));
		self.loadDWRAToggle:SetSize(16,16);
		self.loadDWRAToggle:SetChecked(false);
		self.loadDWRAToggle:SetText("");
		self.loadDWRAToggle.CheckedChanged=function()
		end
		self.loadDWRAToggle:SetPosition( self.loadDWRALabel:GetLeft()-18,292);
	end
end

function OptionWindow:Show()
	self:SetVisible(true);
end