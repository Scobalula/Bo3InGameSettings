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
require("ui.Scobalula.InGame.Menus.ZMSettingsMenuClient")
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

LUI.createMenu.ZMSettingsMenu = function (controller)
	local self = CoD.Menu.NewForUIEditor("ZMSettingsMenu")

	if PreLoadFunc then
		PreLoadFunc(self, controller)
	end

	self.soundSet = "ChooseDecal"
	self.buttonModel = Engine.CreateModel(Engine.GetModelForController(controller), "ZMSettingsMenu.buttonPrompts")
	self.anyChildUsesUpdateState = true
	self:setOwner(controller)
	self:setLeftRight(true, true, 0, 0)
	self:setTopBottom(true, true, 0, 0)
	self:playSound("menu_open", controller)

	local StartMenuBackground0 = CoD.StartMenu_Background.new(self, controller)
	StartMenuBackground0:setLeftRight(true, true, 0, 0)
	StartMenuBackground0:setTopBottom(true, true, 0, 0)
	self:addElement(StartMenuBackground0)
	self.StartMenuBackground0 = StartMenuBackground0

	local BlackBG = LUI.UIImage.new()
	BlackBG:setLeftRight(true, true, 0, 0)
	BlackBG:setTopBottom(true, true, 0, 0)
	BlackBG:setImage(RegisterImage("uie_fe_cp_background"))
	self:addElement(BlackBG)
	self.BlackBG = BlackBG

	local StartMenuCampaignBG = CoD.StartMenu_CampaignBG.new(self, controller)
	StartMenuCampaignBG:setLeftRight(true, true, 0, 0)
	StartMenuCampaignBG:setTopBottom(true, true, 0, 0)
	StartMenuCampaignBG:setAlpha(0)
	self:addElement(StartMenuCampaignBG)
	self.StartMenuCampaignBG = StartMenuCampaignBG

	local MenuTitleBackground = LUI.UIImage.new()
	MenuTitleBackground:setLeftRight(true, true, 0, 0)
	MenuTitleBackground:setTopBottom(false, false, -336, -276)
	MenuTitleBackground:setRGB(0.12, 0.13, 0.19)
	MenuTitleBackground:setAlpha(0)
	self:addElement(MenuTitleBackground)
	self.MenuTitleBackground = MenuTitleBackground

	local TitleText = LUI.UIText.new()
	TitleText:setLeftRight(true, false, 64, 1280)
	TitleText:setTopBottom(true, false, 31, 75)
	TitleText:setAlpha(0)
	TitleText:setText(Engine.Localize("Game Options"))
	TitleText:setTTF("fonts/escom.ttf")
	TitleText:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_LEFT)
	TitleText:setAlignment(Enum.LUIAlignment.LUI_ALIGNMENT_TOP)
	self:addElement(TitleText)
	self.TitleText = TitleText

	local ButtonBarBackground = LUI.UIImage.new()
	ButtonBarBackground:setLeftRight(true, true, -3.63, 0)
	ButtonBarBackground:setTopBottom(false, false, 302, 332)
	ButtonBarBackground:setRGB(0.12, 0.13, 0.19)
	ButtonBarBackground:setAlpha(0)
	self:addElement(ButtonBarBackground)
	self.ButtonBarBackground = ButtonBarBackground

	local FEMenuLeftGraphics = CoD.FE_Menu_LeftGraphics.new(self, controller)
	FEMenuLeftGraphics:setLeftRight(true, false, 19, 71)
	FEMenuLeftGraphics:setTopBottom(true, false, 86, 703.25)
	self:addElement(FEMenuLeftGraphics)
	self.FEMenuLeftGraphics = FEMenuLeftGraphics

	local Options = CoD.ZMSettingsList.new(self, controller)
	Options:setLeftRight(true, false, 26.000000, 741.000000)
	Options:setTopBottom(true, false, 135.000000, 720.000000)
	Options.id = "Options"
	Options.Title.DescTitle:setText("")
	Options.ButtonList:setVerticalCount(15.000000)
	self:addElement(Options)
	self.Options = Options

	self:registerEventHandler("list_active_changed", function(element, event)
		if element.dataSourceName ~= nil and element.title ~= nil then
			Options.Title.DescTitle:setText(Engine.Localize(element.title))
			Options.ButtonList:setDataSource(element.dataSourceName)
		end
		return nil
	end)
	
	local MenuFrame = CoD.GenericMenuFrame.new(self, controller)
	MenuFrame:setLeftRight(true, true, 0, 0)
	MenuFrame:setTopBottom(true, true, 0, 0)
	MenuFrame.titleLabel:setText(Engine.Localize("GAME OPTIONS"))
	MenuFrame.cac3dTitleIntermediary0.FE3dTitleContainer0.MenuTitle.TextBox1.Label0:setText(Engine.Localize("GAME OPTIONS"))
	self:addElement(MenuFrame)
	self.MenuFrame = MenuFrame
	
	local CategoryListPanel = LUI.UIImage.new()
	CategoryListPanel:setLeftRight(true, true, 0, 0)
	CategoryListPanel:setTopBottom(false, false, -274, -235)
	CategoryListPanel:setRGB(0, 0, 0)
	self:addElement(CategoryListPanel)
	self.CategoryListPanel = CategoryListPanel
	
	local FETabBar = CoD.FE_TabBar.new(self, controller)
	FETabBar:setLeftRight(true, true, 0, 1217)
	FETabBar:setTopBottom(true, false, 85, 126)
	FETabBar.Tabs.grid:setHorizontalCount(8)
	FETabBar.Tabs.grid:setDataSource("ZMGameSettingsMenuTabs")
	self:addElement(FETabBar)
	self.FETabBar = FETabBar
	
	local StartMenuCurrencyCounts = CoD.StartMenu_CurrencyCounts.new(self, controller)
	StartMenuCurrencyCounts:setLeftRight(false, true, -653.81, -449.81)
	StartMenuCurrencyCounts:setTopBottom(true, false, 37, 67)
	self:addElement(StartMenuCurrencyCounts)
	self.StartMenuCurrencyCounts = StartMenuCurrencyCounts
	
	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter(3)
				StartMenuBackground0:completeAnimation()
				self.StartMenuBackground0:setAlpha(1)
				self.clipFinished(StartMenuBackground0, {})
				StartMenuCampaignBG:completeAnimation()
				self.StartMenuCampaignBG:setAlpha(0)
				self.clipFinished(StartMenuCampaignBG, {})
				StartMenuCurrencyCounts:completeAnimation()
				self.StartMenuCurrencyCounts:setAlpha(0)
				self.clipFinished(StartMenuCurrencyCounts, {})
			end
		}
	}

	-- Circle Event
	self:AddButtonCallbackFunction(self, controller, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, nil, function (element, menu, controller, model)
		Engine.SendMenuResponse(controller, self.menuName, "zmsettings_closed")
		PlaySoundSetSound(self, "menu_go_back")
		Close(self, controller)
		return true
	end, function (element, menu, controller)
		CoD.Menu.SetButtonLabel(menu, Enum.LUIButton.LUI_KEY_XBB_PSCIRCLE, "Start Game")
		return true
	end, false)
	-- M Key Event
	self:AddButtonCallbackFunction(self, controller, Enum.LUIButton.LUI_KEY_START, "M", function (element, menu, controller, model)
		CoD.ResetZMSettings()
		Options.ButtonList:updateDataSource()
		return true
	end, function (element, menu, controller)
		CoD.Menu.SetButtonLabel(menu, Enum.LUIButton.LUI_KEY_START, "Reset Settings")
		return true
	end, false)
	-- Cross Event
	self:AddButtonCallbackFunction(self, controller, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, nil, function (element, menu, controller, model)
		PlaySoundSetSound(self, "list_action")
		return true
	end, function (element, menu, controller)
		CoD.Menu.SetButtonLabel(menu, Enum.LUIButton.LUI_KEY_XBA_PSCROSS, "MENU_SELECT")
		return true
	end, false)
	-- Escape Event
	self:AddButtonCallbackFunction(self, controller, Enum.LUIButton.LUI_KEY_NONE, "ESCAPE", function (element, menu, controller, model)
		Engine.SendMenuResponse(controller, self.menuName, "zmsettings_closed")
		PlaySoundSetSound(self, "menu_go_back")
		Close(self, controller)
		return true
	end, function (element, menu, controller)
		CoD.Menu.SetButtonLabel(menu, Enum.LUIButton.LUI_KEY_NONE, "Start Game")
		return true
	end, false, true)

	MenuFrame:setModel(self.buttonModel, controller)

	self:processEvent({ name = "menu_loaded", controller = controller })
	self:processEvent({ name = "update_state", menu = self })

	if not self:restoreState() then
		-- We need to gain focus on options for controllers
		self.Options:processEvent({name = "gain_focus", controller = Instance})
	end

	LUI.OverrideFunction_CallOriginalSecond(self, "close", function (element)
		element.StartMenuBackground0:close()
		element.StartMenuCampaignBG:close()
		element.FEMenuLeftGraphics:close()
		element.MenuFrame:close()
		element.FETabBar:close()
		element.StartMenuCurrencyCounts:close()
		element.Options:close()
		Engine.UnsubscribeAndFreeModel(Engine.GetModel(Engine.GetModelForController(controller), "ZMSettingsMenu.buttonPrompts"))
	end)

	if PostLoadFunc then
		PostLoadFunc(self, controller)
	end
	
	return self
end

