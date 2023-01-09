-- -------------------------------------------------------------------------------
-- In-Game Settings Menu for Black Ops III Zombies - Harry's Downfall Edition
-- Copyright (c) 2022 Philip/Scobalula
-- -------------------------------------------------------------------------------
-- Licensed under the "Do whatever you want thx hun bun" license.
-- -------------------------------------------------------------------------------
require("ui.uieditor.menus.Social.Social_Main")
require("ui.uieditor.widgets.StartMenu.StartMenu_Background")
require("ui.uieditor.widgets.StartMenu.CP.StartMenu_CampaignBG")
require("ui.uieditor.widgets.Lobby.Common.FE_Menu_LeftGraphics")
require("ui.uieditor.widgets.BackgroundFrames.GenericMenuFrame")
require("ui.uieditor.widgets.Lobby.Common.FE_TabBar")
require("ui.uieditor.widgets.StartMenu.StartMenu_CurrencyCounts")
require("ui.uieditor.widgets.StartMenu.StartMenu_OptionHighlight")
require("ui.Scobalula.InGame.Menus.ZMSettingsMenuSlider")
require("ui.Scobalula.InGame.Menus.ZMSettingsList")
require("ui.Scobalula.InGame.Menus.ZMSettingsMenuData")

local PostLoadFunc = function (self, controller)
	self.disableDarkenElement = true
	self:registerEventHandler("open_migration_menu", function (element, event)
		CloseAllOccludingMenus(element, controller)
		StartMenuResumeGame(element, event.controller)
		GoBack(element, event.controller)
	end)
	SetControllerModelValue(controller, "forceScoreboard", 0)
end

LUI.createMenu.ZMSettingsMenuClient = function (controller)
	local self = CoD.Menu.NewForUIEditor("ZMSettingsMenuClient")

	if PreLoadFunc then
		PreLoadFunc(self, controller)
	end

	self.soundSet = "ChooseDecal"
	self.buttonModel = Engine.CreateModel(Engine.GetModelForController(controller), "ZMSettingsMenuClient.buttonPrompts")
	self.anyChildUsesUpdateState = true
	self:setOwner(controller)
	self:setLeftRight(true, true, 0, 0)
	self:setTopBottom(true, true, 0, 0)
	self:playSound("menu_open", controller)

	local BlackBG = LUI.UIImage.new()
	BlackBG:setLeftRight(true, true, 0, 0)
	BlackBG:setTopBottom(true, true, 0, 0)
	BlackBG:setImage(RegisterImage("uie_fe_cp_background"))
	self:addElement(BlackBG)
	self.BlackBG = BlackBG

	local MenuFrame = CoD.GenericMenuFrame.new(self, controller)
	MenuFrame:setLeftRight(true, true, 0, 0)
	MenuFrame:setTopBottom(true, true, 0, 0)
    MenuFrame:setModel(self.buttonModel, controller)
	MenuFrame.titleLabel:setText(Engine.Localize("WAITING FOR THE HOST"))
	MenuFrame.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.Label0:setText(Engine.Localize("WAITING FOR THE HOST"))
	self:addElement(MenuFrame)
	self.MenuFrame = MenuFrame

	self:processEvent({ name = "menu_loaded", controller = controller })
	self:processEvent({ name = "update_state", menu = self })

	LUI.OverrideFunction_CallOriginalSecond(self, "close", function (element)
		element.MenuFrame:close()
		Engine.UnsubscribeAndFreeModel(Engine.GetModel(Engine.GetModelForController(controller), "ZMSettingsMenuClient.buttonPrompts"))
	end)

	if PostLoadFunc then
		PostLoadFunc(self, controller)
	end
	
	return self
end

