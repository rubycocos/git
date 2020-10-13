module Hubba


class ReportStars < Report

def build

##  add stars, last_updates, etc.
##  org description etc??

## note: orgs is orgs+users e.g. geraldb, yorobot etc
buf = String.new('')
buf << "# #{@stats.repos.size} repos @ #{@stats.orgs.size} orgs\n"
buf << "\n"


repos = @stats.repos.sort do |l,r|
  ## note: use reverse sort (right,left) - e.g. most stars first
  r.stats.stars <=> l.stats.stars
end

## pp repos

repos.each_with_index do |repo,i|
  buf << "#{i+1}. ★#{repo.stats.stars} **#{repo.full_name}** (#{repo.stats.size} kb)\n"
end
buf << "<!-- break -->\n"   ## markdown hack: add a list end marker
buf << "\n\n"


buf
end  # method build
end  # class ReportStars


end  # module Hubba
