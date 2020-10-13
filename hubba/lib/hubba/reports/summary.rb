module Hubba


class ReportSummary < Report

def build
## create a (summary report)
##
##  add stars, last_updates, etc.
##  org description etc??

## note: orgs is orgs+users e.g. geraldb, yorobot etc
buf = String.new('')
buf << "# Summary"
buf << " - #{@stats.repos.size} Repos @ #{@stats.orgs.size} Orgs"
buf << "\n\n"


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
  buf << "\n\n"
end

buf
end  # method build
end  # class ReportSummary

end # module Hubba