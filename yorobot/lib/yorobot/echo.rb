module Yorobot


class Echo < Step

  def call( *args )
    puts args.join( ' ' )
  end

end # class Echo

end # module Yorobot

