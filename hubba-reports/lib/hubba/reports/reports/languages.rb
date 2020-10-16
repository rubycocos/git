module Hubba


class ReportLanguages < Report

def build

## note: orgs is orgs+users e.g. geraldb, yorobot etc
buf = String.new('')
buf << "# Languages"
buf << " - #{@stats.repos.size} Repos @ #{@stats.orgs.size} Orgs"
buf << "\n\n"


buf << "language lines in byte / language used in repos (count)"
buf << "\n\n"


### note: skip repos WITHOUT languages stats e.g. empty hash {}
repos = @stats.repos.select do |repo|
  langs = repo.stats.languages
  res   = langs && langs.size > 0  ## return true if present and non-empty hash too
  puts "    no languages - skipping >#{repo.full_name}<..."   unless res
  res
end


## collect all langs with refs to repos
##  note/warn: do NOT use langs as local variable - will RESET this langs here!!!
langs = {}

repos.each do |repo|
  puts "#{repo.full_name}:"
  pp repo.stats.languages
  repo.stats.languages.each do |lang,bytes|
     # note: keep using all string (NOT symbol) keys - why? why not?
     line = langs[ lang ] ||= { 'count' => 0, 'bytes' => 0 }
     line[ 'count' ] += 1
     line[ 'bytes' ] += bytes
  end
end

langs_by_bytes = langs.sort {|(llang,lline),(rlang,rline)|
                       res = rline['bytes'] <=> lline['bytes']
                       res = llang <=> rlang   if res == 0
                       res
                     }
               .to_h    # convert back to hash (from array)


bytes_total = langs.reduce(0) {|sum,(lang,line)| sum+line['bytes'] }
langs_by_bytes.each_with_index do |(lang, line),i|
  bytes = line['bytes']
  percent = Float(100*bytes)/Float(bytes_total)

  buf << "#{i+1}. "
  buf << "#{bytes} (#{('%2.2f' % percent)}%) "
  buf << "**#{lang}** "
  buf << "_(#{line['count']})_"
  buf << "\n"
end
buf << "<!-- break -->\n"   ## markdown hack: add a list end marker
buf << "\n\n"


buf << "Languages used in repos (count):"
buf << "\n\n"


langs_by_count = langs.sort {|(llang,lline),(rlang,rline)|
                       res = rline['count'] <=> lline['count']
                       res = llang <=> rlang   if res == 0
                       res
                     }
               .to_h    # convert back to hash (from array)


count_total =  repos.size   # note: use (filtered) repos for count total
langs_by_count.each_with_index do |(lang, line),i|
  count = line['count']
  percent = Float(100*count)/Float(count_total)

  buf << "#{i+1}. "
  buf << "#{count} (#{('%2.2f' % percent)}%) "
  buf << "**#{lang}** "
  buf << "(#{line['bytes']} bytes)"
  buf << "\n"
end
buf << "<!-- break -->\n"   ## markdown hack: add a list end marker
buf << "\n\n"


buf
end  # method build
end  # class ReportLanguages

end # module Hubba