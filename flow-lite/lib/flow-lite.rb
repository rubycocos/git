require 'pp'


#####################
# our own code
require 'flow-lite/version'   # note: let version always go first



module Flow
class Step
  attr_reader :name

  def initialize( name, block )
    @name  = name
    @block = block
  end

  def call
    @block.call
  end
end # class Step





class Flowfile
  ## convenience method - use like Flowfile.load_file()
  def self.load_file( path='./Flowfile' )
    code = File.open( path, 'r:utf-8' ).read
    load( code )
  end

  ## another convenience method - use like Flowfile.load()
  def self.load( code )
    flowfile = new
    flowfile.instance_eval( code )
    flowfile
  end


  def initialize( opts={} )
    @opts  = opts
    @steps = {}
  end

  attr_reader :steps

  ## "classic / basic" primitives - step
  def step( name, &block )
    @steps[ name ] = Step.new( name, block )
  end

  def method_missing( method_sym )
    ## forward calls - why? why not?
    ## - lets you call other steps
    run_step( method_sym )
  end


  def run_step( name )
    step = @steps[ name ]
    if step.nil?
      puts "!! ERROR: step definition >#{name}< not found; cannot run/execute - known steps include:"
      pp @steps
      exit 1
    end
    step.call
  end
  alias_method :run, :run_step  ## keep run too - why? why not?

end # class Flowfile


end # module Flow



# say hello
puts FlowLite.banner


