module Hubba

def self.update_stats( hash_or_path='./repos.yml' )  ## move to reposet e.g. Reposet#update_status!!!!
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

        puts "update >#{full_name}< [1/4] - fetching repo..."
        repo      = gh.repo( full_name )
        puts "update >#{full_name}< [2/4] - fetching repo commits ..."
        commits   = gh.repo_commits( full_name )
        puts "update >#{full_name}< [3/4] - fetching repo topics ..."
        topics    = gh.repo_topics( full_name )
        puts "update >#{full_name}< [4/4] - fetching repo languages ..."
        languages = gh.repo_languages( full_name )

        stats.update( repo,
                       commits:   commits,
                       topics:    topics,
                       languages: languages )
        stats.write
      end
    end
end
end # module Hubba