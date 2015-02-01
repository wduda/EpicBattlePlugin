ScalingLabel = class(Turbine.UI.Label);

function ScalingLabel:Constructor()
	Turbine.UI.Label.Constructor( self );

	-- create the horizontal and vertical scrollbars
	self.hScrollbar = Turbine.UI.Lotro.ScrollBar();
	self.hScrollbar:SetOrientation(Turbine.UI.Orientation.Horizontal);
	self.hScrollbar:SetSize(0,0);
	self.hScrollbar:SetParent(self);

	self.vScrollbar = Turbine.UI.Lotro.ScrollBar();
	self.vScrollbar:SetOrientation(Turbine.UI.Orientation.Vertical);
	self.vScrollbar:SetSize(0,0);
	self.vScrollbar:SetParent(self);

	-- set the scrollbars to the label
	self:SetHorizontalScrollBar(self.hScrollbar);
	self:SetVerticalScrollBar(self.vScrollbar);

end

-- use this function to calculate what the smallest width of this label would be (this labels IsMultiline() must be false)
-- Prior to calling this function make sure the text is set; optionally, make sure the height, minimum width, and font are set
function ScalingLabel:CalcSmallestWidth()
	-- we can only calculate the smallest width if the label is not multiline
	if self:IsMultiline() then
		self:SetText(self:GetText()); -- update label
		while self.hScrollbar:IsVisible() do
			local width = self:GetWidth() + 5;
			self:SetWidth(width);
		end
		self:SetWidth(self:GetWidth() + 10);
	end
end

-- use this function to calculate what the smallest font would need to be to fit the text into the label's width (this labels IsMultiline() must be false)
-- font is the font type you want; for example, TrajanProBold
-- fontSize is the largest of the font type you want; for example, 30
-- switchFonts (optional) should be true if you want the function to switch to a smaller font if it can't make the font small enough, false otherwise
-- Prior to calling this function, make sure the width and text are set; optionally, make sure the height is set
-- returns whether the scrollbar is still visible (meaning there is no font size small enough to work)
function ScalingLabel:CalcSmallestFontW(font, fontSize, switchFonts)
	-- we can only calculate the smallest font if the label is not multiline
	if self:IsMultiline() and Turbine.UI.Lotro.Font[font .. fontSize] ~= nil then
		self:SetFont(Turbine.UI.Lotro.Font[font .. fontSize]);
		self:SetText(self:GetText()); -- update label
		local counter = 0; -- if counter gets to be high, that means we can't find a good match, end the function
		while self.hScrollbar:IsVisible() and counter < 20 do
			if Turbine.UI.Lotro.Font[font .. (fontSize-1)] ~= nil then
				self:SetFont(Turbine.UI.Lotro.Font[font .. (fontSize-1)]);
			end
			fontSize = fontSize - 1;
			counter = counter + 1;
			self:SetText(self:GetText()); -- updates label
		end
		if self.hScrollbar:IsVisible() and switchFonts then
			counter = 0;
			font = "Verdana";
			fontSize = 16;
			self:SetFont(Turbine.UI.Lotro.Font[font .. fontSize]);
			while self.hScrollbar:IsVisible() and counter < 6 do
				if Turbine.UI.Lotro.Font[font .. (fontSize-1)] ~= nil then
					self:SetFont(Turbine.UI.Lotro.Font[font .. (fontSize-1)]);
				end
				fontSize = fontSize - 1;
				counter = counter + 1;
				self:SetText(self:GetText()); -- updates label
			end
		end
	end
	return self.hScrollbar:IsVisible();
end

