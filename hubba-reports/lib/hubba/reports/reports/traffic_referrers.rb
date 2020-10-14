module Hubba


class ReportTrafficReferrers < Report

def build

## note: orgs is orgs+users e.g. geraldb, yorobot etc
buf = String.new('')
buf << "# Traffic Referrers"
buf << " - #{@stats.repos.size} Repos @ #{@stats.orgs.size} Orgs"
buf << "\n\n"


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
  buf << "#{i+1}. **#{referrer}** #{count}  _(#{lines.size})_"
  buf << "\n"

  ### todo - sort by count / uniques !!
  lines.each do |line|
    ## note: sublist indent four (4) spaces
    buf << "    - #{line['count']} / #{line['uniques']} -- #{line['path']}"
    buf << "\n"
  end
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

end  # module Hubba
