module Hubba


###
## note: keep update traffic separate from update (basic) stats
##         traffic stats require (personal access) token with push access!!

def self.update_traffic( hash_or_path='./repos.yml' )  ## move to reposet e.g. Reposet#update_status!!!!
  h = if hash_or_path.is_a?( String )    ## assume it is a file path!!!
        path = hash_or_path
        YAML.load_file( path )
      else
        hash_or_path  # assume its a hash / reposet already!!!
      end

    gh = Github.new

    h.each do |org_with_counter,names|

      ## remove optional number from key e.g.
      ##   mrhydescripts (3)    =>  mrhydescripts
      ##   footballjs (4)       =>  footballjs
      ##   etc.
      org = org_with_counter.sub( /\([0-9]+\)/, '' ).strip

      ## puts "  -- #{key_with_counter} [#{key}] --"

      names.each do |name|
        full_name = "#{org}/#{name}"

        ## puts "  fetching stats #{count+1}/#{repo_count} - >#{full_name}<..."
        stats = Stats.new( full_name )
        stats.read

        puts "update >#{full_name}< [1/4] - fetching repo traffic clones..."
        clones    = gh.repo_traffic_clones( full_name )
        puts "update >#{full_name}< [2/4] - fetching repo traffic views..."
        views     = gh.repo_traffic_views( full_name )
        puts "update >#{full_name}< [3/4] - fetching repo traffic popular paths..."
        paths     = gh.repo_traffic_popular_paths( full_name )
        puts "update >#{full_name}< [4/4] - fetching repo traffic popular referrers..."
        referrers = gh.repo_traffic_popular_referrers( full_name )

        stats.update_traffic( clones:    clones,
                              views:     views,
                              paths:     paths,
                              referrers: referrers )
        stats.write
      end
    end
end
end # module Hubba