# gitti-backup

gitti-backup gem - (yet) another (lite) git backup command line script

* home  :: [github.com/rubycoco/gitti](https://github.com/rubycoco/gitti)
* bugs  :: [github.com/rubycoco/gitti/issues](https://github.com/rubycoco/gitti/issues)
* gem   :: [rubygems.org/gems/gitti-backup](https://rubygems.org/gems/gitti-backup)
* rdoc  :: [rubydoc.info/gems/gitti-backup](http://rubydoc.info/gems/gitti-backup)



## Usage

### `backup` Command Line Tool

Use the `backup` command line tool to backup all repos listed in a "manifest" file (e.g. `repos.yml`, `code.yml`, `github.yml` or such). Example:

```
backup repos.yml             # or
backup code.yml data.yml
```

In a nutshell backup will backup all repos by using

1. `git clone --mirror` or
2. `git remote update`  (if the local backup already exists)

and store all bare repos (without workspace) in the `~/backup` directory.


#### Repos Manifest

For now only github repos are supported listed by
owner / organization. Example `repos.yml`:

``` yaml
sportdb:
- sport.db
- sport.db.sources
- football.db

yorobot:
- cache.csv
- sport.db.more
- football.db
- football.csv

openfootball:
- leagues
- clubs
```

Using `backup` with defaults this will result in:

```
~/backup
   /sportdb
      /sport.db.git
      /sport.db.sources.git
      /football.db.git
   /yorobot
      /cache.csv.git
      /sport.db.more.git
      /football.db.git
      /football.csv.git
   /openfootball
      /leagues.git
      /clubs.git
```



### Scripting

You can script your backup in ruby. Example:


``` ruby
require 'gitti/backup'

## step 1: setup the root backup directory - defaults to ~/backup
backup = GitBackup.new

## step 2: pass in all repos to backup by using
##   1) git clone --mirror or
##   2) git remote update  (if local backup already exists)
backup.backup( GitRepoSet.read( './repos.yml' ) )
```

or

``` ruby
require 'gitti/backup'

## step 1: setup the root backup directory
##   1) use custom directory e.g. /backups
##   2) auto-add a daily directory e.g. /backups/2020-09-27
backup = GitBackup.new( '/backups', daily: true )

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

