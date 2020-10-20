####
#  3rd party gems / libs
#
# require 'computer'    # add shell run/call etc. machinery
#   add via gitti & hubba
require 'gitti'
require 'hubba'


# our own code
require 'yorobot/version'   # note: let version always go first
require 'yorobot/base'
require 'yorobot/echo'
require 'yorobot/list'

require 'yorobot/github'



module Yorobot
  class Tool
    def self.main( args=ARGV )
      if args.size > 0
        Yorobot.run( args )
      else
        # list all known steps
        List.run
      end
    end
  end # class Tool
end  # module Yorobot


puts YorobotCore.banner             # say hello
