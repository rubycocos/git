require 'shell-lite'   ## note: move shell execute for (re)use to its own (upstream) gem

module Gitti
  Shell      = Computer::Shell
  ShellError = Computer::ShellError
  GitError   = Computer::ShellError  ## raised if git exec returns with non-zero exit - just use ShellError - why? why not?
  ## raised by Git::Shell.run
  ##  todo/check: use ShellError or RunError - why? why not?
  ##   and make Git::Shell top-level e.g. Shell - why? why not?

  ##   differentiate into/use
  ##     GitShell.run/GitCmd.run() or such and Shell.run  - why? why not?
end



# our own code
require 'gitti/version'   # note: let version always go first
require 'gitti/git'
require 'gitti/project'
require 'gitti/mirror'
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
     ##  note: https is default for github - http:// gets redirected to https://
     "http://github.com/#{@owner}/#{@name}"
  end

  def https_clone_url
    "https://github.com/#{@owner}/#{@name}"
  end


end   ## class GitHubRepo
end   ## module Gitti



# say hello
puts GittiCore.banner      ## if defined?( $RUBYCOCO_DEBUG )
