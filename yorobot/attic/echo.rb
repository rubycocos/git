module Yorobot

class Echo < Command
  def call( *args )
    puts args.join( ' ' )
  end
end # class Echo

end # module Yorobot

