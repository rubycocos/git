###
#  to run use
#     ruby -I ./lib sandbox/export.rb

require 'gemverse'


data =  Gems.gems_by( 'geraldbauer' )

pp data
puts "  #{data.size} record(s)"




headers = ['name',
           'version',
           'version_created',
           'version_downloads',
           'homepage',
           'dependencies',
          ]
recs = []


## export to gems.csv
##
data.each do |h|

  if h['yanked']
    puts "!! ERROR - includes yanked gem"
    pp h
    exit 1
  end

  deps =  h['dependencies']['runtime'].map { |dep| dep['name'] }

  ## only use year/month/day for now now hours etc.
  created = Date.strptime( h['version_created_at'], '%Y-%m-%d' )

  rec = [
      h['name'],
      h['version'],
      created.strftime( '%Y-%m-%d' ),
      h['version_downloads'].to_s,
      h['homepage_uri'],
      deps.join( ' | ' ),
  ]
  recs << rec
end

## sort by version created and name

recs = recs.sort do |l,r|
                       res =  r[2] <=> l[2]
                       res =  l[0] <=> r[0]  if res == 0
                       res
                 end


pp recs

buf = String.new
buf << headers.join( ', ' )
buf << "\n"
recs.each do |values|
  buf << values.join( ', ' )
  buf << "\n"
end

write_text( "./sandbox/gems.csv", buf )

puts "bye"
