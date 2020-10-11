module Hubba

  ####
  #  keep track of repo stats over time (with history hash)

  class Stats     ## todo/check: rename to GithubRepoStats or RepoStats - why? why not?

    attr_reader :data

    def initialize( full_name )
      @data = {}
      @data['full_name'] = full_name  # e.g. poole/hyde etc.

      @cache = {}
    end


    def full_name()    @data['full_name']; end
    def description()  @data['description'] || ''; end  ## todo/check: return nil if not found - why? why not?
    alias_method :descr, :description
    alias_method :desc,  :description

    def topics()      @data['topics'] || []; end   ## todo/check: return nil if not found - why? why not?


    ## note: return datetime objects (NOT strings); if not present/available return nil/null
    def created_at() @cache['created_at'] ||= parse_datetime( @data['created_at'] ); end
    def updated_at() @cache['updated_at'] ||= parse_datetime( @data['updated_at'] ); end
    def pushed_at()  @cache['pushed_at']  ||= parse_datetime( @data['pushed_at'] );  end

    ## date (only) versions
    def created() @cache['created'] ||= parse_date( @data['created_at'] ); end
    def updated() @cache['updated'] ||= parse_date( @data['updated_at'] ); end
    def pushed()  @cache['pushed']  ||= parse_date( @data['pushed_at'] ); end

    def size
      # size of repo in kb (as reported by github api)
      @data['size'] || 0   ## return 0 if not found - why? why not? (return nil - why? why not??)
    end


    def history
      @cache['history'] ||= begin
                              if @data['history']
                                build_history( @data['history'] )
                              else
                                nil
                              end
                            end
    end


    def stars
      ## return last stargazers_count entry (as number; 0 if not found)
      @cache['stars'] ||= history ? history[0].stars : 0
    end

    ###################
    # traffic
    def traffic() @data['traffic']; end


    ###########
    # commits
    def commits() @data['commits']; end

    def last_commit   ## convenience shortcut; get first/last commit (use [0]) or nil
      if @data['commits'] && @data['commits'][0]
         @data['commits'][0]
      else
         nil
      end
    end


    def committed   ## last commit date (from author NOT committer)
      @cache['committed'] ||= parse_date( last_commit_author_date )
    end

    def committed_at()   ## last commit date (from author NOT committer)
      @cache['committed_at'] ||= parse_datetime( last_commit_author_date )
    end

    def last_commit_author_date
      h = last_commit
      h ? h['author']['date'] : nil
    end


    def last_commit_message    ## convenience shortcut; last commit message
      h = last_commit

      committer_name = h['committer']['name']
      author_name    = h['author']['name']
      message        = h['message']

      buf = ""
      buf << message
      buf << " by #{author_name}"

      if committer_name != author_name
        buf << " w/ #{committer_name}"
      end
    end  # method commit_message



    ###
    # helpers
    def parse_datetime( str ) str ? DateTime.strptime( str, '%Y-%m-%dT%H:%M:%S') : nil; end
    def parse_date( str )     str ? Date.strptime( str, '%Y-%m-%d') : nil; end

