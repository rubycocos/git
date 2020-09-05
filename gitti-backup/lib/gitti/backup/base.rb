require 'gitti/base'   # note: include "modular" base without (auto)include Gitti


# our own code
require 'gitti/backup/version'   # note: let version always go first
require 'gitti/backup/backup'


# say hello
puts GittiBackup.banner       ##  if defined?($RUBYCOCO_DEBUG)

