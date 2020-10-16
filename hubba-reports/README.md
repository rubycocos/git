# hubba-reports

hubba-reports gem - auto-generate github statistics / analytics reports from github api data (stars, timeline, traffic, top pages, top referrers, etc.)

* home  :: [github.com/rubycoco/git](https://github.com/rubycoco/git)
* bugs  :: [github.com/rubycoco/git/issues](https://github.com/rubycoco/git/issues)
* gem   :: [rubygems.org/gems/hubba-reports](https://rubygems.org/gems/hubba-reports)
* rdoc  :: [rubydoc.info/gems/hubba-reports](http://rubydoc.info/gems/hubba-reports)



## Usage

### Step 0: Data, Data, Data

See the [hubba gem](https://github.com/rubycoco/git/tree/master/hubba) on how to collect github data (daily, weekly, monthly, etc.).



###  Statistics / reports


Hubba has about a dozen built-in reports (for now):

- `ReportSummary`  - A-Z list of your repos by orgs with stars and size in kb
- `ReportStars`    - your repos ranked by stars
- `ReportTimeline` - your repos in reverse chronological order by creation
- `ReportUpdates`  - your repos in reverse chronological order by last commit
- ...

Look into the [/reports](https://github.com/rubycoco/git/tree/master/hubba-reports/lib/hubba/reports/reports)
directory for all reports and, yes, you can - on how to code your very own.


#### Generate statistic / reports

If you only generate a single built-in report, use:

``` ruby
require 'hubba/reports'

report = Hubba::ReportSummary.new( './repos.yml' )
report.save( './SUMMARY.md' )
```


If you generate more reports, (re)use the in-memory statistics cache / object:

``` ruby
stats = Hubba.stats( './repos.yml' )

report = Hubba::ReportSummary.new( stats )
report.save( './SUMMARY.md' )

report = Hubba::ReportStars.new( stats )
report.save( './STARS.md' )

report = Hubba::ReportTimeline.new( stats )
report.save( './TIMELINE.md' )

report = Hubba::ReportUpdates.new( stats )
report.save( './UPDATES.md' )

# ...
```


### Report Examples

#### Report Example - Summary

A-Z list of your repos by orgs with stars and size in kb.
Results in:

---

> ### geraldb _(11)_
>
> **austria** ★1 (552 kb) · **catalog** ★3 (156 kb) · **chelitas** ★1 (168 kb) · **geraldb.github.io** ★1 (520 kb) · **logos** ★1 (363 kb) · **sandbox** ★2 (529 kb) · **talks** ★200 (16203 kb) · **web-proxy-win** ★8 (152 kb) · **webcomponents** ★1 (164 kb) · **webpub-reader** ★3 (11 kb) · **wine.db.tools** ★1 (252 kb)
>
> ...

---

(Live Example - [`SUMMARY.md`](https://github.com/yorobot/backup/blob/master/SUMMARY.md))


#### Report Example - Stars

Your repos ranked by stars. Results in:

---

> 1. ★2936 **openblockchains/awesome-blockchains** (2514 kb)
> 2. ★851 **planetjekyll/awesome-jekyll-plugins** (148 kb)
> 3. ★604 **factbook/factbook.json** (7355 kb)
> 4. ★593 **openfootball/football.json** (2135 kb)
> 5. ★570 **openmundi/world.db** (1088 kb)
> 6. ★552 **openblockchains/programming-blockchains** (552 kb)
> 7. ★547 **mundimark/awesome-markdown** (83 kb)
> 8. ★532 **planetjekyll/awesome-jekyll** (110 kb)
> 9. ★489 **cryptocopycats/awesome-cryptokitties** (4154 kb)
> 10. ★445 **openfootball/world-cup** (638 kb)
>
> ...

---

(Live Example: [`STARS.md`](https://github.com/yorobot/backup/blob/master/STARS.md))


#### Report Example - Timeline

Your repos in reverse chronological order by creation.
Results in:

---

> ## 2020
>
> ### 9
>
> - 2020-09-18 ★1 **yorobot/workflow** (83 kb)
>
> ### 6
>
> - 2020-06-27 ★2 **yorobot/sport.db.more** (80 kb)
> - 2020-06-24 ★1 **yorobot/stage** (554 kb)
> - 2020-06-11 ★1 **yorobot/cache.csv** (336 kb)
>
> ...

---

(Live Example: [`TIMELINE.md`](https://github.com/yorobot/backup/blob/master/TIMELINE.md))



#### Report Example - Updates

Your repos in reverse chronological order by last commit. Results in:

---

> committed / pushed / updated / created
>
> - (1d) **yorobot/backup** ★4 - 2020-10-08 (=/=) / 2020-10-08 (=) / 2020-10-08 / 2015-04-04 - ‹› (1595 kb)
> - (1d) **yorobot/logs** ★1 - 2020-10-08 (=/=) / 2020-10-08 (=) / 2020-10-08 / 2016-09-13 - ‹› (172 kb)
> - (1d) **rubycoco/git** ★9 - 2020-10-08 (=/=) / 2020-10-08 (=) / 2020-10-08 / 2015-11-16 - ‹› (88 kb)
> - (1d) **openfootball/football.json** ★593 - 2020-10-08 (=/=) / 2020-10-08 (=) / 2020-10-08 / 2015-09-17 - ‹› (2135 kb)
> - (2d) **yorobot/workflow** ★1 - 2020-10-07 (=/=) / 2020-10-07 (=) / 2020-10-07 / 2020-09-18 - ‹› (83 kb)
> - (2d) **rubycoco/webclient** ★5 - 2020-10-07 (=/=) / 2020-10-07 (=) / 2020-10-07 / 2012-06-02 - ‹› (39 kb)
> - (3d) **footballcsv/belgium** ★1 - 2020-10-06 (=/=) / 2020-10-06 (=) / 2020-10-06 / 2014-07-25 - ‹› (314 kb)
> - (3d) **footballcsv/england** ★105 - 2020-10-06 (=/=) / 2020-10-06 (=) / 2020-10-06 / 2014-07-23 - ‹› (8666 kb)
> - (3d) **footballcsv/austria** ★1 - 2020-10-06 (=/=) / 2020-10-06 (=) / 2020-10-06 / 2018-07-16 - ‹› (91 kb)
> - (3d) **footballcsv/espana** ★15 - 2020-10-06 (=/=) / 2020-10-06 (=) / 2020-10-06 / 2014-07-23 - ‹› (1107 kb)
> - (3d) **footballcsv/deutschland** ★5 - 2020-10-06 (=/=) / 2020-10-06 (=) / 2020-10-06 / 2014-07-25 - ‹› (1343 kb)
>
> ...

---

(Live Example: [`UPDATES.md`](https://github.com/yorobot/backup/blob/master/UPDATES.md))



That's all for now.



## Installation

Use

    gem install hubba-reports

or add the gem to your Gemfile

    gem 'hubba-reports'


## License

The `hubba` scripts are dedicated to the public domain.
Use it as you please with no restrictions whatsoever.
