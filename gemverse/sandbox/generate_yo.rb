###
#  to run use
#     ruby -I ./lib sandbox/generate_yo.rb

require 'gemverse'



cache = Gems::Cache.new( '../../gems/cache' )

gems = read_csv( '../../gems/profiles/geraldbauer/gems.csv' )
puts "  #{gems.size} record(s)"


versions = cache.read_versions( gems: gems )
# versions = cache.read_versions( gems: ['slideshow'] )

pp versions[0,100]
puts "   #{versions.size} record(s)"




timeline = Gems::Timeline.new( versions )

# timeline.export( "../../gems/profiles/geraldbauer/versions.csv" )

buf = timeline.build_by_week( title: "Gerald Bauer's Gem Timeline (By Week) - #{gems.size} Gems, #{versions.size} Updates"
)
puts buf


write_text( "./tmp/timeline.md", buf )
write_text( "../../geraldb.github.io/gems/README.md", buf )


puts "bye"

