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
    step :grüezi
  end

  step( :grüezi ) { puts "grüezi" }

  step :hola do
    puts "holla"
  end
TXT
pp flowfile

flowfile.run( :hello )

flow = flowfile.flow
pp flow.class.step_methods
pp flow.class.instance_methods( false )   ## false => exlclude all inherited methods
pp flow.class.instance_methods.grep( /^step_/ )
flow.step_hello
flow.step_hi
flow.step_grüezi
flow.step_hola

flow.step( :hello )
flow.step( :hi )
flow.step( :grüezi )
flow.step( :hola )


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

puts "bye"



