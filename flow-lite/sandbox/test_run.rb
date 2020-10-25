$LOAD_PATH.unshift( "./lib" )
require 'flow-lite'


flowfile = Flow::Flowfile.load_file( './sandbox/Flowfile' )
pp flowfile


flowfile.run( :first_step )



puts
puts "---"
flowfile = Flow::Flowfile.load( <<TXT )
  step [:hello, :hi] do
    puts "hello"
    gruzi
  end

  step( :gruzi ) { puts "gruzi" }

  step :hola do
    puts "holla"
  end
TXT
pp flowfile

flowfile.run( :hello )

flow = flowfile.flow
pp flow.class.instance_methods( false )   ## false => exlclude all inherited methods
pp flow.class.instance_methods.grep( /^step_/ )
pp flow.hello
pp flow.hi
pp flow.gruzi
pp flow.hola



DATASETS = %w[a b c]

flowfile = Flow::Flowfile.new
pp flowfile
flowfile.step :hi do  puts "hi"; pp DATASETS; end


require 'gitti'

flowfile.step :git do
  Git.version
end

pp flowfile
flowfile.run( :hi )
flowfile.run( :git )

#  flowfile.run( :bye )

