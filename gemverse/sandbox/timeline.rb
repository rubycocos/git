###
#  to run use
#     ruby -I ./lib sandbox/timeline.rb

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



## read in and merge all version records

headers = ['name',
           'version',
           'created',
           'downloads']
versions = []


paths = Dir.glob( "./gems/*/versions.csv" )
paths.each_with_index do |path,i|
  basename = File.basename( File.dirname( path ))
  puts "==> #{i+1}/#{paths.size} reading #{basename}..."
  recs = read_csv( path )
  recs[1..-1].reverse.each_with_index do |rec,i|
      more = { 'count' => (i+1).to_s }   ## auto-add version count(er) e.g. 1,2,3,...
      versions <<  rec.merge( more )
  end
  puts "   #{recs.size} record(s)"
end



## sort by version created and name
versions = versions.sort do |l,r|
  res =  r['created'] <=> l['created']
  res =  l['name']    <=> r['name']     if res == 0
  res =  r['version'] <=> l['version']  if res == 0
  res
end


pp versions[0,100]
puts "   #{versions.size} record(s)"



headers = ['week',
           'name',
           'version',
           'count',
           'created',
           'downloads']
recs = []
versions.each_with_index do |h,i|

  date = Date.strptime( h['created'], '%Y-%m-%d' )

  rec = [
    date.strftime('%Y/%V'),
    h['name'],
    h['version'],
    h['count'],
    date.strftime( '%Y-%m-%d' ),  # add (%a) for (Sun), (Mon) or such - why? why not?
    h['downloads'],
  ]
  recs << rec
end




pp recs[0,100]


write_csv( "./gems/versions.csv", [headers]+recs )



## generate timeline page by week

recs = read_csv( "./gems/versions.csv" )
puts "  #{recs.size} record(s)"



def build_gem( gem )
  date =  Date.strptime( gem['created'], '%Y-%m-%d' )

  buf = String.new
  buf << "[**"
  buf << gem['name']
  buf << "**]"
  buf << "("
  buf << "https://rubygems.org/gems/#{gem['name']}/versions/#{gem['version']}"
  buf << " "
  buf << %Q{"#{date.strftime('%a %d %b %Y')}"}
  buf << ") "
  buf << gem['version']
  buf
end


def build_gems_new( gems )
  buf = String.new
  if gems.size > 0
    buf << "**NEW!** - #{gems.size} Gem(s) - "
    buf <<  gems.map do |gem| build_gem( gem )
                     end.join( ', ' )
    buf << "\n\n"
  end
  buf
end

def build_gems_update( gems )
  buf = String.new
  if gems.size > 0
    buf << "#{gems.size} Gem Update(s)  - "
    buf <<  gems.map do |gem| build_gem( gem )
                     end.join( ', ' )
   buf << "\n\n"
  end
  buf
end



buf = String.new
buf << "# Timeline \n\n"


gems_update = []
gems_new    = []

last_year = nil
last_week = nil

recs.each do |rec|

  week = rec['week']
  date =  Date.strptime( rec['created'], '%Y-%m-%d' )
  year =  date.year



  if last_week != week
    buf << build_gems_new( gems_new )
    buf << build_gems_update( gems_update )

    gems_update = []
    gems_new    = []
  end


  if last_year != year
    last_year = year
    buf << "## #{year}\n\n"
  end

  if last_week != week
    last_week = week
    buf << "**Week #{week}**\n\n"
  end

  if rec['count'].to_i == 1
     gems_new     << rec
  else
     gems_update  << rec
  end
end

buf << build_gems_new( gems_new )
buf << build_gems_update( gems_update )



write_text( "./gems/README.md", buf )


puts "bye"

