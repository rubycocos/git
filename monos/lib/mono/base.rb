
module Mono

  def self.root   ## root of single (monorepo) source tree
    @@root ||= begin
        ## todo/fix:
        ##  check if windows - otherwise use /sites
        ##  check if root directory exists?
        if ENV['MOPATH']
          ## use expand path to make (assure) absolute path - why? why not?
          ::File.expand_path( ENV['MOPATH'] )
        elsif ::Dir.exist?( 'C:/Sites' )
          'C:/Sites'
        else
          '/sites'
        end
    end
  end

  def self.root=( path )
    ## use expand path to make (assure) absolute path - why? why not?
    @@root = ::File.expand_path( path )
  end




  def self.monofile
    path =  if ::File.exist?( './monorepo.yml' )
               './monorepo.yml'
            elsif ::File.exist?( './monotree.yml' )
               './monotree.yml'
            elsif ::File.exist?( './repos.yml' )
               './repos.yml'
            else
               puts "!! WARN: no mono configuration file (that is, {monorepo,monotree,repos}.yml) found in >#{Dir.getwd}<"
               nil
            end

    if path
      GitRepoSet.read( path )
    else
      GitRepoSet.new( {} )  ## return empty set -todo/check: return nil - why? why not?
    end
  end
end  ## module Mono




#####################
#  add file and repo helper

##
## todo/fix:  ALWAYS assert name format
##   (rename to mononame and monopath) - why? why not?

class MonoGitHub
  def self.clone( name )
    path = MonoFile.expand_path( name )

    org_path = File.dirname( path )
    FileUtils.mkdir_p( org_path ) unless Dir.exist?( org_path )   ## make sure path exists

    ### note: use a github clone url (using ssh) like:
    ##     git@github.com:rubycoco/gitti.git
    ssh_clone_url = "git@github.com:#{name}.git"

    Dir.chdir( org_path ) do
      Gitti::Git.clone( ssh_clone_url )
    end
  end
end
MonoGithub = MonoGitHub  ## add convenience (typo?) alias



class MonoGitProject
  def self.open( name, &block )
    path = MonoFile.expand_path( name )
    Gitti::GitProject.open( path, &block )
  end
end


module Mono
  ## add some short cuts
  def self.open( name, &block ) MonoGitProject.open( name, &block ); end
  def self.clone( name )        MonoGitHub.clone( name ); end
end



class MonoFile
    ## e.g. openfootball/austria etc.
    ##      expand to to "real" absolute path
    ##
    ## todo/check: assert name must be  {orgname,username}/reponame
    def self.expand_path( path )
      "#{Mono.root}/#{path}"
    end
    def self.exist?( path )
      ::File.exist?( expand_path( path ))
    end


    ## add some aliases - why? why not?
    class << self
      alias_method :real_path, :expand_path
      alias_method :exists?,   :exist?   ## add deprecated exists? too - why? why not?
    end



    ## path always relative to Mono.root
    ##   todo/fix:  use File.expand_path( path, Mono.root ) - why? why not?
    ##    or always enfore "absolut" path e.g. do NOT allow ../ or ./ or such
    def self.open( path, mode='r:utf-8', &block )
       full_path = "#{Mono.root}/#{path}"
       ## make sure path exists if we open for writing/appending - why? why not?
       if mode[0] == 'w' || mode[0] == 'a'
        ::FileUtils.mkdir_p( ::File.dirname( full_path ) )  ## make sure path exists
       end

       ::File.open( full_path, mode ) do |file|
         block.call( file )
       end
    end

    def self.read_utf8( path )
       open( path, 'r:utf-8') { |file| file.read }
    end
end  ## class MonoFile




