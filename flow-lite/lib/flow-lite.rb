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
require 'flow-lite/base'
require 'flow-lite/tool'




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


class Flowfile

  ## find flowfile path by convention
  ## check for name by convention in this order:
  NAMES = ['flowfile',    'Flowfile',
           'flowfile.rb', 'Flowfile.rb']
  def self.find_file
    NAMES.each do |name|
      return "./#{name}"   if File.exist?( "./#{name}" )
    end
    nil
  end # method self.find_file


  ## convenience method - use like Flowfile.load_file()
  def self.load_file( path )
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
end # module Flow



# say hello
puts FlowLite.banner


