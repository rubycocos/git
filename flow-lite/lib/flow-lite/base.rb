
module Flow

class Base    ## base class for flow class (auto)-constructed/build from flowfile
  def self.define_step( name_or_names, &block )
    names =  if name_or_names.is_a?( Array )
               name_or_names
             else
               [name_or_names]   ## assume single symbol (name); wrap in array
             end
    names = names.map {|name| name.to_sym }   ## make sure we always use symbols


    name = names[0]
    puts "[flow]    adding step  >#{name}<..."
    define_method( :"step_#{name}", &block )

    alt_names = names[1..-1]
    alt_names.each do |alt_name|
      puts "[flow]      adding alias >#{alt_name}< for >#{name}<..."
      alias_method( :"step_#{alt_name}", :"step_#{name}" )
    end
  end  # method self.define_step




  TRUE_VALUES = [
    'true', 't',
    'yes', 'y',
    'on',
    '1',
  ]

  ### include / check for ruby debug flag too - why? why not?
  def debug?
    value = ENV['DEBUG']
    if value && TRUE_VALUES.include?( value.downcase )
      true
    else
      false
    end
  end



  ## run step by symbol/name (e.g. step :hello - etc.)
  ##
  ##  todo/check:  allow (re)entrant calls to step (step calling step etc.) - why? why not?
  def step( name )
    step_name = :"step_#{name}"  ## note: make sure we always use symbols
    if respond_to?( step_name )
      #######
      ## check: track (and report) call stack - why? why not?
      ## e.g.
      ##   [flow >(1) first_step)] step >first_step< - starting...
      ##   [flow >(2) ..first_step > second_step)] step >second_step< - starting...
      ##   [flow >(3) ....first_step > second_step > third_step)] step >third_step< - starting...
      @stack ||= []   ## use a call stack of step names
      @stack.push( name )

      puts "[flow >(#{@stack.size}) #{'..'*(@stack.size-1)}#{@stack.join(' > ')})] step >#{name}< - starting..."
      start_time = Time.now   ## todo: use Timer? t = Timer.start / stop / diff etc. - why? why not?

      __send__( step_name )

      end_time = Time.now
      diff_time = end_time - start_time
      puts "[flow <(#{@stack.size}) #{'..'*(@stack.size-1)}#{@stack.join(' < ')})] step >#{name}< - done in #{diff_time} sec(s)"
      @stack.pop
    else
      puts "!! ERROR: step definition >#{name}< not found; cannot run/execute - known (defined) steps include:"
      pp self.class.step_methods  #=> e.g. [:hello, ...]
      exit 1
    end
  end  # method step


  def self.step_methods
    names = instance_methods.reduce([]) do |names, name|
                                          names << $1.to_sym  if name =~ /^step_(.+)/
                                          names
                                        end
    names
  end
end  # class Base


end # module Flow