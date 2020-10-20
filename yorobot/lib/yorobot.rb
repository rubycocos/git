#####
# say hello
require 'yorobot/version'   # note: let version always go first
puts YorobotCore.banner


####
# more stdlibs
require 'optparse'    ## todo/fix: also move to yorobot/shell - why? why not?

####
#  3rd party gems / libs
#
# require 'yorobot/shell'    # add shell run/call etc. machinery
#   add via gitti
require 'gitti'


# our own code
require 'yorobot/base'
require 'yorobot/echo'
require 'yorobot/list'


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

