module Hubba

class Report
  def initialize( stats_or_hash_or_path=Hubba.stats )
    ## puts "[debug] Report#initialize:"
    ## pp  stats_or_hash_or_path   if stats_or_hash_or_path.is_a?( String )

    @stats = if stats_or_hash_or_path.is_a?( String ) ||
                stats_or_hash_or_path.is_a?( Hash )
                  hash_or_path = stats_or_hash_or_path
                  Hubba.stats( hash_or_path )
             else
                  stats_or_hash_or_path  ## assume Summary/Stats - todo/fix: double check!!!
             end
  end

  def save( path )
    buf = build
    puts "writing report >#{path}< ..."
    File.open( path, "w:utf-8" ) do |f|
      f.write( buf )
    end
  end
end  ## class Report

end # module Hubba