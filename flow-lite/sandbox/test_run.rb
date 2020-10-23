$LOAD_PATH.unshift( "./lib" )
require 'flow-lite'


flowfile = Flow::Flowfile.load_file( './sandbox/Flowfile' )
pp flowfile


flowfile.run( :first_step )



puts
puts "---"
flowfile = Flow::Flowfile.load( <<TXT )
  step :hello do
    puts "hello"
    step( :gruzi ) { puts "gruzi" }
    gruzi
  end

  step :hola do
    puts "holla"
  end
TXT
pp flowfile

flowfile.run( :hello )


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

