#  How-To Back Up Your GitHub Repos - A Step-By-Step Guide


Why would you want to back up your github repos?
Isn't github itself a backup (even with an arctic vault option - see [How the cold storage will last 1000 years](https://archiveprogram.github.com/arctic-vault/))?


A personal anecdote -  in the morning (on February 15th) I was preparing
a tech talk for the FreeCodeCamp Vienna
(on programming pixel art in, yes, Ruby - Big in Japan! -
and JavaScript)
and heading out to Vienna in the afternoon for the live in-person
talk.


When I checked-up the next day in the morning
to post a link to the github repo
it was gone (and a dozen more) -
all taken down (with a 24-hour notice)
by an anonymous crypto bro ("More Punks")
filling out an online form.


While I had local (up-to-date)
working copies for recovery for taken down repos I was working on 
in the last days - for others the story is more complicated.

For more on the crypto punk's not dead under attack take down
story see the [**(Crypto) Punk's Not Dead**](https://github.com/cryptopunksnotdead) org.





Anyways, let's use ruby (and git) to back up your repos
using git (& github) gems from the ruby code commons (cocos) family:
- [**gitti-backup gem**](https://github.com/rubycocos/git/tree/master/gitti-backup) -  (yet) another (lite) git backup command line script and
- [**hubba gem**](https://github.com/rubycocos/git/tree/master/hubba) -  (yet) another (lite) GitHub HTTP API client / library.





## Step 1:   Prepare A List Of Repos (By User / Org) To Backup


If you have only a couple of repos - you can prepare
the repos list (in the yaml format) by hand
or let's automate the chore / task
querying the github api  (via the hubba gem)
for all repos.

Example  - prepare.rb:

```ruby
require 'cocos'
require 'hubba'

## get all repos for the user geraldb  (exclude all orgs)
h = Hubba.reposet( 'geraldb', orgs: false )
pp h

write_text( './repos.yml', h.to_yaml )   ## save as yaml
```

resulting in:

``` yaml
geraldb (4):
- geraldb
- geraldb.github.io
- sandbox
- talks
```

Let's add another user (for example, an alter-ego automation bot account)
or your business partner or friend etc.


```ruby
## get all repos for the user geraldb and yorobot (exclude all orgs)

h = Hubba.reposet( 'geraldb', 'yorobot', orgs: false )
pp h

write_text( './repos.yml', h.to_yaml )
```

resulting in:

``` yaml
geraldb (4):
- geraldb
- geraldb.github.io
- sandbox
- talks
yorobot (18):
- auto
- backup
- beer.db
- cache.csv
- cache.github
- football.csv
- football.db
- football.db.rsssf
- football.json
- logs
- planetjekyll
- rubyconf
- sport.db.more
- stage
- tipp3
- workflow
- world.db
- yorobot
```


Now if you have many of your repos
grouped by org(anization)s and NOT
under your personal account
drop the extra `orgs: false` keyword parameter
and the hubba machinery will (automagically)
query for all orgs and than query for all orgs one-by-one
of all repos.


```ruby
h = Hubba.reposet( 'geraldb', 'yorobot' )
pp h
write_text( './repos.yml', h.to_yaml )
```

resulting in:

``` yaml
geraldb (4):
- geraldb
- geraldb.github.io
- sandbox
- talks
yorobot (18):
- auto
- backup
- beer.db
- cache.csv
- cache.github
- football.csv
- football.db
- football.db.rsssf
- football.json
- logs
- planetjekyll
- rubyconf
- sport.db.more
- stage
- tipp3
- workflow
- world.db
- yorobot
austriacodes (5):
- austria.txt
- austriacodes.github.io
- awesome-austria
- showcase
- vienna.html
beerbook (3):
- beerbook.github.io
- calendar
- maps
beercsv (7):
- be-belgium
- build
- ca-canada
- de-deutschland
- statistics
- us-united-states
- world
beerkit (9):
- beer.db
- beer.db.admin
- beer.db.day
- beer.db.labels
- beer.db.labels.ruby
- beer.db.service
- beer.db.starter
- beer.js
- beerbook
bibtxt (1):
- bibtxt.github.io
bigkorupto (3):
- awesome-nocode
- mammad-kabiri-uniqa
- sources
bitsblocks (11):
- bitcoin-maximalist
- bitcoin-whitepaper
- bitsblocks.github.io
- colored-coins-whitepaper
- crypto-bubbles
- crypto-facts
- ethereum
- ethereum-whitepaper
- get-rich-quick-bible
- islandcoin-whitepaper
- mastercoin-whitepaper
# and on and on ...
yukimotopress (15):
- auto
- blockchains
- examples
- fizzbuzz
- gem-dev
- gem-tasks
- http
- langs
- micro
- practices
- practicing
- sinatra-intro
- smalldata
- start
- yukimotopress.github.io
```




## Step 2:  Back Up Your Repos Via Git Mirror ("Bare Bone")


Once you have prepared your repos list - prepare the backup script.
Example  - backup.rb:

```ruby
require 'gitti/backup'

## read-in the repo list
reposet = GitRepoSet.read( './repos.yml' )

## save all backups in /backup root  or wherever you want
backup = GitBackup.new( '/backup' )

## run the backups via git clone --mirror
##   if repo is new / first-time "bare bone" clone,
##   otherwise sync via  git remote update
backup.backup( reposet )

puts 'bye'
```

resulting in:

```
[1/551] geraldb@geraldb...
---> (shell run) >git clone --mirror https://github.com/geraldb/geraldb<... OK
Cloning into bare repository 'geraldb.git'...
[2/551] geraldb@geraldb.github.io...
---> (shell run) >git clone --mirror https://github.com/geraldb/geraldb.github.io<... OK
Cloning into bare repository 'geraldb.github.io.git'...
[3/551] geraldb@sandbox...
---> (shell run) >git clone --mirror https://github.com/geraldb/sandbox<... OK
...
```

and your directory tree like:

```
/backup
  /geraldb
     /geraldb.git
     /geraldb.github.io.git
     /sandbox.git
     ...
  ...
```

Note:  Yes, you can (re)run the backup script anytime
to update / sync the (bare bone) git (backup) repos.


resulting in:

```
[1/551] geraldb@geraldb...
---> (shell run) >git remote update<... OK
Fetching origin
[2/551] geraldb@geraldb.github.io...
---> (shell run) >git remote update<... OK
Fetching origin
[3/551] geraldb@sandbox...
---> (shell run) >git remote update<... OK
Fetching origin
...
```

for example, if there no changes and your backups
are up-to-date.


That's it.


