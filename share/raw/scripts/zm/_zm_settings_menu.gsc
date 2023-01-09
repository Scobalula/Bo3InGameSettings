#using scripts\shared\util_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\math_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\array_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\lui_shared;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm;
#using scripts\shared\ai\zombie_utility;

#insert scripts\shared\shared.gsh;
#insert scripts\shared\version.gsh;
#insert scripts\zm\_zm_settings_menu.gsh;

#namespace zm_settings_menu;

REGISTER_SYSTEM_EX("zm_settings_menu", &__init__, &__main__, undefined)

#precache("menu", ZM_SETTINGS_MENU_NAME);
#precache("menu", ZM_SETTINGS_MENU_CLIENT_NAME);

function __init__()
{
	level flag::init("zm_settings_menu_complete");

	DEFAULT(level.zm_settings_menu_name, 				ZM_SETTINGS_MENU_NAME);
	DEFAULT(level.zm_settings_menu_client_name, 		ZM_SETTINGS_MENU_CLIENT_NAME);
	DEFAULT(level.zm_settings_menu_response, 			ZM_SETTINGS_MENU_RESPONSE);

	callback::on_spawned(&on_spawned);
}

function __main__()
{
}

function pregame_init(round_start_func = &zm::round_start)
{
	level.zm_settings_menu_round_start_func = round_start_func;
	level._round_start_func = &round_start_open_menu;
}

function get_setting(str_setting_name)
{
	return GetDvarInt(str_setting_name);
}

function private wait_for_menu_close()
{
	for(;;)
	{
		self waittill("menuresponse", str_menu, str_response);

		if(str_menu === level.zm_settings_menu_name && str_response == level.zm_settings_menu_response)
			break;
	}
}

function private on_spawned()
{
	menu_name = (self IsHost() ? level.zm_settings_menu_name : level.zm_settings_menu_client_name);

	if(!level flag::get("zm_settings_menu_complete"))
	{
		self disable_player();
		self CloseMenu(menu_name);
		self OpenMenu(menu_name);

		level flag::wait_till("zm_settings_menu_complete");

		self enable_player();
		self CloseMenu(menu_name);
	}

	// Handle functions
	if(isdefined(level.zm_settings_handlers))
		foreach(handler in level.zm_settings_handlers)
			if(IsFunctionPtr(handler.func_on_player_spawned))
				[[handler.func_on_player_spawned]](get_setting(handler.dvar_name));
}

function register_handler(dvar_name, func, func_on_player_spawned = undefined)
{
	DEFAULT(level.zm_settings_handlers, []);
	
	handler = SpawnStruct();
	handler.dvar_name = dvar_name;
	handler.func = func;
	handler.func_on_player_spawned = func_on_player_spawned;

	level.zm_settings_handlers[level.zm_settings_handlers.size] = handler;
}

function private round_start_open_menu()
{
	host = self util::gethostplayer();
	host wait_for_menu_close();

	if(isdefined(level.zm_settings_handlers))
		foreach(handler in level.zm_settings_handlers)
				[[handler.func]](get_setting(handler.dvar_name));

	level flag::set("zm_settings_menu_complete");

	[[level.zm_settings_menu_round_start_func]]();
}

function private disable_player()
{
	self.movespeed = self GetMoveSpeedScale();
	self FreezeControls(true);
	self AllowCrouch(false);
	self AllowProne(false);
	self AllowMelee(false);
	self AllowJump(false);
	self DisableOffhandWeapons();
	self SetMoveSpeedScale(0);
	self HideViewModel();
	self EnableInvulnerability();
	self SetLowReady(1);
}

function private enable_player()
{
	self FreezeControls(false);
	self AllowCrouch(true);
	self AllowProne(true);
	self AllowMelee(true);
	self AllowJump(true);
	self EnableOffhandWeapons();
	self SetLowReady(0);
	self ShowViewModel();
	self DisableInvulnerability();

	if(isdefined(self.movespeed))
	{
		self SetMoveSpeedScale(self.movespeed);    	
	}
}