module Hubba

class Configuration
  def data_dir()         @data_dir || './data'; end
  def data_dir=( value ) @data_dir = value;     end

  # try default setup via ENV variables
  def token()            @token || ENV[ 'HUBBA_TOKEN' ]; end
  def token=( value )    @token = value;                 end

  # todo/check: use HUBBA_LOGIN - why? why not?
  def user()             @user     || ENV[ 'HUBBA_USER' ]; end
  def password()         @password || ENV[ 'HUBBA_PASSWORD' ]; end
  def user=( value )     @user     = value;                end
  def password=( value ) @password = value;                end

end  # class Configuration


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
class << self
  alias_method :config, :configuration
end


def self.configure
 yield( configuration )
end

end # module Hubba
