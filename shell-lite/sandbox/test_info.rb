$LOAD_PATH.unshift( "./lib" )
require 'shell-lite'


puts "os:   #{Computer.os}"
puts "cpu:  #{Computer.cpu}"
puts "arch: #{Computer.arch}"
puts

## pp RbConfig::CONFIG

