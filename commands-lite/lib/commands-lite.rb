require 'pp'
require 'time'
require 'date'         ## e.g. Date.today etc.
require 'yaml'
require 'json'
require 'fileutils'    ## e.g. FileUtils.mkdir_p etc.
require 'optparse'



#####################
# our own code
require 'commands-lite/version'   # note: let version always go first
require 'commands-lite/base'



# say hello
puts CommandsLite.banner
