


## Usage


Let's build a gem timeline
for [Thomas Leitner, Austria also known as `gettalong`](https://rubygems.org/profiles/gettalong)
with 24 published gems (as of 2023).

Note:  Yes, you can. Replace the `gettalong`  rubygems id / login with your own to build your very own timeline.


``` ruby
require 'gemverse'

## step 1: get gems & versions via the rubygems api calls
cache = Gems::Cache.new( './gems' )

gems = Gems.find_by( owner: 'gettalong' )
puts "  #{gems.size} record(s)"

## bonus: save gems in a "flat" tabular datafile using the comma-separated values (.csv) format
gems.export( "./sandbox/gems_gettalong.csv" )

## fetch all gem versions and (auto-save)
##   in a "flat" tabular datafile (e.g. <gem>/versions.csv)
##    using the comma-spearated values (.csv) format
##    in the cache directory
cache.update_versions( gems: gems )


## step 2: read versions from cache and build reports / timeline
versions = cache.read_versions( gems: gems )
puts "   #{versions.size} record(s)"

timeline = Gems::Timeline.new( versions )
timeline.save( "./samples/gems_gettalong/README.md" )
```


That's it.



Tip:  You can build "custom" timeline reports
and filter / select the gems to include as you like.
Let's (re)build the timeline for all ruby cocos (code commons)
gems.

``` ruby
require 'gemverse'

cache = Gems::Cache.new( './gems' )

gems = read_csv( './sandbox/gems_cocos.csv' )

## step 2: read versions from cache and build reports / timeline
versions = cache.read_versions( gems: gems )
puts "   #{versions.size} record(s)"

timeline = Gems::Timeline.new( versions )
timeline.save( "./samples/gems_cocos/README.md" )
```

That's it.


See
[samples/gems_gettalong](samples/gems_gettalong),
[samples/gems_janlelis](samples/gems_janlelis),
[samples/gems_cocos](samples/gems_cocos), and some more
for some real-world timeline samples.


