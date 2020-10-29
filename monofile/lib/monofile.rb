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


#####################
# our own code
require 'monofile/version'   # note: let version always go first




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
    attr_reader :org, :name

    ## todo/fix:
    ##  - use *args  and than split if args==2 or args==1 etc.
    def initialize( org, name )
      @org  = org
      @name = name
    end

    def to_s()    "@#{org}/#{name}"; end
    def to_path() "#{org}/#{name}"; end

    ## add clone_ssh_url  or such too!!!!
  end  ## (nested) class Project



  NAMES = ['monofile.yml',
           'monotree.yml',
           'monorepo.yml',
           'repos.yml']         ## todo/check: add mono.yml too - why? why not?

  def self.find
    NAMES.each do |name|
      return "./#{name}"  if File.exist?( "./#{name}")
    end

    nil  ## no monofile found; return nil
  end


  def self.read( path=find )
    if path
      txt  = File.open( path, 'r:utf-8') { |f| f.read }
      hash = YAML.load( txt )
      new( hash )
    else
      puts "!! WARN: no mono configuration file found; looking for #{NAMES.join(', ')} in (#{Dir.getwd})"
      new
    end
  end




  def initialize( obj={} )    ## todo/fix: change default to obj=[]
    @projects = []

    ## puts "[debug] obj.class=#{obj.class.name}"
    add( obj )
  end

  def add( obj )
    if obj.is_a?( Array )
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

  def size; @projects.size; end


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




Mono::Module::Monofile.banner

