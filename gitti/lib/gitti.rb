# encoding: utf-8

require 'net/http'
require "net/https"
require 'uri'

require 'pp'
require 'json'
require 'yaml'


# 3rd party gems/libs
require 'logutils'

# our own code
require 'gitti/version'   # note: let version always go first
require 'gitti/lib'


# say hello
puts Gitti.banner    if defined?($RUBYLIBS_DEBUG)
