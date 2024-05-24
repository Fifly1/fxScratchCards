fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'fx'
description 'fxScratchCards'
version '1.2'

ui_page 'html/index.html'

client_scripts {
    'client.lua',
    'config.lua'
}

server_scripts {
    'server.lua',
    'config.lua'
}

shared_script 'config.lua'

files {
    'html/*.*'
}

escrow_ignore {
    'html/index.html',
    'html/styles.css',
    'html/index.js',
    'client.lua',
    'config.lua',
    'server.lua'
  }
