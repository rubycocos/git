module Hubba

  def initialize( cache_dir: './cache' )
    @cache  = Cache.new( cache_dir )

    ## ...

    @offline = false
 end

 def offline!()  @offline = true; end   ## switch to offline  - todo: find a "better" way - why? why not?
 def online!()   @offline = false; end
 def offline?()  @offline == true; end
 def online?()   @offline == false; end


 def get( request_uri )
  if offline?
    @cache.get( request_uri )
  else
    @client.get( request_uri )
  end
end

end  # class Github

end # module Hubba
