# hubba

hubba gem - (yet) another (lite) GitHub HTTP API client / library

* home  :: [github.com/rubycoco/git](https://github.com/rubycoco/git)
* bugs  :: [github.com/rubycoco/git/issues](https://github.com/rubycoco/git/issues)
* gem   :: [rubygems.org/gems/hubba](https://rubygems.org/gems/hubba)
* rdoc  :: [rubydoc.info/gems/hubba](http://rubydoc.info/gems/hubba)


## Usage


### Step 0:  Secrets, Secrets, Secrets - Your Authentication Token

Note: Set your GitHub env credentials (personal access token preferred) e.g.

```
set HUBBA_TOKEN=abcdef0123456789
#   - or -
set HUBBA_USER=you
set HUBBA_PASSWORD=topsecret
```


### Step 1: Get a list of all your repos

Use the GitHub API to get a list of all your repos:

``` ruby
require 'hubba'

h = Hubba.reposet( 'geraldb' )
pp h

File.open( './repos.yml', 'w' ) { |f| f.write( h.to_yaml ) }
```

resulting in:

``` yaml
geraldb (11):
- austria
- catalog
- chelitas
- geraldb.github.io
- logos
- sandbox
- talks
- web-proxy-win
- webcomponents
- webpub-reader
- wine.db.tools

openfootball (41):
- africa-cup
- austria
- club-world-cup
- clubs
- confed-cup
- copa-america
- copa-libertadores
- copa-sudamericana
- deutschland
# ...
```


Note: If you have more than one account (e.g. an extra robot account or such)
you can add them along e.g.


``` ruby
h = Hubba.reposet( 'geraldb', 'yorobot' )
pp h
```


Note: By default all your repos from organizations get auto-included -
use the `orgs: false` option to turn off auto-inclusion.

Note: By default all (personal) repos, that is, repos in your primary (first)
account that are forks get auto-excluded.



### Step 2: Update repo statistics (daily / weekly / monthly)


#### Basics (commits, stars, forks, topics, etc.)

Use `update_stats` to
to get the latest commit, star count and more for all your repos
listed in `./repos.yml` via the GitHub API:

``` ruby
Hubba.update_stats( './repos.yml' )
```

Note: By default the datafiles (one per repo)
get stored in the `./data` directory.


#### Traffic (page views, clones, referrers, etc.)

Use `update_traffic` to
to get the latest traffic stats (page views, clones, referrers, etc.)
for all your repos listed in `./repos.yml` via the GitHub API.

``` ruby
Hubba.update_traffic( './repos.yml' )
```

Note: Access to traffic statistics via the GitHub API
requires push access for your GitHub (personal access) token.




### Step 3: Generate some statistics / analytics reports


See the [hubba-reports gem](https://github.com/rubycoco/git/tree/master/hubba-reports) on how to use pre-built/pre-packaged ready-to-use
github statistics / analytics reports.



That's all for now.



## Installation

Use

    gem install hubba

or add the gem to your Gemfile

    gem 'hubba'


## License

The `hubba` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.
