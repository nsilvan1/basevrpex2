fx_version "bodacious"
game "gta5"

author 'Cruz#6820'
description 'Cruz' 
version '1.0'

ui_page_preload "yes"
ui_page "nui/ui.html"

client_scripts {
	"@vrp/lib/utils.lua",
	"client.lua"
}

server_scripts {
	"@vrp/lib/utils.lua",
	"server.lua"
}

files {
	'nui/*.html',
	'nui/*.js',
    'nui/*.css',
	'nui/**/*'
}