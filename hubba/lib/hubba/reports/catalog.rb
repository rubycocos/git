module Hubba


class ReportCatalog < Report

def build

## note: orgs is orgs+users e.g. geraldb, yorobot etc
buf = String.new('')
buf << "# Catalog"
buf << " - #{@stats.repos.size} Repos @ #{@stats.orgs.size} Orgs"
buf << "\n\n"


@stats.orgs.each do |org|
  name  = org[0]
  repos = org[1]
  buf << "### #{name} _(#{repos.size})_\n"
  buf << "\n"

  ### add stats for repos
  repos.each do |repo|

    buf << "**#{repo.name}** ★#{repo.stats.stars} (#{repo.stats.size} kb)"
    buf << "  <br>\n"

    buf << "_#{repo.stats.description}_"

    if repo.stats.topics && repo.stats.topics.size > 0
      buf << "  <br>\n"
      ## wrap in backtip (verbatim code)
      buf << repo.stats.topics.map {|topic| "`#{topic}`" }.join( ' · ' )  ## use interpunct? - was: • (bullet)
    end
    buf << "\n\n"
  end

  buf << "\n"
end

buf
end  # method build
end  # class ReportCatalog

end # module Hubba