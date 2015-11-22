# encoding: utf-8

require 'pp'
require 'json'
require 'yaml'
require 'date'    ## e.g. Date.today etc.

require 'net/http'
require "net/https"
require 'uri'

require 'fileutils'    ## e.g. FileUtils.mkdir_p etc.


# 3rd party gems/libs
require 'logutils'

# our own code
require 'gitti/version'   # note: let version always go first
require 'gitti/lib'


## todo/check: move to its own gem e.g. gitti-support later - why? why not??
require 'gitti/support/reposet'


# say hello
puts Gitti.banner    if defined?( $RUBYLIBS_DEBUG )
