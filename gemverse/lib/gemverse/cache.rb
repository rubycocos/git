

module Gems
class Cache
def initialize( basedir='./gems' )
  @basedir = basedir
end


def update_versions( gems: [] )

  delay_in_s = 0.5

  gems.each_with_index do |gem,i|

    name = if gem.is_a?( String )
                gem
           elsif gem.is_a?( Hash )
                gem['name']
           else  ## assume our own Gem struct/class for now
                gem.name
           end

    puts "==>  #{i+1}/#{gems.size} #{name}..."

    ## update versions info
    puts "  sleeping #{delay_in_s} second(s)"
    sleep( delay_in_s )

    data = Gems::API.versions( name )
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
    write_csv( "#{@basedir}/#{name}/versions.csv", [headers]+recs )
  end
end



def read_versions( gems: [] )
  ## read in and merge all version records
versions = []

 ## if no gems passed in - get all versions.csv datasets in basedir
 if gems.empty?
   paths = Dir.glob( "#{@basedir}/*/versions.csv" )
   gems = paths.map { |path| File.basename(File.dirname(path)) }
 end

  gems.each_with_index do |gem,i|

    name = if gem.is_a?( String )
                gem
           elsif gem.is_a?( Hash )
                gem['name']
           else  ## assume our own Gem struct/class for now
                gem.name
           end

    path = "#{@basedir}/#{name}/versions.csv"
    puts "==> #{i+1}/#{gems.size} reading #{name}..."
    recs = read_csv( path )
    recs.reverse.each_with_index do |rec,n|
        more = { 'count' => (n+1).to_s }   ## auto-add version count(er) e.g. 1,2,3,...
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

  versions
end



end   ## class Cache
end   ## module Gems
