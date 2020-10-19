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



# our own code
require 'yorobot/shell/version'   # note: let version always go first
require 'yorobot/shell/shell'




# say hello
puts Yorobot::Module::Shell.banner
