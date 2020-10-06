# encoding: utf-8

module Hubba


class Client

def initialize( token: nil,
                user:  nil, password: nil )
  uri = URI.parse( "https://api.github.com" )
  @http = Net::HTTP.new( uri.host, uri.port )
  @http.use_ssl     = true
  @http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  ## add support for (personal access) token
  @token     = token

  ## add support for basic auth - defaults to no auth (nil/nil)
  ##   remove - deprecated (use token) - why? why not?
  @user      = user    ## use login like Oktokit - why? why not?
  @password  = password
end # method initialize



def get( request_uri )
  puts "GET #{request_uri}"

  req = Net::HTTP::Get.new( request_uri )
  ## req = Net::HTTP::Get.new( "/users/geraldb" )
  ## req = Net::HTTP::Get.new( "/users/geraldb/repos" )
  req["User-Agent"] = "ruby/hubba"                      ## required by GitHub API
  req["Accept" ]    = "application/vnd.github.v3+json"  ## recommend by GitHub API

  ## check if credentials (user/password) present - if yes, use basic auth
  if @token
    puts "  using (personal access) token - starting with: #{@token[0..6]}**********"
    req["Authorization"] = "token #{@token}"
    ## token works like:
    ##  curl -H 'Authorization: token my_access_token' https://api.github.com/user/repos
  elsif @user && @password
    puts "  using basic auth - user: #{@user}, password: ***"
    req.basic_auth( @user, @password )
  else
    puts "  using no credentials (no token, no user/password)"
  end


  res = @http.request( req )

  # Get specific header
  # response["content-type"]
  # => "text/html; charset=UTF-8"

  # Iterate all response headers.
  res.each_header do |key, value|
    p "#{key} => #{value}"
  end
  # => "location => http://www.google.com/"
  # => "content-type => text/html; charset=UTF-8"
  # ...

  json = JSON.parse( res.body )
  ## pp json
  json
end  # methdo get

end  ## class Client


end # module Hubba
