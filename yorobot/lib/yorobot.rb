require 'flow-lite'


####
#  add more 3rd party gems / libs to flow "prologue / prelude"
#
# require 'computer'    # add shell run/call etc. machinery
#   add via gitti & hubba
require 'gitti'
require 'hubba'
require 'mono'


# our own code
require 'yorobot/version'   # note: let version always go first



#### add predefined steps
module Flow
class Base

=begin
# check ssh
    if [ ! -d ~/.ssh ]; then mkdir ~/.ssh; fi
    echo "$SSH_KEY" > ~/.ssh/id_rsa
    chmod 600 ~/.ssh/id_rsa
    echo "ssh directory - ~/.ssh:"
    ls -la ~/.ssh
    #  ssh -vT git@github.com

# check git
     git --version
     git config --global user.name  "Yo Robot"
     git config --global user.email "gerald.bauer+yorobot@gmail.com"
     git config -l --show-origin
=end
  def setup
    ##############
    ## setup ssh

    ssh_key  = ENV['SSH_KEY']

    if ssh_key.nil?
      STDERR.puts "!! ERROR - required SSH_KEY env(ironment) variable missing"
      exit 1
    end

    ssh_path = File.expand_path( '~/.ssh' )

    if File.exist?( "#{ssh_path}/id_rsa" )
      STDERR.puts "!! ERROR - ssh key >#{ssh_path}/id_rsa< already exists"
      exit 1
    end

    ## make sure path exists
    FileUtils.mkdir_p( ssh_path )   unless Dir.exist?( ssh_path )
    puts "--> writing ssh key to >#{ssh_path}/id_rsa<..."
    File.open( "#{ssh_path}/id_rsa", 'w:utf-8' ) do |f|
      f.write( ssh_key )
    end
    ## note: ssh key must be "private" only access by owner (otherwise) WILL NOT work
    ## res = File.chmod( 0600, "#{ssh_path}/id_rsa" )
    ## puts res  ## returns number of files processed; should be 1 - assert - why? why not?
    Computer::Shell.run( %Q{chmod 600 #{ssh_path}/id_rsa} )

    Computer::Shell.run( %Q{ls -la #{ssh_path}} )
    # ssh -vT git@github.com


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
  alias_method :step_setup, :setup

end  # class Base
end  # module Flow





module Yorobot
  Tool = ::Flow::Tool
end  # module Yorobot


puts YorobotCore.banner             # say hello
