module Gitti

class GitMirror
  def self.open( path, &blk )
    new( path ).open( &blk )
  end

  def self.update( path )    ### all-in-one convenience shortcut
    new( path).open { |mirror| mirror.update }
  end



  def initialize( path )
    raise ArgumentError, "dir >#{path}< not found; dir MUST already exist for GitMirror class - sorry"   unless Dir.exist?( path )
    ## todo/check:  check for more dirs and files e.g.
    ##  /info,/objects,/refs, /hooks, HEAD, config, description -- why? why not?
    raise ArgumentError, "dir >#{path}/objects< not found; dir MUST already be initialized with git for GitMirror class - sorry"  unless Dir.exist?( "#{path}/objects" )
    @path = path
  end


  def open( &blk )
    Dir.chdir( @path ) do
      blk.call( self )
    end
  end

  def update()           Git.update; end

end # class GitMirror
end # module Gitti

