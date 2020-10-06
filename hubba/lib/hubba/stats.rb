# encoding: utf-8

module Hubba

  ####
  #  keep track of repo stats over time (with history hash)

  class Stats     ## todo/check: rename to GithubRepoStats or RepoStats - why? why not?

    attr_reader :data

    def initialize( full_name )
      @data = {}
      @data['full_name'] = full_name  # e.g. poole/hyde etc.
    end


    def full_name() @full_name ||= @data['full_name']; end

    ## note: return datetime objects (NOT strings); if not present/available return nil/null
    def created_at() @created_at ||= @data['created_at'] ? DateTime.strptime( @data['created_at'], '%Y-%m-%dT%H:%M:%S') : nil; end
    def updated_at() @updated_at ||= @data['updated_at'] ? DateTime.strptime( @data['updated_at'], '%Y-%m-%dT%H:%M:%S') : nil; end
    def pushed_at()  @pushed_at  ||= @data['pushed_at']  ? DateTime.strptime( @data['pushed_at'],  '%Y-%m-%dT%H:%M:%S') : nil; end

    ## date (only) versions
    def created() @created ||= @data['created_at'] ? Date.strptime( @data['created_at'], '%Y-%m-%d') : nil; end
    def updated() @updated ||= @data['updated_at'] ? Date.strptime( @data['updated_at'], '%Y-%m-%d') : nil; end
    def pushed()  @pushed  ||= @data['pushed_at']  ? Date.strptime( @data['pushed_at'],  '%Y-%m-%d') : nil; end



    def history()    @history ||= @data['history'] ? build_history( @data['history'] ) : nil; end

    def size
      # size of repo in kb (as reported by github api)
      @size ||= @data['size'] || 0   ## return 0 if not found - why? why not? (return nil - why? why not??)
    end

    def stars
      ## return last stargazers_count entry (as number; 0 if not found)
      @stars ||= history ? history[0].stars : 0
    end


    def commits() @data['commits']; end

    def last_commit()   ## convenience shortcut; get first/last commit (use [0]) or nil
      if @data['commits'] && @data['commits'][0]
         @data['commits'][0]
      else
        nil
      end
    end

    def committed()   ## last commit date (from author NOT committer)
      @committed ||= last_commit ? Date.strptime( last_commit['author']['date'], '%Y-%m-%d') : nil
    end

    def committed_at()   ## last commit date (from author NOT committer)
      @committed_at ||= last_commit ? DateTime.strptime( last_commit['author']['date'], '%Y-%m-%dT%H:%M:%S') : nil
    end


    def last_commit_message() ## convenience shortcut; last commit message
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



    def reset_cache
      ## reset (invalidate) cached values from data hash
      ##   use after reading or fetching
      @full_name    = nil
      @created_at   = @updated_at = @pushed_at = nil
      @created      = @updated    = @pused     = nil
      @history      = nil
      @size         = nil
      @stars        = nil

      @committed_at = nil
      @committed    = nil
    end


########
## build history items (structs)

    class HistoryItem

      attr_reader   :date, :stars    ## read-only attributes
      attr_accessor :prev, :next     ## read/write attributes (for double linked list/nodes/items)

      def initialize( date:, stars: )
        @date  = date
        @stars = stars
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
                 stars: h['stargazers_count'] || 0 )

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
      puts "diff=#{diff}:#{diff.class.name}"    ## check if it's a float
      (diff.to_f/1000.0)
    end
  end

  def history_str
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


###############################
## fetch / read / write methods

    def fetch( gh )   ## update stats / fetch data from github via api
      puts "fetching #{full_name}..."
      repo = gh.repo( full_name )

      ## e.g. 2015-05-11T20:21:43Z
      ## puts Time.iso8601( repo.data['created_at'] )
      @data['created_at'] = repo.data['created_at']
      @data['updated_at'] = repo.data['updated_at']
      @data['pushed_at']  = repo.data['pushed_at']

      @data['size']       = repo.data['size']  # size in kb (kilobyte)

      rec = {}

      puts "stargazers_count"
      puts repo.data['stargazers_count']
      rec['stargazers_count'] = repo.data['stargazers_count']

      today = Date.today.strftime( '%Y-%m-%d' )   ## e.g. 2016-09-27
      puts "add record #{today} to history..."
      pp rec      # check if stargazers_count is a number (NOT a string)

      @data[ 'history' ] ||= {}
      @data[ 'history' ][ today ] = rec

      ##########################
      ## also check / keep track of (latest) commit
      commits = gh.repo_commits( full_name )
      puts "last commit/update:"
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

      pp @data

      reset_cache
      self   ## return self for (easy chaining)
    end



    def write( data_dir: './data' )
      basename = full_name.gsub( '/', '~' )   ## e.g. poole/hyde become poole~hyde
      puts "writing stats to #{basename}..."
      File.open( "#{data_dir}/#{basename}.json", 'w:utf-8' ) do |f|
          f.write JSON.pretty_generate( data )
      end
      self   ## return self for (easy chaining)
    end


    def read( data_dir: './data' )
      ## note: skip reading if file not present
      basename = full_name.gsub( '/', '~' )   ## e.g. poole/hyde become poole~hyde
      filename = "#{data_dir}/#{basename}.json"
      if File.exist?( filename )
        puts "reading stats from #{basename}..."
        json = File.open( filename, 'r:utf-8' ) { |file| file.read }   ## todo/fix: use read_utf8
        @data = JSON.parse( json )
        reset_cache
      else
        puts "skipping reading stats from #{basename} -- file not found"
      end
      self   ## return self for (easy chaining)
    end

  end # class Stats


end # module Hubba
