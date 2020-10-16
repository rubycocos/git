module Hubba


class ReportTrafficPages < Report   ## todo/check: rename to TrafficPaths - why? why not?

def build

## note: orgs is orgs+users e.g. geraldb, yorobot etc
buf = String.new('')
buf << "# Traffic Pages"
buf << " - #{@stats.repos.size} Repos @ #{@stats.orgs.size} Orgs"
buf << "\n\n"

buf << "popular pages over the last 14 days - page views / unique\n"
buf << "\n"


### step 1: filter all repos w/o traffic summary
repos = @stats.repos.select do |repo|
  traffic = repo.stats.traffic || {}
  summary = traffic['summary'] || {}

  paths = summary['paths']
  res = paths && paths.size > 0  ## return true if present and non-empty array too
  puts "    no traffic/summary/paths - skipping >#{repo.full_name}<..."   unless res
  res
end

## collect all paths entries
lines = []
repos.each do |repo|
  summary = repo.stats.traffic['summary']
  # e.g.
  # "paths": [
  #  {
  #    "path": "/csvreader/csvreader",
  #    "title": "GitHub - csvreader/csvreader: csvreader library / gem - read tabular data in ...",
  #    "count": 33,
  #    "uniques": 25
  #  },

  paths  = summary['paths']
  if paths
    ### clean (normalize) paths
    paths.each do |line|
      # "/csvreader/csvreader" =>
      #   csvreader/csvreader
      path = line['path'][1..-1]  ## cut of leading slash (/)

      ## /blob/master, /tree/master, /master
      path = path.sub( %r{/blob/(master|gh-pages)(?=/)}, '' )
      path = path.sub( %r{/tree/(master|gh-pages)(?=/)}, '' )
      path = path.sub( %r{/(master|gh-pages)(?=/|$)}, '' )   ## ending in master (e.g. /search/master)

      line['path'] = path
    end
    lines += paths
  end
end


## sort by 1) count
##         2) uniques
##         3) a-z path
lines = lines.sort do |l,r|
  res =   r['count']   <=> l['count']
  res =   r['uniques'] <=> l['uniques']  if res == 0
  res =   l['path']    <=> r['path']     if res == 0
  res
end


lines_by_path = lines.group_by { |line|
                                 parts = line['path'].split( '/' )
                                 parts[0]
                               }
                         .sort { |(lpath,llines), (rpath,rlines)|
                                 lcount = llines.reduce(0) {|sum,line| sum+line['count'] }
                                 rcount = rlines.reduce(0) {|sum,line| sum+line['count'] }
                                 res = rcount      <=> lcount
                                 res = llines.size <=> rlines.size if res == 0
                                 res = lpath       <=> rpath       if res == 0
                                 res
                              }
                        .to_h  ## convert back to hash


### start with summary
##  limit to top 10 or top 20 - why? why not?
lines_by_path.each_with_index do |(path, lines),i|
  count   = lines.reduce(0) {|sum,line| sum+line['count']}
  buf << "#{i+1}. **#{path}** #{count}   _(#{lines.size})_"
  buf << "\n"
end

buf << "<!-- break -->\n"   ## markdown hack: add a list end marker
buf << "\n\n"



buf << "Details:"
buf << "\n\n"

lines_by_path.each_with_index do |(path, lines),i|
  count   = lines.reduce(0) {|sum,line| sum+line['count']}
  buf << "#{i+1}. **#{path}** #{count}   _(#{lines.size})_"
  buf << "\n"

  ### todo - sort by count / uniques !!
  lines.each do |line|
    ## e.g. convert
    ##        openfootball/football.json/tree/master/2020  =>
    ##                     football.json/tree/master/2020
    parts = line['path'].split( '/' )
    path =  parts[1..-1].join( '/' )

    ## note: sublist indent four (4) spaces
    buf << "    - #{line['count']} / #{line['uniques']} -- #{path}"
    buf << "\n"
  end
end

buf << "<!-- break -->\n"   ## markdown hack: add a list end marker
buf << "\n\n"


### all page paths
buf << "All pages:"
buf << "\n\n"

lines.each_with_index do |line,i|
  buf <<  "#{i+1}. #{line['count']} / #{line['uniques']} -- #{line['path']}"
  buf <<  "\n"
end
buf << "<!-- break -->\n"   ## markdown hack: add a list end marker
buf << "\n\n"


buf
end  # method build




end  # class ReportTrafficPages


end  # module Hubba
