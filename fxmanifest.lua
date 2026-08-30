fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'djfivem-scriptmanager'
author 'DieselJones21'
description 'The 305 command tablet for DJ FiveM scripts plus JG mechanic, garage, and dealer tools'
version '1.4.0'

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
    'html/images/*.jpg',
}

dependencies {
    'ox_lib',
}
