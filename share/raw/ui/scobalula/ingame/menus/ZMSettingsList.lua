-- -------------------------------------------------------------------------------
-- In-Game Settings Menu for Black Ops III Zombies - Harry's Downfall Edition
-- Copyright (c) 2022 Philip/Scobalula
-- -------------------------------------------------------------------------------
-- Licensed under the "Do whatever you want thx hun bun" license.
-- -------------------------------------------------------------------------------
local PostLoadFunc = function(self, controller, menu)
	if CoD.isPC then
		self:setHandleMouseButton(false)
		self:setForceMouseEventDispatch(true)
	end
end

CoD.ZMSettingsList = InheritFrom(LUI.UIElement)
CoD.ZMSettingsList.new = function(menu, controller)
	local self = LUI.UIVerticalList.new()

	if PostLoadFunc then
		PostLoadFunc(self, controller)
	end

	self:setAlignment(LUI.Alignment.Top)
	self:setUseStencil(false)
	self:setClass(CoD.ZMSettingsList)
	self:setLeftRight(true, false, 0, 670)
	self:setTopBottom(true, false, 0, 110)
	self:makeFocusable()
	self.id = "ZMSettingsList"
	self.soundSet = "default"
	self.onlyChildrenFocusable = true
	self.anyChildUsesUpdateState = true
	
	local Title = CoD.StartMenu_OptionHighlight.new(menu, controller)
	Title:setLeftRight(true, false, 41, 539)
	Title:setTopBottom(true, false, 0, 37)
	Title:setRFTMaterial(LUI.UIImage.GetCachedMaterial("ui_add"))
	Title.DescTitle:setText(LocalizeToUpperString("DRAFT SETTINGS"))
	self:addElement(Title)
	self.Title = Title

	local ButtonList = LUI.UIList.new(menu, controller, 2, 0, nil, false, false, 0, 0, false, false)
	ButtonList.id = "ButtonList"
	ButtonList:makeFocusable()
	ButtonList:setLeftRight(true, false, 0, 670)
	ButtonList:setTopBottom(true, false, 37, 103)
	ButtonList:setWidgetType(CoD.ZmMenuSlider)
	ButtonList:setVerticalCount(15)
    ButtonList:registerEventHandler("gain_focus", function(element, event)
		local result = nil
		if element.gainFocus then
			result = element:gainFocus(event)
		elseif element.super.gainFocus then
			result = element.super:gainFocus(event)
		end
		CoD.Menu.UpdateButtonShownState(element, menu, controller, Enum.LUIButton.LUI_KEY_START)
		return result
	end)
	ButtonList:registerEventHandler("lose_focus", function(element, event)
		local result = nil

		if element.loseFocus then
			result = element:loseFocus(event)
		elseif element.super.loseFocus then
			result = element.super:loseFocus(event)
		end

		return result
	end)
	self:addElement(ButtonList)
	self.ButtonList = ButtonList

	local OptionInfo = CoD.OptionInfoWidget.new(menu, controller)
	OptionInfo:setLeftRight(true, false, 700, 950)
	OptionInfo:setTopBottom(true, false, 0, 330)
	OptionInfo.description:setText(Engine.Localize("Highlight a setting to see its description."))
	OptionInfo.title.itemName:setText(Engine.Localize("Description"))
	OptionInfo:subscribeToGlobalModel(controller, "GametypeSettings", "description", function(model)
		local description = Engine.GetModelValue(model)
		if description then
			OptionInfo.description:setText(Engine.Localize(description))
		end
	end)
	self:addElement(OptionInfo)
	self.OptionInfo = OptionInfo

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function()
				self:setupElementClipCounter(1)
				Title:completeAnimation()
				self.Title:setLeftRight(true, false, 40, 382)
				self.Title:setTopBottom(true, false, 0, 40)
				self.clipFinished(Title, {})
			end
		}
	}

	self:registerEventHandler("gain_focus", function(element, event)
		if element.m_focusable and element.ButtonList:processEvent(event) then
			return true
		else
			return LUI.UIElement.gainFocus(element, event)
		end
	end)

	LUI.OverrideFunction_CallOriginalSecond(self, "close", function(element)
		element.Title:close()
		element.ButtonList:close()
		element.OptionInfo:close()
	end)
	
	if PostLoadFunc then
		PostLoadFunc(self, controller, menu)
	end
	
	return self
end