# encoding: utf-8


module Gitti

class GitError < StandardError 
end

class GitLib

   def clone( repo, opts={} )
     command( "clone #{repo}" )
   end

   def mirror( repo, opts={} )
     command( "clone --mirror #{repo}" )
   end

   def pull( opts={} )
     command( "pull" )
   end

   def remote_update( opts={} )
     command( "remote update" )
   end


   ## todo/fix:
   ##   add last_exit  or something ?? why? why not??

   def command( cmd )
      ## note: for now use Kernel#system for calling external git command
      ##

      cmdline = "git #{cmd}"
      puts "  trying >#{cmdline}< in (#{Dir.pwd})..."
      
      result = nil
      result = system( cmdline )

      pp result

      # note: Kernel#system returns
      #  - true if the command gives zero exit status
      #  - false for non zero exit status
      #  - nil if command execution fails
      #  An error status is available in $?.

      if result.nil?
        puts "*** error was #{$?}"
        fail "[Kernel.system] command execution failed  >#{cmdline}< - #{$?}"   
      elsif result   ## true => zero exit code (OK)
        puts 'OK'  ## zero exit; assume OK
        true   ## assume ok
      else  ## false => non-zero exit code (ERR/NOK)
        puts "*** error: non-zero exit - #{$?} !!"   ## non-zero exit (e.g. 1,2,3,etc.); assume error
      
        ## log error for now  ???
        # File.open( './errors.log', 'a' ) do |f|
        #  f.write "#{Time.now} -- repo #{@owner}/#{@name} - command execution failed - non-zero exit\n"
        # end
        raise GitError.new( "command execution failed >#{cmdline}< - non-zero exit (#{$?})" )
      end
   end  # method command
end  # class Lib


module Git
  ## todo/fix: use "shared" singelton lib - why? why not??
  def self.clone( repo, opts={} )    GitLib.new.clone( repo, opts );  end
  def self.mirror( repo, opts={} )   GitLib.new.mirror( repo, opts );  end
  
  def self.pull( opts={} )           GitLib.new.pull( opts );  end
  def self.remote_update( opts={} )  GitLib.new.remote_update( opts );  end
end  # module Git

end # module Gitti


### convenience top level Git module - check if defined? make optional? why? why not??
## Git = Gitti::Git

#  for now use include Gitti - why? why not??
