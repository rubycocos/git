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

stats.fetch( gh )
## change to - add ??
##    gh.update( stats )


pp stats

stats.write( data_dir: './tmp' )


