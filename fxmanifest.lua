fx_version 'cerulean'
games { 'gta5' }

shared_scripts {
  'config.lua',
}

client_script 'cl_strana.lua'

server_scripts { 
  '@oxmysql/lib/MySQL.lua',
  'sv_strana.lua',
}