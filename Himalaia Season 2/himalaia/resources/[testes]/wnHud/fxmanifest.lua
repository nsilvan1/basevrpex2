shared_script '@wAC/client-side/library.lua'








fx_version 'adamant'
game 'gta5'

ui_page "nui/index.html"
client_scripts {
	"@vrp/lib/utils.lua",
	"client.lua"
}
server_scripts {
	"@vrp/lib/utils.lua",
	"server.lua"
}

files {
	"nui/*.html",
	"nui/*.js",
	"nui/*.css",
	"nui/bibs/loading-bar.css",
	"nui/bibs/loading-bar.js",
	"nui/svgs/*.svg",
	"nui/svgs/*.png",
}


                            