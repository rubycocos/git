require 'flow-lite'


####
#  add more 3rd party gems / libs to flow "prologue / prelude"
#
# require 'computer'    # add shell run/call etc. machinery
#   add via gitti   (git command-line support)
#
#   note - make  hubba  (github json api support) optional for now
require 'gitti'
require 'mono'



# our own code
require_relative 'yorobot/version'   # note: let version always go first


#############################
#### add predefined steps
####        - adduser


module Flow
class Base

=begin
#
#  note - change id_rsa to id_ed25519 !!!

# check ssh
    if [ ! -d ~/.ssh ]; then mkdir ~/.ssh; fi
    echo "$SSH_KEY" > ~/.ssh/id_ed25519
    chmod 600 ~/.ssh/id_ed25519
    echo "ssh directory - ~/.ssh:"
    ls -la ~/.ssh
    ssh -vT git@github.com

# check git
     git --version
     git config --global user.name  "Yo Robot"
     git config --global user.email "gerald.bauer+yorobot@gmail.com"
     git config -l --show-origin
=end


  def step_adduser
    ##############
    ## setup ssh

    ssh_key  = ENV['SSH_KEY']

    if ssh_key.nil?
      STDERR.puts "!! ERROR - required SSH_KEY env(ironment) variable missing"
      exit 1
    end

    ssh_path = File.expand_path( '~/.ssh' )

    if File.exist?( "#{ssh_path}/id_ed25519" )
      STDERR.puts "!! ERROR - ssh key >#{ssh_path}/id_ed25519< already exists"
      exit 1
    end

    ## make sure path exists
    FileUtils.mkdir_p( ssh_path )   unless Dir.exist?( ssh_path )
    puts "--> writing ssh key to >#{ssh_path}/id_ed25519<..."
    File.open( "#{ssh_path}/id_ed25519", 'w:utf-8' ) do |f|
      f.write( ssh_key )
    end
    ## note: ssh key must be "private" only access by owner (otherwise) WILL NOT work
    ## res = File.chmod( 0600, "#{ssh_path}/id_rsa" )
    ## puts res  ## returns number of files processed; should be 1 - assert - why? why not?
    Computer::Shell.run( %Q{chmod 600 #{ssh_path}/id_ed25519} )

    Computer::Shell.run( %Q{ls -la #{ssh_path}} )

    ## todo - fix/fix/fix - maybe add a flag to turn on/off debugging
    ##           or connection test - why? why not?
    ##  note - if test is successful still returns
    ##     with exit code 1 (NOT 0 for success)
    ##  e.g.
    ##   Hi yorobot! You've successfully authenticated,
    ##               but GitHub does not provide shell access.
    ##
    ## Computer::Shell.run( %Q{ssh -vT git@github.com} )

    #####
    ## setup git
    ## git --version
    Git.version

    user_name  = ENV['YOROBOT_NAME']  || ENV['YO_NAME']  || 'Yo Robot'
    user_email = ENV['YOROBOT_EMAIL'] || ENV['YO_EMAIL'] || 'gerald.bauer+yorobot@gmail.com'

    Computer::Shell.run( %Q{git config --global user.name  "#{user_name}"} )
    Computer::Shell.run( %Q{git config --global user.email "#{user_email}"} )

    Computer::Shell.run( %Q{git config -l --show-origin} )
  end

end  # class Base
end  # module Flow




module Yorobot
class Tool
  def self.main( args=ARGV )

    ## setup/check mono root
    puts "[flow] pwd: #{Dir.pwd}"


    ## quick hack:
    ##   if /sites  does not exists
    ##               assume running with GitHub Actions or such
    ## and use working dir as root? or change to home dir ~/ or ~/mono - why? why not?
    ##
    ##   in the future use some -e/-env(ironemt)  settings and scripts - why? why not?
    if Dir.exist?( 'C:/Sites' )
      Mono.root = 'C:/Sites'     ## use local (dev) setup for testing flow steps

      puts "[flow]   assume local (dev) setup for testing"
    else
      Mono.root = Dir.pwd

      ## for debugging print / walk mono (source) tree
      Mono.walk
    end
    puts "[flow] Mono.root: #{Mono.root}"


    ## pass along to "standard" flow engine
    ::Flow::Tool.main( args )
  end
end  # class Tool
end  # module Yorobot


puts Yorobot::Module::Tool.banner             # say hello






=begin
 more debugging (trouble shooting) info & tips on ssh connect on github:

 Ensure the line endings are explicitly configured as LF (Unix format), not CRLF.

 Ensure there is one completely blank line at the absolute end of the file,
 right after -----END OPENSSH PRIVATE KEY-----.

 Copy the entire text, navigate to your repository on GitHub,
 and update the secret under Settings > Secrets and variables > Actions.
=end