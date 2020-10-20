$LOAD_PATH.unshift( "./lib" )
require 'yorobot'


Yorobot::List.run
Yorobot::Echo.run( ['Hello,', 'World!'] )

Yorobot.run( ['list'] )
Yorobot.run( ['echo', 'Hello,', 'World!'] )



Yorobot::Tool.main
Yorobot::Tool.main( ['echo', 'Hello,', 'World!'] )