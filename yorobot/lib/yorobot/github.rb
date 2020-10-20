module Yorobot



class Github < Step     ## change to GithubStats or such - why? why not?


  def on_parse_options( parser )
    ## todo/check: use --data-dir/--datadir  - why? why not?
    parser.on( "-d DIR",
               "--dir DIR",
               "data dir (defaults to #{Hubba.config.data_dir}",
             ) do |data_dir|
                  options[:data_dir] = data_dir
               end

    ## add switch  --[no]-traffic  - why? why not?
  end


  def call( username )
    ## username e.g. geraldb

    if options[:data_dir]  ## e.g. "./cache.github"
      puts "  setting data_dir to >#{options[:data_dir]}<"
      Hubba.config.data_dir = options[:data_dir]
    end

    h = Hubba.reposet( username )   ## note: do NOT include yorobot for now
    pp h

    Hubba.update_stats( h )
    Hubba.update_traffic( h )
    puts "Done."
  end

end # class Github

end # module Yorobot

