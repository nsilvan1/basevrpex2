shared_script '@wAC/client-side/library.lua'







game {'gta5'}

fx_version 'cerulean'
author 'AvarianKnight / Dom Ressler#3102'
description 'pma-voice editado por Dom Ressler#3102'

--dependencies {
--   '/onesync',
--}

--lua54 'yes'

shared_script 'shared.lua'

client_scripts {
	'@vrp/lib/utils.lua',
	'client/init/proximity.lua',
	'client/init/init.lua',
	'client/init/main.lua',
	'client/module/*.lua',
    'client/*.lua',
}

server_scripts {
	'@vrp/lib/utils.lua',
    'server/**/*.lua',
	'server/**/*.js'
}

files {
    'ui/*.ogg',
    'ui/css/*.css',
    'ui/js/*.js',
    'ui/index.html',
}

ui_page 'ui/index.html'

provides {
	'mumble-voip',
    'tokovoip',
    'toko-voip',
    'tokovoip_script'
}

convar_category 'PMA-Voice' {
    "PMA-Voice Configuration Options",
    {
    { "Use native audio", "$voice_useNativeAudio", "CV_BOOL", "true" },
	{ "Use 2D audio", "$voice_use2dAudio", "CV_BOOL", "false" },
	{ "Use sending range only", "$voice_useSendingRangeOnly", "CV_BOOL", "true" },
	{ "Enable UI", "$voice_enableUi", "CV_INT", "1" },
	{ "Enable F11 proximity key", "$voice_enableProximityCycle", "CV_INT", "1" },
	{ "Proximity cycle key", "$voice_defaultCycle", "CV_STRING", "HOME" },
	{ "Voice volume", "$voice_defaultVolume", "CV_STRING", "0.3" },
	{ "Enable radios", "$voice_enableRadios", "CV_INT", "1" },
	{ "Enable phones", "$voice_enablePhones", "CV_INT", "1" },
	{ "Enable sublix", "$voice_enableSubmix", "CV_INT", "1" },
    { "Enable radio animation", "$voice_enableRadioAnim", "CV_INT", "1" },
	{ "Radio key", "$voice_defaultRadio", "CV_STRING", "CAPITAL" },
	{ "UI refresh rate", "$voice_uiRefreshRate", "CV_INT", "200" },
	{ "Enable voice sync (state bags)", "$voice_syncData", "CV_INT", "0" },
	{ "Allow players to set audio intent", "$voice_allowSetIntent", "CV_INT", "1" },
	{ "External mumble server address", "$voice_externalAddress", "CV_STRING", "" },
	{ "External mumble server port", "$voice_externalPort", "CV_INT", "0" },
	{ "Voice debug mode", "$voice_debugMode", "CV_INT", "0" },
	{ "Disable players being allowed to join", "$voice_externalDisallowJoin", "CV_INT", "0" },
	{ "Hide server endpoints in logs", "$voice_hideEndpoints", "CV_INT", "1" },
    }
}
