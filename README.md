# 🧟 Call of Duty: Black Ops III In-Game Settings Menu 🧟

This is an in-game settings menu you can add to your maps/mods to allow you to add settings players can edit while in-game without the need to jump into the main menu. By default this menu opens when the game starts but if you want to extend the script you can modify to work as a menu you can open at any time.

This is a pretty barebones menu as the intention is for you to edit it with the settings you want!

# Installing

1. Head over to the [Releases](https://github.com/Scobalula/Bo3InGameSettings/releases) section and download the latest release.
2. Open the zip file and copy the contents into your Call of Duty: Black Ops III directory.
3. Open your map's zone file and add the following items:
```
rawfile,ui/scobalula/ingame/menus/zmsettingsmenu.lua
rawfile,ui/scobalula/ingame/menus/zmsettingsmenuclient.lua
rawfile,ui/scobalula/ingame/menus/zmsettingslist.lua
rawfile,ui/scobalula/ingame/menus/zmsettingsmenudata.lua
rawfile,ui/scobalula/ingame/menus/zmsettingsmenuslider.luac
stringtable,gamedata/gamesettings/tabs.csv
stringtable,gamedata/gamesettings/tab_0.csv
stringtable,gamedata/gamesettings/tab_1.csv
stringtable,gamedata/gamesettings/tab_2.csv
stringtable,gamedata/gamesettings/tab_3.csv
scriptparsetree,scripts/zm/_zm_settings_menu.gsc
```
4. Open your map gsc and add the following to where the using statements are:
```gsc
#using scripts\zm\_zm_settings_menu;
```
5. Add the following to your map's `main` function in its gsc file below `zm_usermap::main();`:
```gsc
zm_settings_menu::pregame_init();
```
6. Add the following to your map's `main` function:
```gsc
LuiLoad("ui.Scobalula.InGame.Menus.ZMSettingsMenu");
```
7. You should be good to go, see below for customization!

# Adding Tabs

To add tabs open the `gamedata\gamesettings\tabs.csv` file and simply add your tab to it. Make sure to make the `tabID` and `dataSourceName` entries unique to each tab.

Here's a run down of the settings:

* **tabName** - The tab name displayed in the tab bar.
* **tabIcon** - The icon displayed on the tab bar.
* **tabID** - The internal tab id. Ensure its unique to the tab.
* **dataSourceName** - The internal data source name. Ensure its unique to the tab.
* **title** - The title displayed above the settings.
* **stringTableName** - The name of the string table to pull the settings from for the tab.

Next you'll need a string table for your tab. All string tables must be placed under `gamedata\gamesettings\` as this is where the Lua file looks for. You can see examples of tabs provided. This is explained in the next section.

# Adding Settings

To edit the settings for each tab you'll need a string table for that tab. If we look at the examples, we can see the following settings for each setting:

* **title** - The title displayed in the settings list.
* **description** - The description displayed at the side.
* **id** - The id for this setting. This is used in gsc to get the setting (aka DVAR).
* **values** - The values split by a comma. Ensure this is wrapped in quotes so that doesn't get mistaken for multiple columns on the row.

We can optionally register a handler that gets executed when the menu closes:

```gsc
register_handler(dvar_name, func, func_on_player_spawned = undefined)

// Example
register_handler("ZMSettings_MyValue", &my_func);

function my_func(value)
{
    // Do something with the value when the menu closes.
}
```

# Example Setting

Let's say we wanted a setting for a round number modifier, to begin we would make the following entry:

* **title** - Start Round
* **description** - Choose the ^3Round^7 you wish the game to begin at.
* **id** - ZMSettings_Round
* **values** - "Round 1,Round 5,Round 10,Round 20,Round 50,Round 100"

In the csv this would look like this:

```
Start Round,"Choose the ^3Round^7 you wish the game to begin at.",ZMSettings_Round,"Round 1,Round 5,Round 10,Round 20,Round 50,Round 100"
```

Next we'll register a handler:

```gsc
zm_settings_menu::register_handler("ZMSettings_Round", &set_starting_round);

function private set_starting_round(value)
{
	zm::set_round_number(array(1, 1, 5, 10, 20, 50, 100)[value]);
}
```

# Reporting Problems

Ultimately the script was made for my own purposes and released for the wider community to use. While I have battletested this script on both my own and stock maps to high rounds in developer mode, we're all human and so things may have bugs! If you run into issues feel free to open an issue, I am also open to anyone to improve the script by making a pull request! When working on your map always have `developer 2` on, as it helps to identify where problems are and it can also assist me in identifying possible problems and where they are within the script. Please also feel free to open an issue if you think there is a part of the instructions that is confusing, identifying confusing parts of the instructions helps me identify key areas I should focus in on or improve when writing documentation!

❤️ You can also join my Discord to report issues or get general help ❤️

[![Join my Discord](https://discordapp.com/api/guilds/719503756810649640/widget.png?style=banner2)](https://discord.gg/RyqyThu)
 
# Credits

* JariK - [CoDLuaDecompiler](https://github.com/JariKCoding/CoDLuaDecompiler)
* TheBlackDeathZM - General Help

While appreciated, if you use the script there is no requirement to credit me, focus on making your projects extra spicy. 🌶️