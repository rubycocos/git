module Hubba


class ReportTraffic < Report

def build


## note: orgs is orgs+users e.g. geraldb, yorobot etc
buf = String.new('')
buf << "# #{@stats.repos.size} repos @ #{@stats.orgs.size} orgs\n"
buf << "\n"

buf << "traffic over the last 14 days - page views / unique, clones / unique\n"
buf << "\n"


### step 1: filter all repos w/o traffic summary
repos = @stats.repos.select do |repo|
  traffic = repo.stats.traffic || {}
  summary = traffic['summary'] || {}

  res = summary['views'] && summary['clones']  ## return true if present
  puts "    no traffic/summary/{views,clones} - skipping >#{repo.full_name}<..."   unless res
  res
end


repos = repos.sort do |l,r|
  lsummary = l.stats.traffic['summary']
  rsummary = r.stats.traffic['summary']

  ## note: use reverse sort (right,left) - e.g. most page views first
  res = rsummary['views']['count']    <=> lsummary['views']['count']
  res = rsummary['views']['uniques']  <=> lsummary['views']['uniques']    if res == 0
  res = rsummary['clones']['count']   <=> lsummary['clones']['count']     if res == 0
  res = rsummary['clones']['uniques'] <=> lsummary['clones']['uniques']   if res == 0
  res = l.full_name                   <=> r.full_name                     if res == 0
  res
end

## pp repos

repos.each_with_index do |repo,i|
  summary = repo.stats.traffic['summary']

  buf << "#{i+1}.  **#{repo.full_name}** -- "
  buf << " views: #{summary['views']['count']} / #{summary['views']['uniques']} - "
  buf << " clones: #{summary['clones']['count']} / #{summary['clones']['uniques']}"
  buf << "\n"
end
buf << "<!-- break -->\n"   ## markdown hack: add a list end marker
buf << "\n\n"


buf
end  # method build
end  # class ReportTraffic




class ReportTrafficPages < Report   ## todo/check: rename to TrafficPaths - why? why not?

def build

## note: orgs is orgs+users e.g. geraldb, yorobot etc
buf = String.new('')
buf << "# #{@stats.repos.size} repos @ #{@stats.orgs.size} orgs\n"
buf << "\n"

buf << "popular pages over the last 14 days - page views / unique\n"
buf << "\n"


### step 1: filter all repos w/o traffic summary
repos = @stats.repos.select do |repo|
  traffic = repo.stats.traffic || {}
  summary = traffic['summary'] || {}

  paths = summary['paths']
  res = paths && paths.size > 0  ## return true if present and non-empty array too
  puts "    no traffic/summary/paths - skipping >#{repo.full_name}<..."   unless res
  res
end

## collect all paths entries
lines = []
repos.each do |repo|
  summary = repo.stats.traffic['summary']
  # e.g.
  # "paths": [
  #  {
  #    "path": "/csvreader/csvreader",
  #    "title": "GitHub - csvreader/csvreader: csvreader library / gem - read tabular data in ...",
  #    "count": 33,
  #    "uniques": 25
  #  },

  paths  = summary['paths']
  lines += paths  if paths
end

## sort by 1) count
##         2) uniques
##         3) a-z path
lines = lines.sort do |l,r|
  res =   r['count']   <=> l['count']
  res =   r['uniques'] <=> l['uniques']  if res == 0
  res =   l['path']    <=> r['path']     if res == 0
  res
end



lines.each_with_index do |line,i|
  buf <<  "#{i+1}. #{line['count']} / #{line['uniques']} -- #{line['path']}"
  buf <<  "\n"
end
buf << "<!-- break -->\n"   ## markdown hack: add a list end marker
buf << "\n\n"


buf
end  # method build
end  # class ReportTrafficPages




class ReportTrafficReferrers < Report

def build

## note: orgs is orgs+users e.g. geraldb, yorobot etc
buf = String.new('')
buf << "# #{@stats.repos.size} repos @ #{@stats.orgs.size} orgs\n"
buf << "\n"


buf << "popular referrer sources over the last 14 days - page views / unique\n"
buf << "\n"


### step 1: filter all repos w/o traffic summary
repos = @stats.repos.select do |repo|
  traffic = repo.stats.traffic || {}
  summary = traffic['summary'] || {}

  referrers = summary['referrers']
  res = referrers && referrers.size > 0  ## return true if present and non-empty array too
  puts "    no traffic/summary/referrers - skipping >#{repo.full_name}<..."   unless res
  res
end

## collect all referrers entries
lines = []
repos.each do |repo|
  summary = repo.stats.traffic['summary']
  # e.g.
  # "referrers" =>
  #   [{"referrer"=>"github.com", "count"=>327, "uniques"=>198},
  #    {"referrer"=>"openfootball.github.io", "count"=>71, "uniques"=>54},
  #    {"referrer"=>"Google", "count"=>5, "uniques"=>5},
  #    {"referrer"=>"reddit.com", "count"=>4, "uniques"=>4}]


  referrers  = summary['referrers']
  if referrers
    lines += referrers.map do |referrer|
                # note: return a new copy with (repo) path added
                referrer.merge( 'path' => repo.full_name )
             end
  end
end



## sort by 1) count
##         2) uniques
##         3) a-z referrer
##         4) a-z path
lines = lines.sort do |l,r|
  res =   r['count']    <=> l['count']
  res =   r['uniques']  <=> l['uniques']     if res == 0
  res =   l['referrer'] <=> r['referrer']    if res == 0
  res =   l['path']     <=> r['path']        if res == 0
  res
end


lines_by_referrer = lines.group_by { |line| line['referrer'] }
                         .sort { |(lreferrer,llines),
                                  (rreferrer,rlines)|
                                    lcount = llines.reduce(0) {|sum,line| sum+line['count'] }
                                    rcount = rlines.reduce(0) {|sum,line| sum+line['count'] }
                                   res =  rcount <=> lcount
                                   res = llines.size <=> rlines.size if res == 0
                                   res = lreferrer   <=> rreferrer   if res == 0
                                   res
                               }
                          .to_h  ## convert back to hash


lines_by_referrer.each_with_index do |(referrer, lines),i|
  count   = lines.reduce(0) {|sum,line| sum+line['count']}
  uniques = lines.reduce(0) {|sum,line| sum+line['uniques']}
  buf << "#{i+1}. **#{referrer}** #{count} / #{uniques}  _(#{lines.size})_:"
  buf << "\n"

  ### todo - sort by count / uniques !!
  lines.each do |line|
    buf << "    - #{line['count']} / #{line['uniques']} -- #{line['path']}"
    buf << "\n"
  end
  buf << "\n"
end

buf << "<!-- break -->\n"   ## markdown hack: add a list end marker
buf << "\n\n"


### all referrer sources / records by page views
buf << "All referrers:"
buf << "\n\n"

lines.each_with_index do |line,i|
  buf <<  "- #{line['referrer']} -- #{line['count']} / #{line['uniques']} -- #{line['path']}"
  buf <<  "\n"
end

buf << "<!-- break -->\n"   ## markdown hack: add a list end marker
buf << "\n\n"



buf
end  # method build
end  # class ReportTrafficReferrers




end # module Hubba