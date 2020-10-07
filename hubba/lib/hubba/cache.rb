module Hubba

class Cache    ## lets you work with  GitHub api "offline" using just a local cache of stored json

  def initialize( dir )
    @dir = dir
  end

  ##  fix/todo:  cut of query string e.g. ?per_page=100  why? why not?
  def get( request_uri )
    ## check if request_uri exists in local cache
    basename = request_uri_to_basename( request_uri )
    path = "#{@dir}/#{basename}.json"
    if File.exist?( path )
      text = File.open( path, 'r:utf-8') { |f| f.read }
      json = JSON.parse( text )
      json
    else
      nil   ## todo/fix: raise exception - why? why not??
    end
  end

  def put( request_uri, obj )
    basename = request_uri_to_basename( request_uri )
    path = "#{@dir}/#{basename}.json"

    if obj.is_a?( Resource )  ## note: for convenience support Resource obj too
      data = obj.data
    else
      data = obj   # assume Hash or Array -- todo: add support for String - why? why not??
    end

    File.open( path, 'w:utf-8' ) do |f|
      f.write( JSON.pretty_generate( data ))
    end
  end


  def request_uri_to_basename( request_uri )
    ## 1) cut off leading /
    ## 2) convert / to ~
    ## 3) remove (optional) query string (for now) - why? why not?
    ##      e.g.  /users/#{name}/orgs?per_page=100  or such
    ##
    ## e.g.
    ##  '/users/geraldb'           => 'users~geraldb',
    ##  '/users/geraldb/repos'     => 'users~geraldb~repos',
    ##  '/users/geraldb/orgs'      => 'users~geraldb~orgs',
    ##  '/orgs/wikiscript/repos'   => 'orgs~wikiscript~repos',
    ##  '/orgs/planetjekyll/repos' => 'orgs~planetjekyll~repos',
    ##  '/orgs/vienna-rb/repos'    => 'orgs~vienna~rb.repos',

    basename = request_uri[1..-1]
    basename = basename.gsub( '/', '~')
    basename = basename.sub( /\?.*\z/, '' )    ## note: must escape ? (use \z for $)
    basename
  end

end  ## class Cache

end ## module Hubba
