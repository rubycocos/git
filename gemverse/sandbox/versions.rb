###
#  to run use
#     ruby -I ./lib sandbox/versions.rb

require 'gemverse'



gems = read_csv( './sandbox/gems.csv' )

puts "  #{gems.size} record(s)"


cache = Gems::Cache.new( './gems' )


## cache.update_versions( gems: ['slideshow', 'markdown'] )
cache.update_versions( gems: gems[0,3] )



puts "bye"
