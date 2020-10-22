####
#  3rd party gems / libs
#
# require 'computer'    # add shell run/call etc. machinery
#   add via gitti & hubba
require 'commands-lite'
require 'gitti'
require 'hubba'


# our own code
require 'yorobot/version'   # note: let version always go first
require 'yorobot/echo'
require 'yorobot/list'

require 'yorobot/github/git'
require 'yorobot/github/github'



module Yorobot
  def self.run( args )  Commands.run( args ); end
  def self.list()       List.run; end


  class Tool
    def self.main( args=ARGV )
      if args.size > 0
        Yorobot.run( args )
      else
        # list all known commands
        Yorobot.list
      end
    end
  end # class Tool
end  # module Yorobot


puts YorobotCore.banner             # say hello
