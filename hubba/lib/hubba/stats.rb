module Hubba

  ####
  #  keep track of repo stats over time (with history hash)

  class Stats     ## todo/check: rename to GithubRepoStats or RepoStats - why? why not?

    def initialize( full_name )
      @data = {}
      @data['full_name'] = full_name  # e.g. poole/hyde etc.

      @cache = {}  ## keep a lookup cache - why? why not?
    end


##################
## update
def update_traffic( clones:    nil,
                    views:     nil,
                    paths:     nil,
                    referrers: nil )

  traffic = @data[ 'traffic' ] ||= {}

  summary = traffic['summary'] ||= {}
  history = traffic['history'] ||= {}


  if views
    raise ArgumentError, "Github::Resource expected; got #{views.class.name}"    unless views.is_a?( Github::Resource )
=begin
{"count"=>1526,
 "uniques"=>287,
 "views"=>
[{"timestamp"=>"2020-09-27T00:00:00Z", "count"=>52, "uniques"=>13},
 {"timestamp"=>"2020-09-28T00:00:00Z", "count"=>108, "uniques"=>28},
 ...
]}>
=end

    ## keep lastest (summary) record of last two weeks (14 days)
    summary['views'] = { 'count'   => views.data['count'],
                         'uniques' => views.data['uniques'] }

    ## update history / day-by-day items / timeline
    views.data['views'].each do |view|
       # e.g. "2020-09-27T00:00:00Z"
       timestamp = DateTime.strptime( view['timestamp'], '%Y-%m-%dT%H:%M:%S%z' )

       item = history[ timestamp.strftime( '%Y-%m-%d' ) ] ||= {}   ## e.g. 2016-09-27
       ## note: merge "in-place"
       item.merge!( { 'views' => { 'count'   => view['count'],
                                   'uniques' => view['uniques'] }} )
    end
  end

  if clones
    raise ArgumentError, "Github::Resource expected; got #{clones.class.name}"    unless clones.is_a?( Github::Resource )
=begin
 {"count"=>51,
   "uniques"=>17,
   "clones"=>
    [{"timestamp"=>"2020-09-26T00:00:00Z", "count"=>1, "uniques"=>1},
     {"timestamp"=>"2020-09-27T00:00:00Z", "count"=>2, "uniques"=>1},
     ...
    ]}
=end

    ## keep lastest (summary) record of last two weeks (14 days)
    summary['clones'] = { 'count'   => clones.data['count'],
                          'uniques' => clones.data['uniques'] }

    ## update history / day-by-day items / timeline
    clones.data['clones'].each do |clone|
       # e.g. "2020-09-27T00:00:00Z"
       timestamp = DateTime.strptime( clone['timestamp'], '%Y-%m-%dT%H:%M:%S%z' )

       item = history[ timestamp.strftime( '%Y-%m-%d' ) ] ||= {}   ## e.g. 2016-09-27
       ## note: merge "in-place"
       item.merge!( { 'clones' => { 'count'   => clone['count'],
                                    'uniques' => clone['uniques'] }} )
    end
  end

  if paths
    raise ArgumentError, "Github::Resource expected; got #{paths.class.name}"    unless paths.is_a?( Github::Resource )
