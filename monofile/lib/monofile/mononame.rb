#####
#  mononame (e.g. @org/hello) machinery
#  turn
#  - @yorobot/stage/one
#  - one@yorobot/stage
#  - stage/one@yorobot
#      => into
#  - yorobot/stage/one



module Mono
  ## shared parse/norm helper (for Name/Path)
  ##  - find something better - why? why not?
  def self.norm_name( line )
    if args.size == 1 && args[0].is_a?( String )
      line = args[0]
     parts = line.split( '@' )
     raise ArgumentError, "[Mononame] no (required) @ found in name; got >#{line}<"               if parts.size == 1
     raise ArgumentError, "[Mononame] too many @ found (#{parts.size-1}) in name; got >#{line}<"  if parts.size > 2

     ## pass 1) rebuild norm path
     norm_name = String.new('')
     norm_name << parts[1]  ## add orgs path first
     if parts[0].length > 0   ## has leading repo name (w/ optional path)
        norm_name << '/'
        norm_name << parts[0]
     end
     norm_name

     ## pass 2) split into components
     parts = norm_name.split( '/' )

     args = [parts[0],
             parts[1]]

     more_parts = parts[2..-1]  ## check for any extra (optional) path parts
     args << more_parts.join('/')    if more_parts.size > 0

     args
   else
     raise ArgumentError, "[Mononame] one, two or three string args expected; got: #{args.pretty_inspect}"
   end
  end
end  # module Mono



class Mononame
  def self.parse( line )
    values = Mono.norm_name( line )
    raise ArgumentError, "[Mononame] expected two parts (org/name); got #{values.pretty_inspect}"   if values.size != 2
    new( *values )
  end

  ## note: org and name for now required
  ##   - make name optional too - why? why not?!!!
  attr_reader :org, :name

  def initialize( org, name )
    if (args.size == 3 && args[0].is_a?(String) && args[1].is_a?(String) && args[2].is_a?(String)) ||
      (args.size == 2 && args[0].is_a?(String) && args[1].is_a?(String))
    ## assume [org, name, path?]
    ##  note: for now assumes proper formatted strings
    ##   e.g. no leading @ or combined @hello/text in org
    ##   or name or such
    ##  - use parse/norm_name here too - why? why not?
    args


    @org  = org
    @name = name
  end

  def to_path() "#{org}/#{name}"; end
  def to_s()    "@#{to_path}"; end
end # class Mononame


####
## todo/check:
##   use as shared Mono/nomen/resource or such
#   shared base class for Mononame & Monopath - why? why not?

class Monopath
  def self.parse( line )
    values = Mono.norm_name( line )
    raise ArgumentError, "[Monopath] expected three parts (org/name/path); got #{values.pretty_inspect}"   if values.size != 3
    new( *values )
  end

  ## note: org and name AND path for now required
  ##   - make name path optional too - why? why not?!!!
  attr_reader :org, :name, :path

  def initialize( org, name, path )
     ## support/check for empty path too - why? why not?

    if (args.size == 3 && args[0].is_a?(String) && args[1].is_a?(String) && args[2].is_a?(String)) ||
      (args.size == 2 && args[0].is_a?(String) && args[1].is_a?(String))
    ## assume [org, name, path?]
    ##  note: for now assumes proper formatted strings
    ##   e.g. no leading @ or combined @hello/text in org
    ##   or name or such
    ##  - use parse/norm_name here too - why? why not?
    args

    @org  = org
    @name = name
    @path = path
  end

  def to_path() "#{org}/#{name}/#{path}"; end
  def to_s()    "@#{to_path}"; end
end  # class Monopath
## note: use Monopath   - avoid confusion with Monofile (a special file with a list of mono projects)!!!!

MonoName = Mononame
MonoPath = Monopath


## todo/check: add a (global) Mono/Mononame converter - why? why not?
##
## module Kernel
##  def Mono( *args ) Mononame.parse( *args ); end
## end
