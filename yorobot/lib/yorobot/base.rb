module Yorobot


class Step

def self.run( args=[] )
  step      = new
  puts "--> (#{step.name}) #{args.size} arg(s):"
  args.each_with_index do |arg,i|
    puts "      #{[i]} >#{arg}<"
  end
  # args.join('·')

  step.call( args )   ## use run - why? why not?
end

def self.step_name
  ## note: cut-off leading Yorobot:: for now in class name!!!
  ## note: do NOT use @@name!!! - one instance variable per class needed!!
  @name ||= self.name.downcase.sub( /^yorobot::/, '' )
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

  step = steps[ step_name ]
  if step.nil?
    puts "!! ERROR: no step definition found for >#{step_name}<; known steps include:"
    List.run
    exit 1
  end
  step.run( args )
end



end # module Yorobot
