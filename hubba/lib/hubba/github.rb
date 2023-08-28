module Hubba


class Github
  BASE_URL = 'https://api.github.com'

  ###############
  ## (nested) classes for "wrapped" response (parsed json body)
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



def initialize( token: nil,
                user:  nil,
                password: nil )
   @token    = nil
   @user     = nil
   @password = nil

   if token                         ## 1a) give preference to passed in token
     @token     = token
   elsif user && password           ## 1b)  or passed in user/password credentials
     @user      = user
     @password  = password
   elsif Hubba.config.token         ## 2a) followed by configured (or env) token
     @token     = Hubba.config.token
   elsif Hubba.config.user && Hubba.config.password   ## 2b)
     @user      = Hubba.config.user
     @password  = Hubba.config.password
   else                             ## 3)
     ## no token or credentials passed in or configured
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

def repo_languages( full_name )
  Resource.new( get "/repos/#{full_name}/languages" )
end

def repo_topics( full_name )
  ## note: requires "api preview" accept headers (overwrites default v3+json)
  ##  e.g. application/vnd.github.mercy-preview+json
  Resource.new( get( "/repos/#{full_name}/topics", preview: 'mercy' ) )
end


def repo_commits( full_name )
  Resource.new( get "/repos/#{full_name}/commits" )
end


def repo_traffic_clones( full_name )
 # Get repository clones
 # Get the total number of clones and breakdown per day or week
 #   for the last 14 days.
 # Timestamps are aligned to UTC midnight of the beginning of the day or week.
 # Week begins on Monday.
 Resource.new( get "/repos/#{full_name}/traffic/clones" )
end

def repo_traffic_views( full_name )
 # Get page views
 # Get the total number of views and breakdown per day or week
 #  for the last 14 days.
 # Timestamps are aligned to UTC midnight of the beginning of the day or week.
 # Week begins on Monday.
 Resource.new( get "/repos/#{full_name}/traffic/views" )
end


def repo_traffic_popular_paths( full_name )
 # Get top referral paths
 # Get the top 10 popular contents over the last 14 days.
 Resource.new( get "/repos/#{full_name}/traffic/popular/paths" )
end

def repo_traffic_popular_referrers( full_name )
 # Get top referral sources
 # Get the top 10 referrers over the last 14 days.
 Resource.new( get "/repos/#{full_name}/traffic/popular/referrers" )
end




private
def get( request_uri, preview: nil )

  puts "GET #{request_uri}"

  ## note: request_uri ALWAYS starts with leading /, thus use + for now!!!
  #          e.g. /users/geraldb
  #               /users/geraldb/repos
  url = BASE_URL + request_uri


  headers = {}
  ## add default headers if nothing (custom) set / passed-in
  headers['User-Agent'] = "ruby/hubba v#{VERSION}"          ## required by GitHub API
  headers['Accept']     =  if preview   # e.g. mercy or ???
                             "application/vnd.github.#{preview}-preview+json"
                           else
                             'application/vnd.github.v3+json'  ## default - recommend by GitHub API
                           end

  auth = []
  ## check if credentials (user/password) present - if yes, use basic auth
  if @token
    puts "  using (personal access) token - starting with: #{@token[0..6]}**********"
    headers['Authorization'] = "token #{@token}"
    ## token works like:
    ##  curl -H 'Authorization: token my_access_token' https://api.github.com/user/repos
  elsif @user && @password
    puts "  using basic auth - user: #{@user}, password: ***"
    ## use credential auth "tuple" (that is, array with two string items) for now
    ##  or use Webclient::HttpBasicAuth or something - why? why not?
    auth = [@user, @password]
    # req.basic_auth( @user, @password )
  else
    puts "  using no credentials (no token, no user/password)"
  end

  res = Webclient.get( url,
                       headers: headers,
                       auth:    auth )

  # Get specific header
  # response["content-type"]
  # => "text/html; charset=UTF-8"

  # Iterate all response headers.
  # puts "HTTP HEADERS:"
  # res.headers.each do |key, value|
  #  puts "  #{key}: >#{value}<"
  # end
  # puts

  # => "location => http://www.google.com/"
  # => "content-type => text/html; charset=UTF-8"
  # ...

  if res.status.ok?
    res.json
  else
    puts "!! HTTP ERROR: #{res.status.code} #{res.status.message}:"
    pp res.raw

    ## todo/fix:
    ## improve HttpError - add status_code and status_message and so on - why? why not!!!
    raise HttpError, "#{res.status.code} #{res.status.message}"
  end
end  # method get

end  # class Github
end  # module Hubba
