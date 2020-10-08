module Hubba

class Configuration
  attr_accessor :token

  attr_accessor :user
  attr_accessor :password

  def initialize
    # try default setup via ENV variables
    @token    = ENV[ 'HUBBA_TOKEN' ]

    @user     = ENV[ 'HUBBA_USER' ]    ## use HUBBA_LOGIN - why? why not?
    @password = ENV[ 'HUBBA_PASSWORD' ]
  end
end

## lets you use
##   Hubba.configure do |config|
##      config.token    = 'secret'
##        -or-
##      config.user     = 'testdada'
##      config.password = 'secret'
##   end
##
##   move configure block to GitHub class - why? why not?
##   e.g. GitHub.configure do |config|
##          ...
##        end


def self.configuration
 @configuration ||= Configuration.new
end

def self.configure
 yield( configuration )
end

end # module Hubba
