###
#  to run use
#     ruby -I ./lib sandbox/timeline_step1.rb

require 'gemverse'


cache = Gems::Cache.new( '../../gems/cache' )


owners = [
 # 'janlelis',    ## 100 gems by Jan Lelis, Germany
 # 'ankane',
 # 'zverok',
 # 'q9',
]


at_owners = [
  # 'informatom',     ## 11 gems by Stefan Haslinger
  # 'noniq',          ## 8 gems by Stefan Daschek
  # 'pferdefleisch',  ## 10 gems by Aaron Cruz
  # 'ramonh',         ## 1 gem by Ramón Huidobro
   #  'gettalong',  ## 24 gems by Thomas Leitner, Austria
]



owners = at_owners

## step 1: get gems & versions data via rubygems api
owners.each do |owner|
  gems = Gems.find_by( owner: owner )
  puts "  #{gems.size} record(s)"

  gems.export( "../../gems/profiles/#{owner}/gems.csv" )

  cache.update_versions( gems: gems )
end


puts "bye"


