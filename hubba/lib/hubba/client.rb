module Hubba


class Client

BASE_URL = 'https://api.github.com'


def initialize( token: nil,
                user:  nil, password: nil )
  ## add support for (personal access) token
  @token     = token

  ## add support for basic auth - defaults to no auth (nil/nil)
  ##   remove - deprecated (use token) - why? why not?
  @user      = user    ## use login like Oktokit - why? why not?
  @password  = password
end # method initialize



def get( request_uri, headers: {} )

  extra_headers = headers    ## save "passed-in"

  headers = {}
  headers['User-Agent'] = 'ruby/hubba'                      ## required by GitHub API
  headers['Accept']     = 'application/vnd.github.v3+json'  ## recommend by GitHub API

  ## lets you overwrite headers
  ##   e.g. Accept for api previews and suchs
  headers = headers.merge( extra_headers )  if extra_headers && extra_headers.size > 0



  puts "GET #{request_uri}"

  ## note: request_uri ALWAYS starts with leading /, thus use + for now!!!
  #          e.g. /users/geraldb
  #               /users/geraldb/repos
  url = BASE_URL + request_uri


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
    exit 1
  end
end  # methdo get

end  ## class Client


end # module Hubba
