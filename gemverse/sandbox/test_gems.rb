###
#  to run use
#     ruby -I ./lib sandbox/test_gems.rb

require 'gemverse'


=begin
data =  Gems.gems_by( 'geraldbauer' )

pp data
puts "  #{data.size} record(s)"
=end

# name = 'ethlite'
name = 'slideshow'
data = Gems.versions( name )
pp data

recs = []
data.each do |h|

  ## only use year/month/day for now now hours etc.
  created = Date.strptime( h['created_at'], '%Y-%m-%d' )

   rec = [
     name,
     h['number'],
     created.strftime( '%Y-%m-%d' ),
     h['downloads_count'].to_s,
   ]
   recs << rec
end

pp recs

puts "bye"
