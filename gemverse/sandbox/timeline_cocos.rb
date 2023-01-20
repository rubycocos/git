###
#  to run use
#     ruby -I ./lib sandbox/timeline_cocos.rb


require 'gemverse'



cache = Gems::Cache.new( '../../gems/cache' )


gems = read_csv( '../../gems/collections/cocos/gems.csv' )
puts "  #{gems.size} record(s)"


versions = cache.read_versions( gems: gems )

pp versions[0,100]
puts "   #{versions.size} record(s)"


timeline = Gems::Timeline.new( versions )

timeline.export( "../../gems/collections/cocos/versions.csv" )
timeline.save( "../../gems/collections/cocos/README.md" )


puts "bye"

