module Yorobot


class Step

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
  step      = new

  puts "--> (#{step.name})  #{args.join('·')}"

  ## check for options
  step.parse!( args )

  puts "     #{step.options.size} opt(s): #{step.options.pretty_inspect}"
  puts "     #{args.size} arg(s):"
  args.each_with_index do |arg,i|
    puts "            #{[i]} >#{arg}<"
  end


  if args.size > 0
    ## todo/check: check/verify arity of run - why? why not?
    step.call( *args )   ## use run - why? why not?
  else
    step. call
  end
end


def self.step_name
  ## note: cut-off leading Yorobot:: for now in class name!!!
  ## note: always remove _ for now too!!!
  ## note: do NOT use @@name!!! - one instance variable per class needed!!
  @name ||= self.name.downcase
                     .sub( /^yorobot::/, '' )
                     .gsub( /[_-]/, '' )
  @name
end

def name() self.class.step_name; end





def self.inherited( klass )
  # puts  klass.class.name  #=> Class
  ## auto-register steps for now - why? why not?
  Yorobot.register( klass )
end

end  # class Step



def self.steps  ## todo/check: change to registry or such - why? why not?
  @@register ||= {}
end

def self.register( klass )
  raise ArgumentError, "class MUST be a Yorobot::Step"   unless klass.ancestors.include?( Step )

  h = steps
  h[ klass.step_name] = klass
  h
end


def self.run( args=[] )
  step_name = args.shift

  ## 1) downcase  e.g. GithubStats
  ## 2) remove - to _   ## treat them the same e.g. github-stats => github_stats
  step_name = step_name
                 .gsub( /[_-]/, '' )
                 .downcase

  step = steps[ step_name ]
  if step.nil?
    puts "!! ERROR: no step definition found for >#{step_name}<; known steps include:"
    List.run
    exit 1
  end

  step.run( args )
end



end # module Yorobot
