##
## "prelude / prolog " add some common used stdlibs
##   add more - why? why not?
require 'pp'
require 'time'
require 'date'
require 'json'
require 'yaml'
require 'fileutils'

require 'uri'
require 'net/http'
require 'net/https'


require 'optparse'



#####################
# our own code
require 'flow-lite/version'   # note: let version always go first



module Flow
class Step
  attr_reader :names    # e.g. :list or [:list,:ls] etc.
  attr_reader :block

  def name() @names[0]; end  ## "primary" name

  def initialize( name_or_names, block )
    @names  =  if name_or_names.is_a?( Array )
                 name_or_names
               else
                 [name_or_names]   ## assume single symbol (name); wrap in array
               end
    @names = @names.map {|name| name.to_sym }   ## make sure we always use symbols
    @block  = block
  end
end # class Step



class Base    ## base class for flow class (auto)-constructed/build from flowfile
  def self.define_step( step )
    name = step.names[0]
    puts "[flow]    adding step  >#{name}<..."
    define_method( name, &step.block )
    alias_method( :"step_#{name}", name )  ## (auto-)add step_<name> alias

    alt_names = step.names[1..-1]
    alt_names.each do |alt_name|
      puts "[flow]      adding alias >#{alt_name}< for >#{name}<..."
      alias_method( alt_name, name )
    end
  end
end  # class Base



class Flowfile
  ## convenience method - use like Flowfile.load_file()
  def self.load_file( path='./Flowfile' )
    code = File.open( path, 'r:utf-8' ) { |f| f.read }
    load( code )
  end

  ## another convenience method - use like Flowfile.load()
  def self.load( code )
    flowfile = new
    flowfile.instance_eval( code )
    flowfile
  end



  def flow  ## build flow class
    @flow_class ||= build_flow_class
    @flow_class.new   ## todo/check: always return a new instance why? why not?
  end

  def build_flow_class
    puts "[flow]  building flow class..."
    klass = Class.new( Base )

    steps.each do |step|
      klass.define_step( step )
    end

    klass
  end



  def initialize( opts={} )
    @opts  = opts
    @steps = []
  end

  attr_reader :steps

  ## "classic / basic" primitives - step
  def step( name, &block )
    @steps << Step.new( name, block )
  end


  def run( name )
    name = name.to_sym  ## make sure we always use symbols
    if flow.respond_to?( name )
       flow.send( name )
    else
      puts "!! ERROR: step definition >#{name}< not found; cannot run/execute - known steps include:"
      pp @steps
      exit 1
    end
  end
end # class Flowfile



class Tool
  def self.main( args=ARGV )
    options = {}
    OptionParser.new do |parser|
      parser.on( '-f FILENAME', '--flowfile FILENAME' ) do |filename|
        options[:flowfile] = filename
      end
    end.parse!( args )

    path  =  options[:flowfile] || './Flowfile'
    flowfile = Flowfile.load_file( path )

    ## allow multipe steps getting called - why? why not?
    ##   flow setup clone update   etc??
    args.each do |arg|
      flowfile.run( arg )
    end
  end
end # class Tool

end # module Flow



# say hello
puts FlowLite.banner


