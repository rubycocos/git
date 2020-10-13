module Hubba


class ReportSummary < Report

def build
## create a (summary report)
##
##  add stars, last_updates, etc.
##  org description etc??

## note: orgs is orgs+users e.g. geraldb, yorobot etc
buf = String.new('')
buf << "# #{@stats.repos.size} repos @ #{@stats.orgs.size} orgs\n"
buf << "\n"


@stats.orgs.each do |org|
  name  = org[0]
  repos = org[1]
  buf << "### #{name} _(#{repos.size})_\n"
  buf << "\n"

  ### add stats for repos
  entries = []
  repos.each do |repo|
    entries << "**#{repo.name}** ★#{repo.stats.stars} (#{repo.stats.size} kb)"
  end

  buf << entries.join( ' · ' )   ## use interpunct? - was: • (bullet)
  buf << "\n"
  buf << "\n"
end

buf
end  # method build
end  # class ReportSummary

end # module Hubba