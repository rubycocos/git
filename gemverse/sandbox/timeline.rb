###
#  to run use
#     ruby -I ./lib sandbox/timeline.rb

require 'gemverse'



cache = Gems::Cache.new( '../../gems/cache' )

gems = read_csv( '../../gems/profiles/geraldbauer/gems.csv' )
puts "  #{gems.size} record(s)"


versions = cache.read_versions( gems: gems )
# versions = cache.read_versions( gems: ['slideshow'] )

pp versions[0,100]
puts "   #{versions.size} record(s)"


timeline = Gems::Timeline.new( versions )

timeline.export( "../../gems/profiles/geraldbauer/versions.csv" )

buf = timeline.build
puts buf

write_text( "./tmp/timeline.md", buf )
write_text( "../../gems/profiles/geraldbauer/README.md", buf )


puts "bye"

