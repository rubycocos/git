# Gemverse - Gem Universe

gemverse gem - gem universe incl. rubygems API V1 wrapper lite; gem version cache, gem timeline reports, 'n' more





## Usage


### RubyGems API "To The Metal" Wrapper V1 - Lite Edition

The gemverse includes a lightweight "to the metal"
wrapper for the rubygems API V1
that returns data(sets) in the JSON format:

``` ruby
require 'gemverse'

## get all gems owned by the author with the handle / known as gettalong
data = Gems::API.gems_by( 'gettalong' )
# same as https://rubygems.org/api/v1/owners/gettalong/gems.json

## get all versions of the hexapdf gem
data = Gems::API.versions( 'hexapdf' )
# same as https://rubygems.org/api/v1/versions/hexpdf.json"

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

## bonus: save gems in a "flat" tabular datafile using the comma-separated values (.csv) format
gems.export( './profile/gettalong/gems.csv' )

## fetch all gem versions and (auto-save)
##   in a "flat" tabular datafile (e.g. <gem>/versions.csv)
##    using the comma-spearated values (.csv) format
##    in the cache directory
cache.update_versions( gems: gems )
```


**Step 2 - Offline - Read versions from cache and build reports / timeline**

``` ruby
cache = Gems::Cache.new( './gems' )

gems = read_csv( './profile/gettalong/gems.csv' )
puts "  #{gems.size} record(s)"

versions = cache.read_versions( gems: gems )
puts "  #{versions.size} record(s)"

timeline = Gems::Timeline.new( versions,
                               title: "Thomas Leitner's Timeline" )
timeline.save( "./profile/gettalong/README.md" )
```


That's it.



Tip:  You can build "custom" timeline reports
and filter / select the gems to include as you like.
Let's (re)build the timeline for all ruby cocos (code commons)
gems.

``` ruby
cache = Gems::Cache.new( './cache' )

gems = read_csv( './collection/cocos.csv' )
puts "  #{gems.size} record(s)"

versions = cache.read_versions( gems: gems )
puts "   #{versions.size} record(s)"

timeline = Gems::Timeline.new( versions,
                               title: 'Ruby Code Commons (COCOS) Timeline' )
timeline.save( "./collection/cocos/README.md" )
```

That's it.


See
[Thomas Leitner's Timeline](samples/gems_gettalong),
[Jan Lelis's Timeline](samples/gems_janlelis),
[Ruby Code Commons (COCOS) Timeline](samples/gems_cocos), and some more
for some real-world timeline samples.


