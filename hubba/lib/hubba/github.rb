module Hubba

class Configuration
   attr_accessor :token

   attr_accessor :user
   attr_accessor :password

   def initialize
     # try default setup via ENV variables
     @token    = ENV[ 'HUBBA_TOKEN' ]

     @user     = ENV[ 'HUBBA_USER' ]    ## use HUBBA_LOGIN - why? why not?
     @password = ENV[ 'HUBBA_PASSWORD' ]
   end
end

## lets you use
##   Hubba.configure do |config|
##      config.token    = 'secret'
##      #-or-
##      config.user     = 'testdada'
##      config.password = 'secret'
##   end
##
##   move configure block to GitHub class - why? why not?
##   e.g. GitHub.configure do |config|
##          ...
##        end


def self.configuration
  @configuration ||= Configuration.new
end

def self.configure
  yield( configuration )
end


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

def initialize( cache_dir: './cache' )
   @cache  = Cache.new( cache_dir )

   @client = if Hubba.configuration.token
               Client.new( token: Hubba.configuration.token )
             elsif Hubba.configuration.user &&
                   Hubba.configuration.password
               Client.new( user:     Hubba.configuration.user,
                           password: Hubba.configuration.password )
             else
               Client.new
             end

   @offline = false
end

def offline!()  @offline = true; end   ## switch to offline  - todo: find a "better" way - why? why not?
def online!()   @offline = false; end
def offline?()  @offline == true; end
def online?()   @offline == false; end


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


private
def get( request_uri )
  if offline?
    @cache.get( request_uri )
  else
    @client.get( request_uri )
  end
end

end  # class Github

############
# add convenience alias for alternate spelling - why? why not?
GitHub = Github


end # module Hubba
