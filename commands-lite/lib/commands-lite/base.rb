class Command

def self.option_defs
  @option_defs ||= {}
end

def self.option( key, *args )
  option_defs[ key ] = args
end



def options
  @options ||= {}
end

def parse!( args )
  ### todo/check - cache option parser!!!! - why? why not?
  OptionParser.new do |parser|
    ## add default banner - overwrite if needed/to customize
    parser.banner = <<TXT

Usage: #{name} [OPTIONS] ARGUMENTS

TXT

    self.class.option_defs.each do | key, on_args|
      parser.on( *on_args ) do |value|
        options[ key ] = value
      end
    end
  end.parse!( args )
end



def self.run( args=[] )
  command      = new

  puts "--> (#{command.name})  #{args.join('·')}"

  ## check for options
  command.parse!( args )

  puts "     #{command.options.size} opt(s): #{command.options.pretty_inspect}"
  puts "     #{args.size} arg(s):"
  args.each_with_index do |arg,i|
    puts "            #{[i]} >#{arg}<"
  end


  if args.size > 0
    ## todo/check: check/verify arity of run - why? why not?
    command.call( *args )   ## use run - why? why not?
  else
    command.call
  end
end


def self.command_name
  ## note: cut-off leading Yorobot:: for now in class name!!!
  ## note: always remove _ for now too!!!
  ## note: do NOT use @@name!!! - one instance variable per class needed!!
  @name ||= self.name.downcase
                     .sub( /^yorobot::/, '' )   ## todo/fix: make "exclude" list configure-able  why? why not?
                     .gsub( /[_-]/, '' )
  @name
end

def name() self.class.command_name; end





def self.inherited( klass )
  # puts  klass.class.name  #=> Class
  ## auto-register commands for now - why? why not?
  Commands.register( klass )
end

end  # class Command


############################
#  Commands/Commander registry
class Commands   ## todo/check: use Commander/Command{Index,Registry,...} or such - why? why not?

def self.commands  ## todo/check: change to registry or such - why? why not?
  @@register ||= {}
end

def self.register( klass )
  raise ArgumentError, "class MUST be a Command"   unless klass.ancestors.include?( Command )

  h = commands
  h[ klass.command_name] = klass
  h
end


def self.run( args=[] )
  command_name = args.shift

  ## 1) downcase  e.g. GithubStats
  ## 2) remove - to _   ## treat them the same e.g. github-stats => github_stats
  command_name = command_name
                   .gsub( /[_-]/, '' )
                   .downcase

  command = commands[ command_name ]
  if command.nil?
    puts "!! ERROR: no command definition found for >#{command_name}<; known commands include:"
    pp commands
    exit 1
  end

  command.run( args )
end

end # class Commands


###########################
## add a alias / alternative name - why? why not
Commander = Commands


