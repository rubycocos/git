# 3rd party (our own)
require 'webclient'


###############
## helpers

def save_json( path, data )    ## data - hash or array
  File.open( path, 'w:utf-8' ) do |f|
    f.write( JSON.pretty_generate( data ))
  end
end

def save_yaml( path, data )
  File.open( path, 'w:utf-8' ) do |f|
    f.write( data.to_yaml )
  end
end



# our own code
require 'hubba/version'   # note: let version always go first

module Hubba
  class HttpError < StandardError
  end
end

require 'hubba/config'
require 'hubba/github'
require 'hubba/reposet'

### update stats (github data) machinery
require 'hubba/stats'
require 'hubba/update'
require 'hubba/update_traffic'




############
# add convenience alias for alternate spelling - why? why not?
module Hubba
  GitHub = Github
end


# say hello
puts Hubba.banner


