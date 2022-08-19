
fx_version "bodacious"
game "gta5"

ui_page "nui/index.html"

client_scripts {
	"@vrp/lib/utils.lua",
	"client-side/*",
	"revistar.lua",
	"craft.lua"
}

server_scripts {
	"@vrp/lib/utils.lua",
	"server-side/*",
	"revistar.lua",
	"craft.lua"
}

files {
	"nui/*.*",
	"nui/app/*",
}