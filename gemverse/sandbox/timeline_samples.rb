###
#  to run use
#     ruby -I ./lib sandbox/timeline_samples.rb

require 'gemverse'


cache = Gems::Cache.new( './gems' )


owners = [
  'gettalong',  ## 24 gems by Thomas Leitner, Austria
  'janlelis',    ## 100 gems by Jan Lelis, Germany
]

=begin
## step 1: get gems & versions data via rubygems api
owners.each do |owner|
  gems = Gems.find_by( owner: owner )
  puts "  #{gems.size} record(s)"

  gems.export( "./sandbox/gems_#{owner}.csv" )

  cache.update_versions( gems: gems )
end
=end


## step 2: build reports
owners.each do |owner|
  gems = read_csv( "./sandbox/gems_#{owner}.csv" )

  ## step 2: read all versions (from cache)
  versions = cache.read_versions( gems: gems )

  pp versions[0,100]
  puts "   #{versions.size} record(s)"

  timeline = Gems::Timeline.new( versions )
  timeline.export( "./samples/gems_#{owner}/versions.csv" )
  timeline.save( "./samples/gems_#{owner}/README.md" )
end



puts "bye"


