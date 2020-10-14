module Hubba


class ReportSize < Report

def build

##  add stars, last_updates, etc.
##  org description etc??

## note: orgs is orgs+users e.g. geraldb, yorobot etc
buf = String.new('')
buf << "# Size in KB"
buf << " - #{@stats.repos.size} Repos @ #{@stats.orgs.size} Orgs"
buf << "\n\n"


repos = @stats.repos.sort do |l,r|
  ## note: use reverse sort (right,left) - e.g. most stars first
  res = r.stats.size <=> l.stats.size
  res = l.full_name  <=> r.full_name    if res == 0
  res
end


repos.each_with_index do |repo,i|
  buf << "#{i+1}. #{repo.stats.size} kb - **#{repo.full_name}**\n"
end
buf << "<!-- break -->\n"   ## markdown hack: add a list end marker
buf << "\n\n"


buf
end  # method build
end  # class ReportSize


end  # module Hubba
