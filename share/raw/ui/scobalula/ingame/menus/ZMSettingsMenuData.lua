-- -------------------------------------------------------------------------------
-- In-Game Settings Menu for Black Ops III Zombies - Harry's Downfall Edition
-- Copyright (c) 2022 Philip/Scobalula
-- -------------------------------------------------------------------------------
-- Licensed under the "Do whatever you want thx hun bun" license.
-- -------------------------------------------------------------------------------

-- Splits the string by the provided separator.
local function SplitString(input, sep)
	local result = {}

	for str in string.gmatch(input, "([^".. sep .."]+)") do
		table.insert(result, str)
	end

	return result
end

-- Resets the ZM settings values.
CoD.ResetZMSettings = function()
	local tableName = "gamedata/gamesettings/tabs.csv"
	local rowCount = Engine.GetTableRowCount(tableName) - 1

	for index = 1, rowCount, 1 do
		local fullTableName = "gamedata/gamesettings/" .. Engine.TableGetColumnValueForRow(tableName, index, 5) .. ".csv"
		local settingsRowCount = Engine.GetTableRowCount(fullTableName) - 1
		
		for settingsIndex = 1, settingsRowCount, 1 do
			Engine.SetDvar(Engine.TableGetColumnValueForRow(fullTableName, settingsIndex, 2):lower(), 0)
		end
	end

	Engine.ForceNotifyModelSubscriptions(Engine.CreateModel(Engine.CreateModel(Engine.GetGlobalModel(), "GametypeSettings"), "Update"))
end

-- The tabs data source, also handles creating sub data sources for each tab.
DataSources.ZMGameSettingsMenuTabs = DataSourceHelpers.ListSetup("ZMGameSettingsMenuTabs", function (controller)
	local result = {}

	-- Start with left shoulder of the tabs
	table.insert(result, { models = { tabIcon = CoD.buttonStrings.shoulderl }, properties = { m_mouseDisabled = true } })

	-- We'll store our values in a string table we can access even in GSC if we need
	local tableName = "gamedata/gamesettings/tabs.csv"
	local rowCount = Engine.GetTableRowCount(tableName) - 1

	for index = 1, rowCount, 1 do
		-- Read the tab from the row.
		local tabName           = Engine.TableGetColumnValueForRow(tableName, index, 0)
		local tabIcon           = Engine.TableGetColumnValueForRow(tableName, index, 1)
		local tabId             = Engine.TableGetColumnValueForRow(tableName, index, 2)
		local dataSourceName    = Engine.TableGetColumnValueForRow(tableName, index, 3)
		local title             = Engine.TableGetColumnValueForRow(tableName, index, 4)
		local stringTableName   = Engine.TableGetColumnValueForRow(tableName, index, 5)

		table.insert(result,
		{
			models = { tabName = tabName, tabIcon = tabIcon },
			properties = { tabId = tabId, dataSourceName = dataSourceName, title = title, stringTableName = stringTableName }
		})

		-- Create a datasource for this tabs items, we'll use a string table for each tab.
		DataSources[dataSourceName] = DataSourceHelpers.ListSetup(dataSourceName, function(controller)
			local settingsResult = {}
			local fullTableName = "gamedata/gamesettings/" .. stringTableName .. ".csv"
			local settingsRowCount = Engine.GetTableRowCount(fullTableName) - 1

			for settingsIndex = 1, settingsRowCount, 1 do
				-- Read each value for this row.
				local title         = Engine.TableGetColumnValueForRow(fullTableName, settingsIndex, 0)
				local description   = Engine.TableGetColumnValueForRow(fullTableName, settingsIndex, 1)
				local id            = Engine.TableGetColumnValueForRow(fullTableName, settingsIndex, 2)
				local values        = Engine.TableGetColumnValueForRow(fullTableName, settingsIndex, 3)

				-- Build our list of settings from the values from the string table.
				local finalValues = {}
				local unpackedValues = SplitString(values, ",")

				for index, value in ipairs(unpackedValues) do
					table.insert(finalValues, { option = value, value = index, default = index == 1 })
				end

				-- Add final dvar value to our list.
				table.insert(settingsResult, CoD.OptionsUtility.CreateDvarSettings(
					controller,
					title,
					description:gsub("\\n", "\n"),
					id,
					id:lower(),
					finalValues,
					nil,
					function(self, element, controller, actionParam, menu)
						UpdateInfoModels(element)
	
						-- Have to validate value otherwise we keep notifying
						if element.value ~= Engine.DvarInt(nil, actionParam) then
							Engine.SetDvar(actionParam, element.value)
							Engine.ForceNotifyModelSubscriptions(Engine.CreateModel(Engine.CreateModel(Engine.GetGlobalModel(), "GametypeSettings"), "Update"))
						end
					end))
			end

			return settingsResult
		end)
	end

	-- End with right shoulder of the tabs
	table.insert(result, { models = { tabIcon = CoD.buttonStrings.shoulderl }, properties = { m_mouseDisabled = true } })

	-- ON YOUR FEET SOLDIER WE ARE LEAVING
	return result
end, true)