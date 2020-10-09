module Hubba


class Resource
  attr_reader :data
  def initialize( data )
    @data = data
  end
end

class Repos < Resource
  def names
    ## sort by name
    data.map { |item| item['name'] }.sort
  end
end

class Orgs < Resource
  def logins
    ## sort by name
    data.map { |item| item['login'] }.sort
  end
  alias_method :names, :logins   ## add name alias - why? why not?
end



class Github

def initialize
   @client = if Hubba.configuration.token
               Client.new( token: Hubba.configuration.token )
             elsif Hubba.configuration.user &&
                   Hubba.configuration.password
               Client.new( user:     Hubba.configuration.user,
                           password: Hubba.configuration.password )
             else
               Client.new
             end
end


def user( name )
  Resource.new( get "/users/#{name}" )
end


def user_repos( name )
  Repos.new( get "/users/#{name}/repos" )   ## add ?per_page=100 - why? why not?
end


##
# note: pagination
#  requests that return multiple items will be paginated to 30 items by default.
#   You can specify further pages with the ?page parameter.
# For some resources, you can also set a custom page size up to 100
#  with the ?per_page=100 parameter

def user_orgs( name )
  Orgs.new( get "/users/#{name}/orgs?per_page=100" )
end



def org( name )
  Resource.new( get "/orgs/#{name}" )
end

def org_repos( name )
  Repos.new( get "/orgs/#{name}/repos?per_page=100" )
end



def repo( full_name )   ## full_name (handle) e.g. henrythemes/jekyll-starter-theme
  Resource.new( get "/repos/#{full_name}" )
end

def repo_commits( full_name )
  Resource.new( get "/repos/#{full_name}/commits" )
end



####
# more
def update( obj )
  if obj.is_a?( Stats )
    stats = obj
    full_name = stats.full_name
    puts "[update 1/2] fetching repo >#{full_name}<..."
    repo    = repo( full_name )
    puts "[update 2/2] fetching repo >#{full_name}< commits ..."
    commits = repo_commits( full_name )

    stats.update( repo, commits )
  else
    raise ArgumentError, "unknown source object passed in - expected Hubba::Stats; got #{obj.class.name}"
  end
end


def update_stats( h )    ## todo/fix: change to Reposet - why? why not???
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

        update( stats )   ## fetch & update stats

        stats.write
      end
    end
end


private
def get( request_uri )
  @client.get( request_uri )
end

end  # class Github
end  # module Hubba
