
module Yorobot
module Module
module Tool
  MAJOR = 2026   ## todo: namespace inside version or something - why? why not??
  MINOR = 6
  PATCH = 14
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

end # module Tool
end # module Module
end # module Yorobot
