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
  puts "  no traffic/summary/{views,clones} - skipping >#{repo.full_name}<..."   unless res
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

  buf << "#{i+1}.  **#{repo.full_name}** "
  buf << " views: #{summary['views']['count']} / #{summary['views']['uniques']} - "
  buf << " clones: #{summary['clones']['count']} / #{summary['clones']['uniques']}"
  buf << "\n"
end

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
  puts "  no traffic/summary/paths - skipping >#{repo.full_name}<..."   unless res
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
  buf <<  "- #{line['count']} / #{line['uniques']} -- #{line['path']}"
  buf <<  "\n"
end

buf
end  # method build
end  # class ReportTrafficPages



end # module Hubba