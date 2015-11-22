# encoding: utf-8

require 'gitti'

# our own code
require 'gitti/sync/version'   # note: let version always go first
require 'gitti/sync/repo'
require 'gitti/sync/sync'


# say hello
puts GittiSync.banner    if defined?($RUBYLIBS_DEBUG)
