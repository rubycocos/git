require 'hubba'


######
# our own code
require 'hubba/reports/version'   # note: let version always go first
require 'hubba/reports/stats'
require 'hubba/reports/folio'

require 'hubba/reports/reports/base'
require 'hubba/reports/reports/catalog'
require 'hubba/reports/reports/size'
require 'hubba/reports/reports/stars'
require 'hubba/reports/reports/summary'
require 'hubba/reports/reports/timeline'
require 'hubba/reports/reports/topics'
require 'hubba/reports/reports/traffic_pages'
require 'hubba/reports/reports/traffic_referrers'
require 'hubba/reports/reports/traffic'
require 'hubba/reports/reports/trending'
require 'hubba/reports/reports/updates'




module Hubba
  def self.stats( hash_or_path='./repos.yml' )   ## use read_stats or such - why? why not?
    h = if hash_or_path.is_a?( String )    ## assume it is a file path!!!
          path = hash_or_path
          YAML.load_file( path )
        else
          hash_or_path  # assume its a hash / reposet already!!!
        end

    Folio.new( h )  ## wrap in "easy-access" facade / wrapper
  end  ## method stats
end # module Hubba


# say hello
puts HubbaReports.banner

