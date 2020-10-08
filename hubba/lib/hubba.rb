# 3rd party (our own)
require 'webclient'

# our own code
require 'hubba/version'   # note: let version always go first
require 'hubba/config'
require 'hubba/client'
require 'hubba/github'
require 'hubba/stats'


############
# add convenience alias for alternate spelling - why? why not?
module Hubba
  GitHub = Github
end


# say hello
puts Hubba.banner    if defined?($RUBYCOCO_DEBUG)
