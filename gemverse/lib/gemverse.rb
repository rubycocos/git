require 'cocos'


## move to cocos - upstream - why? why not?
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






require_relative 'gemverse/api'
require_relative 'gemverse/gems'
require_relative 'gemverse/cache'

require_relative 'gemverse/timeline'  ## timeline report



module Gems

###
##  "high-level" finders

def self.find_by( owner: )  ## todo/check: use

  rows = API.gems_by( owner )
  # pp data
  puts "  #{rows.size} record(s) founds"

  ## write "raw respone" to cache for debugging
  write_json( "./cache/gems_#{owner}.json", rows )



  recs = []
  rows.each do |row|
     recs <<  Gem.create( row )
  end

  ## sort by
  ##  1) (latest) version created and
  ##  2) name
   recs = recs.sort do |l,r|
     res =  r.version_created <=> l.version_created
     res =  l.name            <=> r.name       if res == 0
     res
   end

  GemDataset.new( recs )
end



def self.read_csv( path )
  ## note: requires Kernel::  otherwise stackoverflow endlessly calling read_csv
  rows = Kernel::read_csv( path )
  puts "  #{rows.size} record(s) founds"

  recs = []
  rows.each do |row|
     kwargs = {
      version: row['version'].empty? ? nil : row['version'],
      version_downloads: row['version_downloads'].empty? ? nil : row['version_downloads'].to_i,
      version_created:  row['version_created'].empty? ? nil : Date.strptime( row['version_created'], '%Y-%m-%d' ),
      homepage:  row['homepage'].empty? ? nil : row['homepage'],
      runtime:   row['dependencies'].empty? ? [] : row['dependencies'].split('|').map {|dep| dep.strip },
     }
     recs <<  Gem.new( name: row['name'], **kwargs )
  end

  ## sort by
  ##  1) (latest) version created and
  ##  2) name
   recs = recs.sort do |l,r|
     res =  r.version_created <=> l.version_created
     res =  l.name            <=> r.name     if res == 0
     res
   end

  GemDataset.new( recs )
end


end  # module Gems

