###
# to test run:
#     ruby sandbox/test_run.rb -f sandbox/Flowfile


$LOAD_PATH.unshift( File.expand_path( './lib' ) )
puts "LOAD_PATH:"
puts $LOAD_PATH
puts
require 'yorobot'

puts Hubba::VERSION
puts HubbaReports::VERSION


Yorobot::Tool.main
Yorobot::Tool.main( ['-f', 'sandbox/Flowfile' ] )
Yorobot::Tool.main( ['-f', 'sandbox/Flowfile', 'echo' ] )