########
## build history items (structs)

    class HistoryItem

      attr_reader   :date, :stars, :forks    ## read-only attributes
      attr_accessor :prev, :next     ## read/write attributes (for double linked list/nodes/items)

      def initialize( date:, stars:, forks: )
        @date  = date
        @stars = stars
        @forks = forks
        @next  = nil
      end

      ## link items (append item at the end/tail)
      def append( item )
        @next = item
        item.prev = self
      end

      def diff_days
        if @next
          ## note: use jd=julian days for calculation
          @date.jd - @next.date.jd
        else
          nil   ## last item (tail)
        end
      end

      def diff_stars
        if @next
          @stars - @next.stars
        else
          nil   ## last item (tail)
        end
      end
    end  ## class HistoryItem


    def build_history( timeseries )
      items = []

      keys  = timeseries.keys.sort.reverse   ## newest (latest) items first
      keys.each do |key|
        h = timeseries[ key ]

        item = HistoryItem.new(
                 date:  Date.strptime( key, '%Y-%m-%d' ),
                 stars: h['stargazers_count'] || 0,
                 forks: h['forks_count'] || 0 )

        ## link items
        last_item = items[-1]
        last_item.append( item )   if last_item     ## if not nil? append (note first item has no prev item)

        items << item
      end

      ## todo/check: return [] for empty items array (items.empty?) - why?? why not??
      if items.empty?
        nil
      else
        items
      end
    end  ## method build_history



  def calc_diff_stars( samples: 3, days: 30 )
    ## samples: use n history item samples e.g. 3 samples
    ## days e.g. 7 days (per week), 30 days (per month)

    if history.nil?
      nil   ## todo/check: return 0.0 too - why? why not?
    elsif history.size == 1
      ## just one item; CANNOT calc diff; return zero
      0.0
    else
      idx   = [history.size, samples].min   ## calc last index
      last  = history[idx-1]
      first = history[0]

      diff_days  = first.date.jd - last.date.jd
      diff_stars = first.stars   - last.stars

      ## note: use factor 1000 for fixed integer division
      ##  converts to float at the end

      ##  todo: check for better way (convert to float upfront - why? why not?)

      diff = (diff_stars * days * 1000) / diff_days
      ##  puts "diff=#{diff}:#{diff.class.name}"    ## check if it's a float
      (diff.to_f/1000.0)
    end
  end


  def history_str  ## todo/check: rename/change to format_history or fmt_history - why? why not?
    ## returns "pretty printed" history as string buffer
    buf = ''
    buf << "[#{history.size}]: "

    history.each do |item|
      buf << "#{item.stars}"

      diff_stars = item.diff_stars
      diff_days  = item.diff_days
      if diff_stars && diff_days  ## note: last item has no diffs
        if diff_stars > 0 || diff_stars < 0
          if diff_stars > 0
            buf << " (+#{diff_stars}"
          else
            buf << " (#{diff_stars}"
          end
          buf << " in #{diff_days}d) "
        else  ## diff_stars == 0
          buf << " (#{diff_days}d) "
        end
      end
    end
    buf
  end # method history_str



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
                 commits: nil,
                 topics:  nil )   ## update stats / fetch data from github via api
      raise ArgumentError, "Github::Resource expected; got #{repo.class.name}"      unless repo.is_a?( Github::Resource )

      ## e.g. 2015-05-11T20:21:43Z
      ## puts Time.iso8601( repo.data['created_at'] )
      @data['created_at'] = repo.data['created_at']
      @data['updated_at'] = repo.data['updated_at']
      @data['pushed_at']  = repo.data['pushed_at']

      @data['size']       = repo.data['size']  # note: size in kb (kilobyte)

      @data['description'] = repo.data['description']
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


      pp @data



      ## reset (invalidate) cached values from data hash
      ##   use after reading or fetching
      @cache = {}

      self   ## return self for (easy chaining)
    end


########################################
## read / write methods / helpers

    def write
      basename = full_name.gsub( '/', '~' )   ## e.g. poole/hyde become poole~hyde
      data_dir = Hubba.config.data_dir
      puts "  writing stats to #{basename} (#{data_dir})..."

      ## todo/fix: add FileUtils.makepath_r or such!!!
      File.open( "#{data_dir}/#{basename}.json", 'w:utf-8' ) do |f|
          f.write JSON.pretty_generate( data )
      end
      self   ## return self for (easy chaining)
    end


    def read
      ## note: skip reading if file not present
      basename = full_name.gsub( '/', '~' )   ## e.g. poole/hyde become poole~hyde
      data_dir = Hubba.config.data_dir
      path = "#{data_dir}/#{basename}.json"

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
    end

  end # class Stats


end # module Hubba
