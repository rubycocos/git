# 3rd party (our own)
require 'webclient'

# our own code
require 'hubba/version'   # note: let version always go first
require 'hubba/cache'
require 'hubba/client'
require 'hubba/github'
require 'hubba/stats'


# say hello
puts Hubba.banner    if defined?($RUBYCOCO_DEBUG)
