module Hubba


class ReportTopics < Report

def build

## note: orgs is orgs+users e.g. geraldb, yorobot etc
buf = String.new('')
buf << "# Topics"
buf << " - #{@stats.repos.size} Repos @ #{@stats.orgs.size} Orgs"
buf << "\n\n"


topics = {}   ## collect all topics with refs to repos

@stats.repos.each do |repo|
  repo.stats.topics.each do |topic|
    repos = topics[ topic ] ||= []
    repos << repo
  end
end

topics = topics.sort {|(ltopic,_),(rtopic,_)|
                       ltopic <=> rtopic   ## sort topic by a-z
                     }
               .to_h    # convert back to hash (from array)


topics.each do |topic,repos|
  buf << "`#{topic}` _(#{repos.size})_\n"
end
buf << "\n"


topics.each do |topic,repos|
  buf << "## `#{topic}` _(#{repos.size})_\n"

  buf << repos.map {|repo| repo.full_name }.join( ' · ' )   ## use interpunct? - was: • (bullet)
  buf << "\n\n"
end


buf
end  # method build
end  # class ReportTopics

end # module Hubba