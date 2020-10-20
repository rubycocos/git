require 'pp'
require 'time'
require 'date'    ## e.g. Date.today etc.
require 'yaml'
require 'json'
require 'uri'
require 'net/http'
require "net/https"
require 'open3'
require 'fileutils'    ## e.g. FileUtils.mkdir_p etc.

##########################
# more defaults ("prolog/prelude") always pre-loaded
require 'optparse'


#####################
# our own code
require 'computer/version'   # note: let version always go first
require 'computer/shell'



######################
# add convenience shortcuts - why? why not?
Compu = Computer


# say hello
puts Computer.banner
