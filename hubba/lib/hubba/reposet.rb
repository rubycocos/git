module Hubba


## orgs  - include repos form org(anizations) too
## cache - save json response to cache_dir   - change to/use debug/tmp_dir? - why? why not?
def self.reposet( *users, orgs: true,
                          cache: false )
  # users = [users]   if users.is_a?( String )  ### wrap in array if single user

  gh = Github.new

  forks = []

  h = {}
  users.each do |user|
    res = gh.user_repos( user )
    save_json( "#{config.cache_dir}/users~#{user}~repos.json", res.data )  if cache

    repos = []
    ####
    #  check for forked repos (auto-exclude personal by default)
    #   note: forked repos in orgs get NOT auto-excluded!!!
    res.data.each do |repo|
      fork = repo['fork']
      if fork
        print "FORK "
        forks << "#{repo['full_name']} (AUTO-EXCLUDED)"
      else
        print "     "
        repos << repo['name']
      end
      print repo['full_name']
      print "\n"
    end


    h[ "#{user} (#{repos.size})" ] = repos.sort
  end


  ## all repos from orgs
  ##  note: for now only use first (primary user) - why? why not?
  if orgs
    user = users[0]
    res = gh.user_orgs( user )
    save_json( "#{config.cache_dir}/users~#{user}~orgs.json", res.data )  if cache


    logins = res.logins.each do |login|
       ## next if ['xxx'].include?( login )      ## add orgs here to skip

       res = gh.org_repos( login )
       save_json( "#{config.cache_dir}/orgs~#{login}~repos.json", res.data )  if cache

       repos = []
       res.data.each do |repo|
         fork = repo['fork']
         if fork
           print "FORK "
           forks << repo['full_name']
           repos << repo['name']
         else
           print "     "
           repos << repo['name']
         end
         print repo['full_name']
         print "\n"
       end

       h[ "#{login} (#{repos.size})" ] = repos.sort
    end
  end

  if forks.size > 0
    puts
    puts "#{forks.size} fork(s):"
    puts forks
  end

  h
end  ## method reposet

end # module Hubba
