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



  ## run step by symbol/name (e.g. step :hello - etc.)
  def step( name )
    name = name.to_sym  ## make sure we always use symbols
    if respond_to?( name )
       send( name )
    else
      puts "!! ERROR: step definition >#{name}< not found; cannot run/execute - known steps include:"
      pp self.class.instance_methods.grep( /^step_/ )   #=> e.g. [:step_hello, ...]
      exit 1
    end
  end  # method step

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



  def flow
    ## todo/check: always return a new instance why? why not?
    flow_class.new
  end

  def flow_class
    @flow_class ||= build_flow_class
  end

  def build_flow_class
    puts "[flow]  building flow class..."
    klass = Class.new( Base )

    steps.each do |step|
      klass.define_step( step.names, &step.block )
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
    ## todo/check: always return/use a new instance why? why not?
    flow_class.new.step( name )
  end
end # class Flowfile




class Tool
  def self.main( args=ARGV )
    options = {}
    OptionParser.new do |parser|
      parser.on( '-f FILENAME', '--flowfile FILENAME' ) do |filename|
        options[:flowfile] = filename
      end

      ## note:
      ##  you can add many/multiple modules
      ##  e.g. -r gitti -r hubba etc.
      parser.on( '-r NAME', '--require NAME') do |name|
        options[:requires] ||= []
        options[:requires] << name
      end
    end.parse!( args )


    ## check for any (dynamic/auto) requires
    if options[:requires]
      names = options[:requires]
      names.each do |name|
        ## todo/check: add some error/exception handling here - why? why not?
        puts "[flow] require >#{name}<..."
        require( name )
      end
    end


    path = options[:flowfile] || find_flowfile

    ## todo/fix/check:
    ##   check rake for error message - no Flowfile/Rakefile or such
    ##   add here  if path.nil? exit 1

    puts "[flow] loading >#{path}<..."
    flowfile = Flowfile.load_file( path )


    ## allow multipe steps getting called - why? why not?
    ##   flow setup clone update   etc??
    args.each do |arg|
      flowfile.run( arg )
    end
  end # method self.main

  ####################
  # helpers
  def self.find_flowfile
    ## find flowfile path by convention
    ## check for name by convention in this order:
    names = ['flowfile',    'Flowfile',
             'flowfile.rb', 'Flowfile.rb']

    names.each do |name|
      return name   if File.exist?( "./#{name}" )
    end

    nil
  end # method self.find_flowfile
end # class Tool

end # module Flow



# say hello
puts FlowLite.banner


