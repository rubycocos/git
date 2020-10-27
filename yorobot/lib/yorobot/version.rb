
## todo/check:
##  use Yorobot::Module::Core or Commands or Tool or such - why? why not?


module YorobotCore    ## todo/check: rename GittiBase or GittiMeta or such - why? why not?
  MAJOR = 1   ## todo: namespace inside version or something - why? why not??
  MINOR = 0
  PATCH = 5
  VERSION = [MAJOR,MINOR,PATCH].join('.')

  def self.version
    VERSION
  end

  def self.banner
    "yorobot/#{VERSION} on Ruby #{RUBY_VERSION} (#{RUBY_RELEASE_DATE}) [#{RUBY_PLATFORM}]"
  end

  def self.root
    File.expand_path( File.dirname(File.dirname(File.dirname(__FILE__))) )
  end
end # module YorobotCore

