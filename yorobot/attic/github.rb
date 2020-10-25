module Yorobot

class Github < Command     ## change to GithubStats or such - why? why not?

  ## todo/check: use --data-dir/--datadir  - why? why not?
  option :data_dir, "-d DIR", "--dir DIR",
                    "data dir (defaults to #{Hubba.config.data_dir})"

  ## todo/check: add switch  --[no]-traffic  - why? why not?


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

