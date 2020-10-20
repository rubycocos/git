module Yorobot


class List < Step

  def call( args )
    ## list all know steps
    steps = Yorobot.steps
    puts "#{steps.size} step(s):"
    steps.each do |name, step|
      puts "  #{name}   | #{step.class.name}"
    end
  end
end

end # module Yorobot


#####
#
#
#    -- add "shortcut why? why not?"
#  step [:list, :ls] do |args|
#    ....
#  end