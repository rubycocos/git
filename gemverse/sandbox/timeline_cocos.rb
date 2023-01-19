###
#  to run use
#     ruby -I ./lib sandbox/timeline_cocos.rb


require 'gemverse'



cache = Gems::Cache.new( './gems' )


gems = read_csv( './sandbox/gems_cocos.csv' )
puts "  #{gems.size} record(s)"


versions = cache.read_versions( gems: gems )

pp versions[0,100]
puts "   #{versions.size} record(s)"


timeline = Gems::Timeline.new( versions )

timeline.export( "./samples/gems_cocos/versions.csv" )
timeline.save( "./samples/gems_cocos/README.md" )


puts "bye"

