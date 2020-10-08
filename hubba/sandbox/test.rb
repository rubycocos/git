$LOAD_PATH.unshift( "./lib" )
require 'hubba'

#####################
## note:
##  set HUBBA_TOKEN on environment first!!!!
####################

gh = Hubba::Github.new

pp gh.user( 'geraldb')

repos = gh.user_repos( 'geraldb' )
pp repos
puts
puts "#{repos.names.size} repo(s) - geraldb:"
puts repos.names


orgs = gh.user_orgs( 'geraldb' )
pp orgs
puts
puts "#{orgs.logins.size} org(s) -geraldb:"
puts orgs.logins


repos = gh.user_repos( 'yorobot' )
## pp repos
puts
puts "#{repos.names.size} repo(s) - yorobot:"
puts repos.names


repos = gh.org_repos( 'rubycoco' )
## pp repos
puts
puts "#{repos.names.size} repo(s) - rubycoco:"
puts repos.names

repos = gh.org_repos( 'openfootball' )
## pp repos
puts
puts "#{repos.names.size} repo(s) - openfootball:"
puts repos.names
