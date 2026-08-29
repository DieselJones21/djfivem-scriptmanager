fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'djfivem-scriptmanager'
author 'DieselJones21'
description 'Discord-locked admin tablet for every DJ FiveM script — resource control, allowlisted commands, config colors'
version '1.2.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'shared/utils.lua',
    'shared/catalog.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    'server/access.lua',
    'server/permissions.lua',
    'server/main.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
    'html/images/*.png',
}

dependencies {
    'ox_lib',
}
