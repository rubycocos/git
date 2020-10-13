module Hubba


class ReportTimeline < Report

def build
## create a (timeline report)

## note: orgs is orgs+users e.g. geraldb, yorobot etc
buf = String.new('')
buf << "# #{@stats.repos.size} repos @ #{@stats.orgs.size} orgs\n"
buf << "\n"


repos = @stats.repos.sort do |l,r|
  ## note: use reverse sort (right,left) - e.g. most stars first
  ## r[:stars] <=> l[:stars]

  ## sort by created_at (use julian days)
  r.stats.created.jd <=> l.stats.created.jd
end


## pp repos


last_year  = -1
last_month = -1

repos.each_with_index do |repo,i|
  year       = repo.stats.created.year
  month      = repo.stats.created.month

  if last_year != year
    buf << "\n## #{year}\n\n"
  end

  if last_month != month
    buf << "\n### #{month}\n\n"
  end

  last_year  = year
  last_month = month

  buf << "- #{repo.stats.created_at.strftime('%Y-%m-%d')} ★#{repo.stats.stars} **#{repo.full_name}** (#{repo.stats.size} kb)\n"
end

buf
end  # method build
end  # class ReportTimeline

end  # module Hubba
