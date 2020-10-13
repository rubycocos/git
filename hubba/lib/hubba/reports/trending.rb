module Hubba

class ReportTrending < Report

def build

## note: orgs is orgs+users e.g. geraldb, yorobot etc
buf = String.new('')
buf << "# #{@stats.repos.size} repos @ #{@stats.orgs.size} orgs\n"
buf << "\n"

###
## todo:
##   use calc per month (days: 30)
##   per week is too optimistic (e.g. less than one star/week e.g. 0.6 or something)

repos = @stats.repos.sort do |l,r|
  ## note: use reverse sort (right,left) - e.g. most stars first
  ## r[:stars] <=> l[:stars]

  ## sort by created_at (use julian days)
  ## r[:created_at].to_date.jd <=> l[:created_at].to_date.jd

  res = r.diff <=> l.diff
  res = r.stats.stars <=> l.stats.stars  if res == 0
  res = r.stats.created.jd <=> l.stats.created.jd  if res == 0
  res
end


## pp repos


repos.each_with_index do |repo,i|
  if repo.diff == 0
    buf << "-  -/- "
  else
    buf << "- #{repo.diff}/month "
  end

  buf <<  " ★#{repo.stats.stars} **#{repo.full_name}** (#{repo.stats.size} kb) - "
  buf <<  "#{repo.stats.history_str}\n"
end


buf
end  # method build
end  # class ReportTrending

end  # module Hubba