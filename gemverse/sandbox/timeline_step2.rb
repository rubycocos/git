###
#  to run use
#     ruby -I ./lib sandbox/timeline_step2.rb

require 'gemverse'


cache = Gems::Cache.new( '../../gems/cache' )


owners = [
 ['geraldbauer',  'Gerald Bauer (Austria, near Vienna)'],
 ['gettalong',    'Thomas Leitner (Austria, Vienna)'],
 ['janlelis',     'Jan Lelis (Germany, Berlin)'],
 ['ankane',       'Andrew Kane (San Francisco, United States)'],
 ['zverok',       'Victor Shepelev (Ukraine, Kharkiv)'],
 ['q9',           'Afri Schoedon (Germany, Berlin)'],
]


summary = []

## step 2: build reports
owners.each do |owner, name|
  gems = read_csv( "../../gems/profiles/#{owner}/gems.csv" )

  ## step 2: read all versions (from cache)
  versions = cache.read_versions( gems: gems )

  pp versions[0,100]
  puts "   #{versions.size} record(s)"

  timeline = Gems::Timeline.new( versions )
  ## timeline.export( "../../gems/profiles/#{owner}/versions.csv" )


  timeline.save( "../../gems/profiles/#{owner}/README.md",
                 title: "#{name}'s Gem Timeline (By Month) - #{gems.size} Gems, #{versions.size} Updates" )

  summary << "[#{gems.size} Gems, #{versions.size} Updates - #{name}'s Gem Timeline (By Month)](profiles/#{owner})"
end


puts "summary:"
puts summary.join("\n")


puts "bye"


