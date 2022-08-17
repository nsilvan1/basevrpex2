fx_version 'cerulean'
game 'gta5'

author 'Who'
contact 'Why?'
version '1.0.0'

client_scripts {
    '@vrp/lib/utils.lua',
    'hansolo/*'
}

server_scripts {
    '@vrp/lib/utils.lua',
    'skywalker.lua'
}

files {
    'nui/*',
    'nui/*',
    'nui/*',
    'nui/**/*'
}

loadscreen 'nui/darkside.html'
loadscreen_manual_shutdown "yes"