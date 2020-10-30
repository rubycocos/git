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
require 'monofile/version'   # note: let version always go first
require 'monofile/mononame'



module Mono

  def self.root   ## root of single (monorepo) source tree
    @@root ||= begin
        ## todo/fix:
        ##  check if windows - otherwise use /sites
        ##  check if root directory exists?
        if ENV['MOPATH']
          ## use expand path to make (assure) absolute path - why? why not?
          File.expand_path( ENV['MOPATH'] )
        elsif Dir.exist?( 'C:/Sites' )
          'C:/Sites'
        else
          '/sites'
        end
    end
  end

  def self.root=( path )
    ## use expand path to make (assure) absolute path - why? why not?
    @@root = File.expand_path( path )
  end



  def self.monofile
    path = Monofile.find
    Monofile.read( path )

#    if path
#      GitRepoSet.read( path )
#    else
#      puts "!! WARN: no mono configuration file found; looking for #{MONOFILES.join(', ')} in (#{Dir.getwd})"
#      GitRepoSet.new( {} )  ## return empty set -todo/check: return nil - why? why not?
#    end
  end
end  ## module Mono




class Monofile
  ## holds a list of projects

  ## nested class
  class Project

    ## use some different names / attributes ??
    attr_reader :org,    ## todo/check: find a different name (or add alias e.g. login/user/etc.)
                :name

    ## todo/fix:
    ##  - use *args  and than split if args==2 or args==1 etc.
    def initialize( *args )
      if args.size == 2 && args[0].is_a?(String) && args[1].is_a?(String)
        ## assume [org, name]
        @org  = args[0]
        @name = args[1]
      elsif args.size == 1 && args[0].is_a?( String )
        ## todo/fix:  use norm_name parser or such!!!!
        parts = args[0].split( '/' )
        @org  = parts[0][1..-1]   ## cut-off leading @ (always assume for now!!)
        @name = parts[1]
      else
        raise ArgumentError, "[Monorepo::Project] one or two string args expected; got: #{args.pretty_inspect}"
      end
    end

    def to_s()    "@#{org}/#{name}"; end
    def to_path() "#{org}/#{name}"; end

    ## add clone_ssh_url  or such too!!!!
  end  ## (nested) class Project



  class Builder     ## "clean room" pattern/spell - keep accessible methods to a minimum (by eval in "cleanroom")
    def initialize( monofile )
      @monofile = monofile
    end

    def project( *args )
      project = Project.new( *args )
      @monofile.projects << project
    end
  end  # (nested) class Builder



  RUBY_NAMES = ['monofile',
                'Monofile',
                'monofile.rb',
                'Monofile.rb',
               ]

  TXT_NAMES  = ['monofile.txt',
                'monotree.txt',  ## keep monotree - why? why not?
                'monorepo.txt',
                'repos.txt']

  ## note: yaml always requires an extension
  YML_NAMES = ['monofile.yml',   'monofile.yaml',
                'monotree.yml',   'monotree.yaml',  ## keep monotree - why? why not?
                'monorepo.yml',   'monorepo.yaml',
                'repos.yml',      'repos.yaml',
               ]    ## todo/check: add mono.yml too - why? why not?

  NAMES = RUBY_NAMES + TXT_NAMES + YML_NAMES


  def self.find
    RUBY_NAMES.each do |name|
      return "./#{name}"  if File.exist?( "./#{name}")
    end

    TXT_NAMES.each do |name|
      return "./#{name}"  if File.exist?( "./#{name}")
    end

    YML_NAMES.each do |name|
      return "./#{name}"  if File.exist?( "./#{name}")
    end

    nil  ## no monofile found; return nil
  end


  def self.read( path )
      txt  = File.open( path, 'r:utf-8') { |f| f.read }

      ## check for yml or yaml extension;
      ##    or for txt extension; otherwise assume ruby
      extname = File.extname( path ).downcase
      if ['.yml', '.yaml'].include?( extname )
        hash = YAML.load( txt )
        new( hash )
      elsif ['.txt'].include?( extname )
        new( txt )
      else  ## assume ruby code (as text in string)
        new().load( txt )
      end
  end



  def self.load( code )
    monofile = new
    monofile.load( code )
    monofile
  end

  def self.load_file( path )  ## keep (or add load_yaml to or such) - why? why not?
    code  = File.open( path, 'r:utf-8') { |f| f.read }
    load( code )
  end


  ### attr readers
  def projects() @projects; end
  def size()     @projects.size; end


  def initialize( obj={} )    ## todo/fix: change default to obj=[]
    @projects = []

    ## puts "[debug] obj.class=#{obj.class.name}"
    add( obj )
  end

  def load( code )  ## note: code is text as a string
    builder = Builder.new( self )
    builder.instance_eval( code )
    self  ## note: for chaining always return self
  end


  def add( obj )
    ## todo/check: check for proc too! and use load( proc/block ) - possible?
    if obj.is_a?( String )
      puts "sorry add String - to be done!!!"
      exit 1
    elsif obj.is_a?( Array )
      puts "sorry add Array- to be done!!!"
      exit 1
    elsif obj.is_a?( Hash )
      add_hash( obj )
    else  ## assume text (evaluate/parse)
      puts "sorry add Text - to be done!!!"
      exit 1
    end
    self ## note: return self for chaining
  end


  def add_hash( hash )
    hash.each do |org_with_counter, names|

      ## remove optional number from key e.g.
      ##   mrhydescripts (3)    =>  mrhydescripts
      ##   footballjs (4)       =>  footballjs
      ##   etc.

      ## todo/check: warn about duplicates or such - why? why not?

      org = org_with_counter.sub( /\([0-9]+\)/, '' ).strip.to_s

      names.each do |name|
        @projects << Project.new( org, name )
      end
    end

    self  ## note: return self for chaining
  end



  def each( &block )
      ## puts "[debug] arity: #{block.arity}"

      ## for backwards compatibility support "old" each with/by org & names
      ##   add deprecated warnings and use to_h or such - why? why not?
      if block.arity == 2
        puts "!! DEPRECATED  - please, use Monofile#to_h or Monofile.each {|proj| ...}"
        to_h.each do |org, names|
          block.call( org, names )
        end
      else
        ## assume just regular
        @projects.each do |project|
          block.call( project )
        end
      end
  end # method each

  def each_with_index( &block )
    @projects.each_with_index do |project,i|
       block.call( project, i )
    end
  end



  ### for backward compat(ibility) add a hash in the form e.g:
  ##
  ## geraldb:
  ## - austria
  ## - catalog
  ## - geraldb.github.io
  ## - logos
  ## yorobot:
  ## - auto
  ## - backup
  ## - football.json
  ## - logs
  ##
  def to_h
    h = {}
    @projects.each do |project|
      h[ project.org ] ||= []
      h[ project.org ] << project.name
    end
    h
  end

  def to_a
    ## todo/check:
    ##   - sort all entries a-z - why? why not?
    ##   - always start name with @ marker - why? why not?
    @projects.map {|project| project.to_s }
  end
end # class Monofile





class Monofile
class Tool
  def self.main( args=ARGV )


    ## todo/fix:
    ##   check args - if any, use/read monofiles in args!!!


    path = Monofile.find
    if path.nil?
      puts "!! ERROR: no mono configuration file found; looking for #{Monofile::NAMES.join(', ')} in (#{Dir.getwd})"
      exit 1
    end

    ## add check for auto-require (e.g. ./config.rb)
    config_path = "./config.rb"
    if File.exist?( config_path )
      puts "[monofile] auto-require >#{config_path}<..."
      require( config_path )
    end

    puts "[monofile] reading >#{path}<..."
    monofile=Monofile.read( path )
    pp monofile

    ## print one project per line
    puts "---"
    monofile.each do |proj|
      puts proj.to_s
    end
  end
end # (nested) class Tool
end # class Monofile


Mono::Module::Monofile.banner

