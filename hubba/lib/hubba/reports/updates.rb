module Hubba


class ReportUpdates < Report

def build

## note: orgs is orgs+users e.g. geraldb, yorobot etc
buf = String.new('')
buf << "# Updates"
buf << " - #{@stats.repos.size} Repos @ #{@stats.orgs.size} Orgs\n"
buf << "\n\n"

repos = @stats.repos.sort do |l,r|
  r.stats.committed.jd <=> l.stats.committed.jd
end

## pp repos


buf << "committed / pushed / updated / created\n\n"

today = Date.today

repos.each_with_index do |repo,i|

  days_ago = today.jd - repo.stats.committed.jd

  diff1 = repo.stats.committed.jd - repo.stats.pushed.jd
  diff2 = repo.stats.committed.jd - repo.stats.updated.jd
  diff3 = repo.stats.pushed.jd    - repo.stats.updated.jd

  buf <<  "- (#{days_ago}d) **#{repo.full_name}** ★#{repo.stats.stars} - "
  buf <<  "#{repo.stats.committed} "
  buf <<  "("
  buf <<  (diff1==0 ? '=' : "#{diff1}d")
  buf <<  "/"
  buf <<  (diff2==0 ? '=' : "#{diff2}d")
  buf <<  ")"
  buf <<  " / "
  buf <<  "#{repo.stats.pushed} "
  buf <<  "("
  buf <<  (diff3==0 ? '=' : "#{diff3}d")
  buf <<  ")"
  buf <<  " / "
  buf <<  "#{repo.stats.updated} / "
  buf <<  "#{repo.stats.created} - "
  buf <<  "‹#{repo.stats.last_commit_message}›"
  buf <<  " (#{repo.stats.size} kb)"
  buf <<  "\n"
end
buf << "<!-- break -->\n"   ## markdown hack: add a list end marker
buf << "\n\n"


buf
end  # method build
end  # class ReportUpdates

end  # module Hubba