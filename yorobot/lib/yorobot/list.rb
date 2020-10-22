module Yorobot

class List < Command
  def call
    ## list all known commands
    commands = Commands.commands
    puts "#{commands.size} command(s):"
    commands.each do |name, command|
      print "  %-10s" % name
      print " | #{command.class.name} (#{command.name})"
      print "\n"
    end
  end
end

end # module Yorobot



