module Hubba


def self.update_stats( host_or_path='./repos.yml' )  ## move to reposet e.g. Reposet#update_status!!!!
  h = if hash_or_path.is_a?( String )    ## assume it is a file path!!!
        path = hash_or_path
        YAML.load_file( path )
      else
        hash_or_path  # assume its a hash / reposet already!!!
      end

  gh = Github.new
  gh.update_stats( h )
end


def self.stats( hash_or_path='./repos.yml' )   ## use read_stats or such - why? why not?
  h = if hash_or_path.is_a?( String )    ## assume it is a file path!!!
        path = hash_or_path
        YAML.load_file( path )
      else
        hash_or_path  # assume its a hash / reposet already!!!
      end

  Summary.new( h )  ## wrap in "easy-access" facade / wrapper
end



class Summary    # todo/check: use a different name e.g (Data)Base, Census, Catalog, Collection, Index, Register or such???

class Repo  ## (nested) class

  attr_reader :owner,
              :name

  def initialize( owner, name )
    @owner = owner   ## rename to login, username - why? why not?
    @name  = name    ## rename to reponame ??
  end

  def full_name() "#{owner}/#{name}"; end

  def stats
    ## note: load stats on demand only (first access) for now - why? why not?
    @stats ||= begin
                 stats = Stats.new( full_name )
                 stats.read
                 stats
               end
  end

  def diff
    @diff ||= stats.calc_diff_stars( samples: 3, days: 30 )
  end
end  # (nested) class Repo


attr_reader :orgs, :repos

def initialize( hash )
  @orgs     = []    # orgs and users -todo/check: use better name - logins or owners? why? why not?
  @repos    = []
  add( hash )

  puts "#{@repos.size} repos @ #{@orgs.size} orgs"
end

#############
## private helpes
def add( hash )   ## add repos.yml set
  hash.each do |org_with_counter, names|
    ## remove optional number from key e.g.
    ##   mrhydescripts (3)    =>  mrhydescripts
    ##   footballjs (4)       =>  footballjs
    ##   etc.
    org = org_with_counter.sub( /\([0-9]+\)/, '' ).strip
    repos = []
    names.each do |name|
      repo = Repo.new( org, name )
      repos << repo
    end
    @orgs << [org, repos]
    @repos += repos
  end
end
end  # class Summary



## orgs  - include repos form org(anizations) too
## cache - save json response to cache_dir   - change to/use debug/tmp_dir? - why? why not?
def self.reposet( *users, orgs: true,
                          cache: false )
  # users = [users]   if users.is_a?( String )  ### wrap in array if single user

  gh = Hubba::Github.new

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

