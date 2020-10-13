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
require 'hubba/config'
require 'hubba/github'
require 'hubba/stats'

## "higher level" porcelain services / helpers for easy (re)use
require 'hubba/folio'     ## "access layer" for reports
require 'hubba/hubba'
require 'hubba/update'
require 'hubba/update_traffic'

require 'hubba/reports/base'
require 'hubba/reports/catalog'
require 'hubba/reports/size'
require 'hubba/reports/stars'
require 'hubba/reports/summary'
require 'hubba/reports/timeline'
require 'hubba/reports/topics'
require 'hubba/reports/traffic_pages'
require 'hubba/reports/traffic_referrers'
require 'hubba/reports/traffic'
require 'hubba/reports/trending'
require 'hubba/reports/updates'



############
# add convenience alias for alternate spelling - why? why not?
module Hubba
  GitHub = Github
end


# say hello
puts Hubba.banner    if defined?($RUBYCOCO_DEBUG)