-- use this function to calculate what the smallest font would need to be to fit the text into the label's height
-- font is the font type you want; for example, TrajanProBold
-- fontSize is the largest of the font type you want; for example, 30
-- switchFonts (optional) should be true if you want the function to switch to a smaller font if it can't make the font small enough, false otherwise
-- Prior to calling this function, make sure the height and text are set; optionally, make sure the width is set
-- returns whether the scrollbar is still visible (meaning there is no font size small enough to work)
function ScalingLabel:CalcSmallestFontH(font, fontSize, switchFonts)
	if Turbine.UI.Lotro.Font[font .. fontSize] ~= nil then
		self:SetFont(Turbine.UI.Lotro.Font[font .. fontSize]);
		self:SetText(self:GetText()); -- make sure label is updated
		local counter = 0; -- if counter gets too high, that means we can't find a good match, end the function
		while self.vScrollbar:IsVisible() and counter < 20 do
			if Turbine.UI.Lotro.Font[font .. (fontSize-1)] ~= nil then
				self:SetFont(Turbine.UI.Lotro.Font[font .. (fontSize-1)]);
			end
			fontSize = fontSize - 1;
			counter = counter + 1;
			self:SetText(self:GetText()); -- updates label
		end
		if self.vScrollbar:IsVisible() and switchFonts then
			counter = 0;
			font = "Verdana";
			fontSize = 16;
			self:SetFont(Turbine.UI.Lotro.Font[font .. fontSize]);
			while self.vScrollbar:IsVisible() and counter < 6 do
				if Turbine.UI.Lotro.Font[font .. (fontSize-1)] ~= nil then
					self:SetFont(Turbine.UI.Lotro.Font[font .. (fontSize-1)]);
				end
				fontSize = fontSize - 1;
				counter = counter + 1;
				self:SetText(self:GetText()); -- updates label
			end
		end
	end
	return self.vScrollbar:IsVisible();
end

-- use this function to calculate what the smallest font would need to be to fit the text into this label (this label's IsMultiline() must be false)
-- font is the font type you want; for example, TrajanProBold
-- fontSize is the largest of the font type you want; for example, 30
-- switchFonts (optional) should be true if you want the function to switch to a smaller font if it can't make the font small enough, false otherwise
-- Prior to calling this function, make sure the width, height and text are set
-- returns whether the vScrollbar and hScrollbar are still visible (meaning there is no font size small enough to work)
function ScalingLabel:CalcSmallestFont(font, fontSize, switchFonts)
	-- we can only calculate the smallest font if the label is not multiline
	if self:IsMultiline() and Turbine.UI.Lotro.Font[font .. fontSize] ~= nil then
		self:SetFont(Turbine.UI.Lotro.Font[font .. fontSize]);
		self:SetText(self:GetText()); -- update label
		local counter = 0; -- if counter gets to be high, that means we can't find a good match, end the function
		while (self.hScrollbar:IsVisible() or self.vScrollbar:IsVisible()) and counter < 20 do
			if Turbine.UI.Lotro.Font[font .. (fontSize-1)] ~= nil then
				self:SetFont(Turbine.UI.Lotro.Font[font .. (fontSize-1)]);
			end
			fontSize = fontSize - 1;
			counter = counter + 1;
			self:SetText(self:GetText()); -- updates label
		end
		if (self.hScrollbar:IsVisible() or self.vScrollbar:IsVisible()) and switchFonts then
			counter = 0;
			font = "Verdana";
			fontSize = 16;
			self:SetFont(Turbine.UI.Lotro.Font[font .. fontSize]);
			while (self.hScrollbar:IsVisible() or self.vScrollbar:IsVisible()) and counter < 6 do
				if Turbine.UI.Lotro.Font[font .. (fontSize-1)] ~= nil then
					self:SetFont(Turbine.UI.Lotro.Font[font .. (fontSize-1)]);
				end
				fontSize = fontSize - 1;
				counter = counter + 1;
				self:SetText(self:GetText()); -- updates label
			end
		end
	end
	return self.vScrollbar:IsVisible(), self.hScrollbar:IsVisible();
end

-- use this function to calcuate what the smallest height of this label would be.
-- Prior to calling this function, make sure the text is set; optionally, make sure the width, minimum height, font, and multiline are set
function ScalingLabel:CalcSmallestHeight()
	self:SetText(self:GetText()); -- make sure multiline is being used properly
	while self.vScrollbar:IsVisible() do
		local height = self:GetHeight() + 5;
		self:SetHeight(height);
	end
	self:SetHeight(self:GetHeight() + 10);
end
