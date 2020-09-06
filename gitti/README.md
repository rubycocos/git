# gitti

gitti gem - (yet) another (lite) git command line helper / wrapper

* home  :: [github.com/rubycoco/gitti](https://github.com/rubycoco/gitti)
* bugs  :: [github.com/rubycoco/gitti/issues](https://github.com/rubycoco/gitti/issues)
* gem   :: [rubygems.org/gems/gitti](https://rubygems.org/gems/gitti)
* rdoc  :: [rubydoc.info/gems/gitti](http://rubydoc.info/gems/gitti)



## Usage

`Git` • `GitProject` • `GitMirror`


### `Git` Class

Use the `Git` class for "low-level / to the metal" git commands
that run in your current working directory.
Example:

``` ruby

###############
## "setup" starter git commands

Git.clone( "https://github.com/rubycoco/gitti.git" )
Git.clone( "https://github.com/rubycoco/gitti.git", "gitti-clone" )
# -or-    -- if you have write / commit access use ssh
Git.clone( "git@github.com:rubycoco/gitti.git" )
Git.clone( "git@github.com:rubycoco/gitti.git", "gitti-clone" )

Git.mirror( "https://github.com/rubycoco/gitti.git" )  ## same as  git clone --mirror

#################
## standard git commands

Git.version                 ## same as  git --version
Git.status
Git.status( short: true )   ## same as Git.changes
Git.changes                 ## same as  git status --short

#####################
## status helpers

Git.clean?
Git.changes?
Git.dirty?      ## alias for changes?

#######
## more (major) git commands

Git.fetch
Git.pull
Git.fast_forward      ## same as  git pull --ff-only
Git.ff                ## alias for fast_forward
Git.push
Git.add( "pathspec" )
Git.add_all           ## same as  git --all
Git.commit( "message" )

Git.files                       ## same as  git ls-tree --full-tree --name-only -r HEAD

Git.check                       ## same as  git fsck
Git.fsck                        ## alias for check
Git.checksum                    ## another alias for check

Git.origin           ## same as   git remote show origin
Git.upstream         ## same as   git remote show upstream
Git.origin?
Git.upstream?


Git.config( "user.name" )                    ## use --get option
Git.config( "user.name", show_origin: true ) ## add --show-origin flag
Git.config( "user.name", show_scope: true )  ## add --show-scope flag

Git.config( /user/ )                     ## use --get-regexp option
Git.config( /user/, show_origin: true )  ## add --show-origin flag
Git.config( /user/, show_scope: true )   ## add --show-scope flag
```



### `GitProject` Class

Use the `GitProject` class for existing git repo(sitories)
with workspace. Example:

``` ruby
GitProject.open( "rubycoco/gitti" ) do |proj|
  proj.status
  proj.status( short: true )
  proj.changes
  proj.clean?
  proj.changes?
  proj.dirty?

  proj.fetch
  proj.pull
  proj.fast_forward
  proj.ff

  proj.push

  proj.add( "pathspec" )
  proj.add_all
  proj.commit( "message" )

  proj.files

  proj.origin
  proj.upstream
  proj.origin?
  proj.upstream?
end
```


### `GitMirror` Class

Use the `GitMirror` class for existing mirrored (bare) git repo(sitories)
without workspace. Example:

``` ruby
GitMirror.open( "rubycoco/gitti.git" ) do |mirror|
  mirror.update     # sames as  git remote update
end
```



That's it for now.



## Real World Usage

The [`monos`](https://github.com/rubycoco/monos) gem incl. some monorepo / mono source tree tools and (startup) scripts
that let you run git commands on multiple repos.



## Installation

Use

    gem install gitti

or add to your Gemfile

    gem 'gitti'



## License

The `gitti` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.

