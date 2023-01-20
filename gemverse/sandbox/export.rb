###
#  to run use
#     ruby -I ./lib sandbox/export.rb

require 'gemverse'


delay_in_s = 1.0

owners = [
          #  'geraldbauer'
         'gettalong',    ## 24 gems by Thomas Leitner, Austria
         # 'zverok',        ## 32 gems by Victor Shepelev, Ukraine
         # 'tenderlove',  ## 177 gems by Aaron Patterson, United States
         #  'webster132',  ## 79 gems by David Heinemeier Hansson (DHH)
         # 'zenspider',  ## 98 gems by Ryan Davis, United States
         'janlelis',  ## 100 gems by Jan Lelis, Germany
         ]
owners.each do |owner|
  sleep( delay_in_s )
  gems = Gems.find_by( owner: owner )
  puts "  #{gems.size} record(s)"

  gems.export( "../../gems/profiles/#{owner}/gems.csv" )
end


puts "bye"
