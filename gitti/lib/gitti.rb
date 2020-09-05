require 'pp'
require 'time'
require 'date'    ## e.g. Date.today etc.
require 'yaml'
require 'json'
require 'uri'
require 'net/http'
require "net/https"
require 'open3'
require 'fileutils'    ## e.g. FileUtils.mkdir_p etc.



# our own code
require 'gitti/version'   # note: let version always go first
require 'gitti/base'
require 'gitti/project'
require 'gitti/reposet'



module Gitti
## todo: change to GitHubRepoRef or GitHubProject
##   or Git::GitHub or Git::Source::GitHub or such - why? why not?
class GitHubRepo
  attr_reader :owner, :name

  def initialize( owner, name )
    @owner = owner    ## use/rename to login or something - why? why not??
    @name  = name     #  e.g. "rubylibs/webservice"
  end


  def ssh_clone_url
     ##  check: use https: as default? for github - http:// still supported? or redirected?
     ## "http://github.com/#{@owner}/#{@name}"
     "git@github.com:#{@owner}/#{@name}.git"
  end

  def http_clone_url   ## use clone_url( http: true )  -- why? why not?
     ##  check:  is https: default? for github - http:// still supported? or redirected?
     "http://github.com/#{@owner}/#{@name}"
  end

  def https_clone_url
    "https://github.com/#{@owner}/#{@name}"
  end


end   ## class GitHubRepo
end   ## module Gitti



# say hello
puts GittiCore.banner      ## if defined?( $RUBYCOCO_DEBUG )
