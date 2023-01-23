# Gemverse - Gem Universe

gemverse gem - gem universe incl. rubygems API V1 wrapper lite; gem version cache, gem timeline reports, 'n' more



* home  :: [github.com/rubycocos/git](https://github.com/rubycocos/git)
* bugs  :: [github.com/rubycocos/git/issues](https://github.com/rubycocos/git/issues)
* gem   :: [rubygems.org/gems/gemverse](https://rubygems.org/gems/gemverse)
* rdoc  :: [rubydoc.info/gems/gemverse](http://rubydoc.info/gems/gemverse)





## Usage


### RubyGems API "To The Metal" Wrapper V1 - Lite Edition

The gemverse includes a lightweight "to the metal"
wrapper for the rubygems API V1
that returns data(sets) in the JSON format:

``` ruby
require 'gemverse'

## get all gems owned by the author with the handle / known as gettalong
#    same as https://rubygems.org/api/v1/owners/gettalong/gems.json
data = Gems::API.gems_by( 'gettalong' )
puts "  #{data.size} record(s)"
#=>  24 record(s)

## get all versions of the hexapdf gem
#    same as https://rubygems.org/api/v1/versions/hexpdf.json"
data = Gems::API.versions( 'hexapdf' )
puts "  #{data.size} record(s)"
#=>  71 record(s)

#...
```


### Gem Cache 'n' Timeline Reports

Let's build a gem timeline report / what's news page.
Let's spotlight the work of [Thomas Leitner, Austria also known as `gettalong`](https://rubygems.org/profiles/gettalong)
who 24 published gems (as of 2023) in the last 10+ years.

Note:  Yes, you can. Replace the `gettalong`  rubygems id / login with your own to build your very own timeline.


**Step 1 - Online - Get gems & versions via "higher-level" rubygems api calls**

``` ruby
cache = Gems::Cache.new( './cache' )

gems = Gems.find_by( owner: 'gettalong' )
puts "  #{gems.size} record(s)"
#=>  24 record(s)

## bonus: save gems in a "flat" tabular datafile using the comma-separated values (.csv) format
gems.export( './profiles/gettalong/gems.csv' )

## fetch all gem versions and (auto-save)
##   in a "flat" tabular datafile (e.g. <gem>/versions.csv)
##    using the comma-spearated values (.csv) format
##    in the cache directory
cache.update_versions( gems: gems )
```


**Step 2 - Offline - Read versions from cache and build reports / timeline**

``` ruby
cache = Gems::Cache.new( './gems' )

gems = read_csv( './profiles/gettalong/gems.csv' )
puts "  #{gems.size} record(s)"
#=>  24 record(s)

versions = cache.read_versions( gems: gems )
puts "  #{versions.size} record(s)"
#=>  238 record(s)

timeline = Gems::Timeline.new( versions,
                               title: "Thomas Leitner's Timeline" )
timeline.save( "./profiles/gettalong/README.md" )
```


That's it.



Tip:  You can build "custom" timeline reports
and filter / select the gems to include as you like.
Let's (re)build the timeline for all ruby cocos (code commons)
gems.

``` ruby
cache = Gems::Cache.new( './cache' )

gems = read_csv( './collections/cocos.csv' )
puts "  #{gems.size} record(s)"

versions = cache.read_versions( gems: gems )
puts "   #{versions.size} record(s)"

timeline = Gems::Timeline.new( versions,
                               title: 'Ruby Code Commons (COCOS) Timeline' )
timeline.save( "./collections/cocos/README.md" )
```

That's it.


See
[Thomas Leitner's Timeline](https://github.com/rubycocos/gems/tree/master/profiles/gettalong),
[Jan Lelis's Timeline](https://github.com/rubycocos/gems/tree/master/profiles/janlelis),
[Ruby Code Commons (COCOS) Timeline](https://github.com/rubycocos/gems/tree/master/collections/cocos), and some more
for some real-world timeline samples.

Or the gems leaderboard at the [Vienna.rb / Wien.rb - Ruby Meetup / Stammtisch in Vienna, Austria](https://viennarb.github.io/) page.


Yes, you can. [Tell us about your gem timeline / leaderborad sample(s) »]().



## License

The `gemverse` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.

