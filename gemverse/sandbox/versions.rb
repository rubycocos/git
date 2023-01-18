###
#  to run use
#     ruby -I ./lib sandbox/versions.rb

require 'gemverse'


def write_csv( path, recs )
  buf = String.new
  buf << recs[0].join( ', ' )
  buf << "\n"
  recs[1..-1].each do |values|
    buf << values.join( ', ' )
    buf << "\n"
  end
  write_text( path, buf )
end





gems = read_csv( './sandbox/gems.csv' )

puts "  #{gems.size} record(s)"

delay_in_s = 0.5

gems.each_with_index do |gem,i|
  name = gem['name']
  puts "==>  #{i+1}/#{gems.size} #{name}..."

## update versions info

  puts "  sleeping #{delay_in_s} second(s)"
  sleep( delay_in_s )

  data = Gems.versions( name )
  puts "   #{data.size} version record(s) found"

  headers = ['name',
             'version',
             'created',
             'downloads']
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
  write_csv( "./gems/#{name}/versions.csv", [headers]+recs )
end


puts "bye"
