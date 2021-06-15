import "Turbine.UI";

ConfirmInstanceWindow = class(Turbine.UI.Lotro.Window);

function ConfirmInstanceWindow:Constructor(instanceName)
	Turbine.UI.Lotro.Window.Constructor(self);

	local displayWidth = Turbine.UI.Display:GetWidth();
	local displayHeight = Turbine.UI.Display:GetHeight();

	-- create the Window
	self:SetSize(400,310);
	self:SetPosition((displayWidth-self:GetWidth())/2,(displayHeight-self:GetHeight())/2);
	self:SetBlendMode(Turbine.UI.BlendMode.Undefined);
	self:SetText("Select Instance Size");
	self.Closing = function()
		
	end
	
	-- create a heading text
	self.headingText = ScalingLabel();
	self.headingText:SetMultiline(true);
	self.headingText:SetParent(self);
	self.headingText:SetFont(Turbine.UI.Lotro.Font.TrajanPro20);
	self.headingText:SetSize(300,80);
	self.headingText:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	self.headingText:SetText("Please confirm what instance size you are in for the " .. instanceName .. " Epic Battle.");
	self.headingText:CalcSmallestFontH("TrajanPro", 40);
	self.headingText:SetPosition( ((self:GetWidth()-self.headingText:GetWidth())/2), 50);

	-- create a solo button
	self.soloButton = Turbine.UI.Lotro.Button();
	self.soloButton:SetParent(self);
	self.soloButton:SetPosition(100, 160);
	self.soloButton:SetSize(200,200);
	self.soloButton:SetBackColor(Turbine.UI.Color(.3,.3,.7));
	self.soloButton:SetText("Solo Instance");
	self.soloButton.Click=function(sender, args)
		if instanceName == EBLangData.HammerMinasTirith then
			setUpEBObj("Hammer of the Underworld - Solo/Duo");
		elseif instanceName == EBLangData.DefenceMinasTirith then
			setUpEBObj("The Defence of Minas Tirith - Solo/Duo");
		end
		self:SetVisible(false);
	end
	
	-- create a non-solo button
	self.nonSoloButton = Turbine.UI.Lotro.Button();
	self.nonSoloButton:SetParent(self);
	self.nonSoloButton:SetPosition(100, 200);
	self.nonSoloButton:SetSize(200,200);
	self.nonSoloButton:SetBackColor(Turbine.UI.Color(.3,.3,.7));
	if instanceName == EBLangData.HammerMinasTirith then
		self.nonSoloButton:SetText("Fellowship Instance");
	elseif instanceName == EBLangData.DefenceMinasTirith then
		self.nonSoloButton:SetText("Small Fellowship Instance");
	end
	self.nonSoloButton.Click=function(sender, args)
		if instanceName == EBLangData.HammerMinasTirith then
			setUpEBObj("Hammer of the Underworld - Fellowship");
		elseif instanceName == EBLangData.DefenceMinasTirith then
			setUpEBObj("The Defence of Minas Tirith - Small Fellowship");
		end
		self:SetVisible(false);
	end
	
	-- create a cancel button
	self.cancelButton = Turbine.UI.Lotro.Button();
	self.cancelButton:SetParent(self);
	self.cancelButton:SetPosition(100, 240);
	self.cancelButton:SetSize(200,200);
	self.cancelButton:SetBackColor(Turbine.UI.Color(.3,.3,.7));
	self.cancelButton:SetText("Cancel");
	self.cancelButton.Click=function(sender, args)
		self:SetVisible(false);
	end
	
end

function ConfirmInstanceWindow:Show()
	self:SetVisible(true);
end