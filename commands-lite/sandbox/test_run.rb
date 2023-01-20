$LOAD_PATH.unshift( "./lib" )
require 'commands-lite'


class Echo < Command

  def call( *args )
    puts args.join( ' ' )
  end

end # class Echo



class Hello < Command
  option :from, '--from NAME'
  option :yell, '--yell'

  def call( name )
    output = []
    output << "from: #{options[:from]}" if options[:from]
    output << "Hello #{name}"
    output = output.join("\n")
    puts options[:yell] ? output.upcase : output
  end
end


pp Commands.commands
pp Commander.commands

Commands.run( ['echo', 'Hello,', 'World!'] )


Commands.run( ['hello', 'Carola Lerche', '--from', 'Max Katz'] )
Commands.run( ['hello', '--from', 'Max Katz', 'Carola Lerche'] )
Commands.run( ['hello', '--from=Max_Katz', 'Carola Lerche'] )
Commands.run( ['hello', 'Carola Lerche'] )
Commands.run( ['hello', '--yell', '--from=Max_Katz', 'Carola Lerche'] )
Commands.run( ['hello', '--yell', 'Carola Lerche'] )


Hello.run( ['Carola Lerche', '--from', 'Max Katz'] )
Hello.run( ['--from', 'Max Katz', 'Carola Lerche'] )
Hello.run( ['Carola Lerche'] )
Hello.run( ['--yell', '--from', 'Max Katz', 'Carola Lerche'] )
Hello.run( ['--yell', 'Carola Lerche'] )



## todo/fix: check how to handle/construct ARGV:
##     --from="Max Katz"  !!!!!
## Commands.run( ['hello', '--from="Max Katz"', 'Carola Lerche'] )
