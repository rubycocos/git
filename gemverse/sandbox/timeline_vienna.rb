###
#  to run use
#     ruby -I ./lib sandbox/timeline_vienna.rb

require 'gemverse'


cache = Gems::Cache.new( '../../gems/cache' )


owners = [
 ['geraldbauer',    'Gerald Bauer (Austria, near Vienna)'],
 ['gettalong',      'Thomas Leitner (Austria, Vienna)'],
 ['informatom',     'Stefan Haslinger (Austria, Vienna)'],
 ['noniq',          'Stefan Daschek (Austria, Vienna)'],
 ['pferdefleisch',  'Aaron Cruz (Austria, near Vienna)'],
 ['ramonh',         'Ramón Huidobro (Austria, Vienna)'],
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
  # timeline.export( "../../viennarb.github.io/profiles/#{owner}/versions.csv" )


  timeline.save( "../../viennarb.github.io/profiles/#{owner}/README.md",
                 title: "#{name}'s Gem Timeline (By Month) - #{gems.size} Gems, #{versions.size} Updates" )

  summary << "- #{gems.size} Gems, #{versions.size} Updates - [#{name}'s Gem Timeline (By Month)](profiles/#{owner})"
end


puts "summary:"
puts summary.join("\n")


puts "bye"


