module Hubba


class ReportTraffic < Report

def build


## note: orgs is orgs+users e.g. geraldb, yorobot etc
buf = String.new('')
buf << "# Traffic"
buf << " - #{@stats.repos.size} Repos @ #{@stats.orgs.size} Orgs"
buf << "\n\n"

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


repos_by_org = repos.group_by { |repo|
                                 #  csvreader/csvreader" =>
                                 #   csvreader
                                 repo.owner   # user username / org | login
                               }
                         .sort { |(lowner,lrepos), (rowner,rrepos)|
                                 lviews  = lrepos.reduce(0) {|sum,repo| sum+repo.stats.traffic['summary']['views']['count'] }
                                 rviews  = rrepos.reduce(0) {|sum,repo| sum+repo.stats.traffic['summary']['views']['count'] }
                                 lclones = lrepos.reduce(0) {|sum,repo| sum+repo.stats.traffic['summary']['clones']['count'] }
                                 rclones = rrepos.reduce(0) {|sum,repo| sum+repo.stats.traffic['summary']['clones']['count'] }
                                 res = rviews      <=> lviews
                                 res = rclones     <=> lclones     if res == 0
                                 res = lrepos.size <=> rrepos.size if res == 0
                                 res = lowner      <=> rowner      if res == 0
                                 res
                              }
                        .to_h  ## convert back to hash


### start with summary
##  limit to top 10 or top 20 - why? why not?
repos_by_org.each_with_index do |(owner, repos),i|
  views  = repos.reduce(0) {|sum,repo| sum+repo.stats.traffic['summary']['views']['count'] }
  clones = repos.reduce(0) {|sum,repo| sum+repo.stats.traffic['summary']['clones']['count'] }

  buf << "#{i+1}. **#{owner}** views: #{views}, clones: #{clones}  _(#{repos.size})_"
  buf << "\n"
end

buf << "<!-- break -->\n"   ## markdown hack: add a list end marker
buf << "\n\n"



buf << "Details:"   ## markdown hack: add a list end marker
buf << "\n\n"

repos_by_org.each_with_index do |(owner, repos),i|
  views  = repos.reduce(0) {|sum,repo| sum+repo.stats.traffic['summary']['views']['count'] }
  clones = repos.reduce(0) {|sum,repo| sum+repo.stats.traffic['summary']['clones']['count'] }

  buf << "#{i+1}. **#{owner}** views: #{views}, clones: #{clones}  _(#{repos.size})_"
  buf << "\n"

  ### todo - sort by count / uniques !!
  repos.each do |repo|

    summary = repo.stats.traffic['summary']

    ## note: sublist indent four (4) spaces
    buf << "    - #{repo.name} -- "
    buf << " views: #{summary['views']['count']} / #{summary['views']['uniques']} - "
    buf << " clones: #{summary['clones']['count']} / #{summary['clones']['uniques']}"
    buf << "\n"
  end
end

buf << "<!-- break -->\n"   ## markdown hack: add a list end marker
buf << "\n\n"



### all page paths
buf << "All repos:"
buf << "\n\n"


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


end # module Hubba