$LOAD_PATH.unshift( "./lib" )
require 'yorobot'


Yorobot::Tool.main
Yorobot::Tool.main( ['-f', 'sandbox/Flowfile' ] )
Yorobot::Tool.main( ['-f', 'sandbox/Flowfile', 'echo' ] )

