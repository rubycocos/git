###
#  to run use
#     ruby -I ./lib sandbox/timeline.rb

require 'gemverse'



cache = Gems::Cache.new( './gems' )

versions = cache.read_versions
# versions = cache.read_versions( gems: ['slideshow'] )


pp versions[0,100]
puts "   #{versions.size} record(s)"


timeline = Gems::Timeline.new( versions )

timeline.export( "./tmp/versions.csv" )

buf = timeline.build
puts buf

write_text( "./tmp/timeline.md", buf )
write_text( "./gems/README.md", buf )


puts "bye"

