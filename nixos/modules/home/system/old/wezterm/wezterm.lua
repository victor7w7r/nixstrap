local Config = require 'config'

require('config.events').setup()
require('config.events').setup_title()

return Config:init()
  :append(require('config.appearance'))
  :append(require('config.bindings'))
  :append(require('config.domains'))
  :append(require('config.general'))
  :append(require('config.launch')).options