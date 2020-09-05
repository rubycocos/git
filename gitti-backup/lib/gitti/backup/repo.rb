
module Gitti


class GitHubBareRepo    ## use/rename to GitHubServerRepo - why? why not?
  def initialize( owner, name )
    @owner = owner    ## use/rename to login or something - why? why not??
    @name  = name     #  e.g. "rubylibs/webservice"
  end


  def git_dir
     ## todo: rename to use bare_git_dir or mirror_dir  or something ??
     "#{@name}.git"
  end


  def backup_with_retries( dest_dir, retries: 2 )
    retries_count = 0
    success = false
    begin
      success = backup( dest_dir )
      retries_count += 1
    end until success || retries_count >= retries
    success   ## return if success or not  (true/false)
  end

  def backup( dest_dir )
    ###
    ##  use --mirror
    ##  use -n  (--no-checkout)   -- needed - why? why not?

    ###
    ### todo/fix:  use/add a new GitMirror.open( ) |mirror|
    ####                           mirror.update
    ###  GitMirror.update( path )
    ###

    Dir.chdir( dest_dir ) do
      if Dir.exist?( git_dir )
        Dir.chdir( git_dir ) do
          Git.remote_update
        end
      else
        Git.mirror( http_clone_url )
      end
    end
    true  ## return true  ## success/ok
  rescue GitError => ex
    puts "*** error: #{ex.message}"

    File.open( './errors.log', 'a' ) do |f|
      f.write "#{Time.now} -- repo #{@owner}/#{@name} - #{ex.message}\n"
    end
    false ## return false  ## error/nok
  end ## method backup

end   ## class Repo

end  ## module Gitti

