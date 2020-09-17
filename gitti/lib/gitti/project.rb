module Gitti

class GitProject
  def self.open( path, &blk )
    new( path ).open( &blk )
  end

  def initialize( path )
    raise ArgumentError, "dir >#{path}< not found; dir MUST already exist for GitProject class - sorry"   unless Dir.exist?( path )
    raise ArgumentError, "dir >#{path}/.git< not found; dir MUST already be initialized with git for GitProject class - sorry"  unless Dir.exist?( "#{path}/.git" )
    @path = path
  end


  def open( &blk )
    ## puts "Dir.getwd: #{Dir.getwd}"
    Dir.chdir( @path ) do
      blk.call( self )
    end
    ## puts "Dir.getwd: #{Dir.getwd}"
  end


  def status( short: false )    Git.status( short: short ); end
  def changes()                 Git.changes; end
  def clean?()                  Git.clean?; end
  def changes?()                Git.changes?; end
  alias_method :dirty?, :changes?


  def fetch()                   Git.fetch; end
  def pull()                    Git.pull; end
  def fast_forward()            Git.fast_forward; end
  alias_method :ff, :fast_forward

  def push()                    Git.push; end

  def add( *pathspecs )         Git.add( *pathspecs ); end
  def add_all()                 Git.add_all; end
  def commit( message )         Git.commit( message ); end

  def files()                   Git.files; end


  ### remote show origin|upstream|etc.
  def remote()                  Git.remote; end
  def origin()                  Git.origin; end
  def upstream()                Git.upstream; end
  def origin?()                 Git.origin?; end
  def upstream?()               Git.upstream?; end

  ### branch management
  def branch()                  Git.branch; end
  def master?()                 Git.master?; end
  def main?()                   Git.main?; end


  def run( cmd )                Git::Shell.run( cmd ); end
end # class GitProject
end # module Gitti

