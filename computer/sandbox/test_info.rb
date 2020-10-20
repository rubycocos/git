$LOAD_PATH.unshift( "./lib" )
require 'computer'


puts "os:   #{Computer.os}"
puts "cpu:  #{Computer.cpu}"
puts "arch: #{Computer.arch}"
puts

## pp RbConfig::CONFIG

