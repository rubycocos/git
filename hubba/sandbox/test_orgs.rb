$LOAD_PATH.unshift( "./lib" )
require 'hubba'

#####################
## note:
##  set HUBBA_TOKEN on environment first!!!!
####################

gh = Hubba::Github.new

=begin
orgs = gh.user_orgs( 'yorobot' )
pp orgs
puts
puts "#{orgs.logins.size} org(s) - yorobot:"
puts orgs.logins
puts

orgs = gh.user_orgs( 'geraldb' )
pp orgs
puts
puts "#{orgs.logins.size} org(s) - geraldb:"
puts orgs.logins
puts
=end

# org = gh.org( 'openbeer' )
org = gh.org( 'openfootball' )
pp org


