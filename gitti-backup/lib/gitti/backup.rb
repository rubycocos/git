# encoding: utf-8

require 'gitti'

# our own code
require 'gitti/backup/version'   # note: let version always go first


# say hello
puts Gitti::GitBackup.banner    if defined?($RUBYLIBS_DEBUG)

