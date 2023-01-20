###
#  to run use
#     ruby -I ./lib sandbox/timeline_samples.rb

require 'gemverse'


cache = Gems::Cache.new( '../../gems/cache' )


owners = [
 #  'gettalong',  ## 24 gems by Thomas Leitner, Austria
 # 'janlelis',    ## 100 gems by Jan Lelis, Germany
 # 'ankane',
 # 'zverok',
 'q9',
]

## step 1: get gems & versions data via rubygems api
owners.each do |owner|
  gems = Gems.find_by( owner: owner )
  puts "  #{gems.size} record(s)"

  gems.export( "../../gems/profiles/#{owner}/gems.csv" )

  cache.update_versions( gems: gems )
end


## step 2: build reports
owners.each do |owner|
  gems = read_csv( "../../gems/profiles/#{owner}/gems.csv" )

  ## step 2: read all versions (from cache)
  versions = cache.read_versions( gems: gems )

  pp versions[0,100]
  puts "   #{versions.size} record(s)"

  timeline = Gems::Timeline.new( versions )
  timeline.export( "../../gems/profiles/#{owner}/versions.csv" )
  timeline.save( "../../gems/profiles/#{owner}/README.md" )
end



puts "bye"


