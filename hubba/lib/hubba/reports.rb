module Hubba


class Report
  def initialize( stats_or_hash_or_path=Hubba.stats )
    ## puts "[debug] Report#initialize:"
    ## pp  stats_or_hash_or_path   if stats_or_hash_or_path.is_a?( String )

    @stats = if stats_or_hash_or_path.is_a?( String ) ||
                stats_or_hash_or_path.is_a?( Hash )
                  hash_or_path = stats_or_hash_or_path
                  Hubba.stats( hash_or_path )
             else
                  stats_or_hash_or_path  ## assume Summary/Stats - todo/fix: double check!!!
             end
  end

  def save( path )
    buf = build
    puts "writing report >#{path}< ..."
    File.open( path, "w:utf-8" ) do |f|
      f.write( buf )
    end
  end
end  ## class Report



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



class ReportUpdates < Report

def build

## note: orgs is orgs+users e.g. geraldb, yorobot etc
buf = String.new('')
buf << "# #{@stats.repos.size} repos @ #{@stats.orgs.size} orgs\n"
buf << "\n"

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


end # module Hubba