# gitti-backup

gitti-backup gem - (yet) another (lite) git backup command line script

* home  :: [github.com/rubycoco/gitti](https://github.com/rubycoco/gitti)
* bugs  :: [github.com/rubycoco/gitti/issues](https://github.com/rubycoco/gitti/issues)
* gem   :: [rubygems.org/gems/gitti-backup](https://rubygems.org/gems/gitti-backup)
* rdoc  :: [rubydoc.info/gems/gitti-backup](http://rubydoc.info/gems/gitti-backup)


## Usage


``` ruby
require 'gitti/backup'

## step 1: setup the root backup directory - defaults to ~/backup
backup = GitBackup.new

## step 2: pass in all repos to backup by using
##   1) git clone --mirror or
##   2) git remote update  (if local backup already exists)
backup.backup( GitRepoSet.read( './repos.yml' ) )
```

That's all for now.



## Installation

Use

    gem install gitti-backup

or add to your Gemfile

    gem 'gitti-backup'


## License

The `gitti-backup` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.

