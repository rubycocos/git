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
require 'gitta/version'   # note: let version always go first
require 'gitta/lib'


# say hello
puts Gitta.banner    if defined?($RUBYLIBS_DEBUG)
