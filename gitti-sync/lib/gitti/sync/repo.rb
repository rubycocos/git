# encoding: utf-8

module Gitti

class GitHubRepo
  def initialize( owner, name )
    @owner = owner    ## use/rename to login or something - why? why not??
    @name  = name     #  e.g. "rubylibs/webservice"
  end

  def ssh_clone_url
     ##  check: use https: as default? for github - http:// still supported? or redirected?
     ## "http://github.com/#{@owner}/#{@name}"
     "git@github.com:#{@owner}/#{@name}.git"
  end

  def work_dir     ## use (rename to) workspace_dir or worktree_dir  - why? why not??
     "#{@name}"
  end



  def sync( dest_dir )   ## change dest_dir to dest_root or base_dir or something? - why? why not?
    ## clone or if exists pull (in changes)

    Dir.chdir( dest_dir ) do
      if Dir.exist?( work_dir )
        Dir.chdir( work_dir ) do
          Git.pull
        end
      else
        Git.clone( ssh_clone_url  )
      end
    end
    true  ## return true  ## success/ok
  rescue GitError => ex
    puts "*** error: #{ex.message}"
    
    File.open( './errors.log', 'a' ) do |f|
      f.write "#{Time.now} -- repo #{@owner}/#{@name} - #{ex.message}\n"
    end
    false ## return false  ## error/nok
  end  ## method sync

end   ## class GitHubRepo

end # module Gitti
