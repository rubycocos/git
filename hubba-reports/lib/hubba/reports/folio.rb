module Hubba

class Folio    # todo/check: use a different name e.g (Port)Folio, Cache, Summary, (Data)Base, Census, Catalog, Collection, Index, Register or such???
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

def initialize( h )
  @orgs     = []    # orgs and users -todo/check: use better name - logins or owners? why? why not?
  @repos    = []
  add( h )

  puts "#{@repos.size} repos @ #{@orgs.size} orgs"
end

#############
## private helpes
def add( h )   ## add repos.yml set
  h.each do |org_with_counter, names|
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
end  # class Folio
end  # module Hubba
