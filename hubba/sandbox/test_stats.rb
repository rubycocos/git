$LOAD_PATH.unshift( "./lib" )
require 'hubba'

#####################
## note:
##  set HUBBA_TOKEN on environment first!!!!
####################

gh = Hubba::Github.new


stats = Hubba::Stats.new( 'openfootball/deutschland' )
pp stats
puts

gh.update( stats )


pp stats

Hubba.config.data_dir = './tmp'
stats.write


