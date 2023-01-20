###
#  to run use
#     ruby -I ./lib sandbox/versions.rb

require 'gemverse'




cache = Gems::Cache.new( '../../gems/cache' )

gems = read_csv( '../../gems/profiles/gettalong/gems.csv' )
puts "  #{gems.size} record(s)"

versions = cache.read_versions( gems: gems )
puts "  #{versions.size} record(s)"



## cache.update_versions( gems: ['slideshow', 'markdown'] )
## cache.update_versions( gems: gems[0,3] )



# cache.update_versions( gems: gems )


puts "bye"