=begin
  [{"path"=>"/openfootball/england",
  "title"=>
   "openfootball/england: Free open public domain football data for England (and ...",
  "count"=>394,
  "uniques"=>227},
=end
   summary['paths'] = paths.data
  end

  if referrers
    raise ArgumentError, "Github::Resource expected; got #{referrers.class.name}"    unless referrers.is_a?( Github::Resource )
=begin
  [{"referrer"=>"github.com", "count"=>327, "uniques"=>198},
  {"referrer"=>"openfootball.github.io", "count"=>71, "uniques"=>54},
  {"referrer"=>"Google", "count"=>5, "uniques"=>5},
  {"referrer"=>"reddit.com", "count"=>4, "uniques"=>4}]
=end
    summary['referrers'] = referrers.data
  end
end  # method update_traffic


    def update( repo,
                 commits:   nil,
                 topics:    nil,
                 languages: nil )   ## update stats / fetch data from github via api
      raise ArgumentError, "Github::Resource expected; got #{repo.class.name}"      unless repo.is_a?( Github::Resource )

      ## e.g. 2015-05-11T20:21:43Z
      ## puts Time.iso8601( repo.data['created_at'] )
      @data['created_at'] = repo.data['created_at']
      @data['updated_at'] = repo.data['updated_at']
      @data['pushed_at']  = repo.data['pushed_at']

      @data['size']       = repo.data['size']  # note: size in kb (kilobyte)

      @data['description'] = repo.data['description']

      ### todo/check -  remove language  (always use languages - see below) - why? why not?
      @data['language']    = repo.data['language']  ## note: might be nil!!!



      ########################################
      ####  history / by date record
      rec = {}

      rec['stargazers_count'] = repo.data['stargazers_count']
      rec['forks_count']      = repo.data['forks_count']


      today = Date.today.strftime( '%Y-%m-%d' )   ## e.g. 2016-09-27
      puts "add record #{today} to history..."
      pp rec      # check if stargazers_count is a number (NOT a string)

      history = @data[ 'history' ] ||= {}
      item    = history[ today ]   ||= {}
      ## note: merge "in-place" (overwrite with new - but keep other key/value pairs if any e.g. pageviews, clones, etc.)
      item.merge!( rec )



      ##########################
      ## also check / keep track of (latest) commit
      if commits
        raise ArgumentError, "Github::Resource expected; got #{commits.class.name}"   unless commits.is_a?( Github::Resource )

        puts "update - last commit:"
        ## pp commits
        commit = {
          'committer' => {
            'date' => commits.data[0]['commit']['committer']['date'],
            'name' => commits.data[0]['commit']['committer']['name']
          },
          'author' => {
            'date' => commits.data[0]['commit']['author']['date'],
            'name' => commits.data[0]['commit']['author']['name']
          },
          'message' => commits.data[0]['commit']['message']
        }

        ## for now store only the latest commit (e.g. a single commit in an array)
        @data[ 'commits' ] = [commit]
      end

      if topics
        raise ArgumentError, "Github::Resource expected; got #{topics.class.name}"   unless topics.is_a?( Github::Resource )

        puts "update - topics:"
        ## e.g.
        # {"names"=>
        #   ["opendata",
        #    "football",
        #    "seriea",
        #    "italia",
        #    "italy",
        #    "juve",
        #    "inter",
        #    "napoli",
        #    "roma",
        # "sqlite"]}
        #
        #  {"names"=>[]}

        @data[ 'topics' ] = topics.data['names']
      end


      if languages
        raise ArgumentError, "Github::Resource expected; got #{languages.class.name}"   unless languages.is_a?( Github::Resource )

        puts "update - languages:"


        ## e.g.
        ## {"Ruby"=>1020599, "HTML"=>3219, "SCSS"=>508, "CSS"=>388}
        ##  or might be empty
        ## {}

        @data[ 'languages' ] = languages.data
      end

      pp @data


      ## reset (invalidate) cached values from data hash
      ##   use after reading or fetching
      @cache = {}

      self   ## return self for (easy chaining)
    end


########################################
## read / write methods / helpers
    def write
      ## note: always downcase basename - why? why not? 
      basename = @data['full_name'].gsub( '/', '~' ).downcase   ## e.g. poole/hyde become poole~hyde
      letter   = basename[0]  ## use first letter as index dir e.g. p/poole~hyde
      data_dir = "#{Hubba.config.data_dir}/#{letter}"
      path     = "#{data_dir}/#{basename}.json"

      puts "  writing stats to #{basename} (#{data_dir})..."

      FileUtils.mkdir_p( File.dirname( path ))  ## make sure path exists
      File.open( path, 'w:utf-8' ) do |f|
          f.write( JSON.pretty_generate( @data ))
      end
      self   ## return self for (easy chaining)
    end # method write


    def read
      ## note: always downcase basename - why? why not? 
      ## note: skip reading if file not present
      basename = @data['full_name'].gsub( '/', '~' ).downcase   ## e.g. poole/hyde become poole~hyde
      letter   = basename[0]  ## use first letter as index dir e.g. p/poole~hyde
      data_dir = "#{Hubba.config.data_dir}/#{letter}"
      path     = "#{data_dir}/#{basename}.json"

      if File.exist?( path )
        puts "  reading stats from #{basename} (#{data_dir})..."
        json = File.open( path, 'r:utf-8' ) { |f| f.read }
        @data = JSON.parse( json )

        ## reset (invalidate) cached values from data hash
        ##   use after reading or fetching
        @cache = {}
      else
        puts "!! WARN: - skipping reading stats from #{basename} -- file not found"
      end
      self   ## return self for (easy chaining)
    end # method read

    def read_old
      ## note: skip reading if file not present
      basename = @data['full_name'].gsub( '/', '~' )   ## e.g. poole/hyde become poole~hyde
      data_dir = Hubba.config.data_dir
      path     = "#{data_dir}/#{basename}.json"

      if File.exist?( path )
        puts "  reading stats from #{basename} (#{data_dir})..."
        json = File.open( path, 'r:utf-8' ) { |f| f.read }
        @data = JSON.parse( json )

        ## reset (invalidate) cached values from data hash
        ##   use after reading or fetching
        @cache = {}
      else
        puts "!! WARN: - skipping reading stats from #{basename} -- file not found"
      end
      self   ## return self for (easy chaining)
    end # method read_old
  end # class Stats


end # module Hubba
