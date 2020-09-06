
module Gitti


class GitBackup

  class Tool   ## nested class
    def self.main( args=ARGV )
      backup = GitBackup.new
      args.each do |arg|
        backup.backup( GitRepoSet.read( arg ))
      end
    end
  end ## nested class Tool



  def initialize( root= '~/backup', daily: false )
    @root = File.expand_path( root )
    pp @root

    ## use current working dir for the log path; see do_with_log helper for use
    @log_path = File.expand_path( '.' )
    pp @log_path

    @daily = daily
  end


  ##  auto-add "daily" date folder / dir
  ##    e.g. 2015-11-20 using Date.today.strftime('%Y-%m-%d')
  def daily=(value) @daily=value; end



  def backup( repos )
    count_orgs  = 0
    count_repos = 0

    total_repos  = repos.size

    ##  default to adding folder per day ## e.g. 2015-11-20
    backup_path = "#{@root}"
    backup_path <<  "/#{Date.today.strftime('%Y-%m-%d')}"  if @daily
    pp backup_path

    FileUtils.mkdir_p( backup_path )   ## make sure path exists

    repos.each do |org, names|
      org_path = "#{backup_path}/#{org}"
      FileUtils.mkdir_p( org_path )   ## make sure path exists

      names.each do |name|
        puts "[#{count_repos+1}/#{total_repos}] #{org}@#{name}..."

        repo = GitHubRepo.new( org, name )  ## owner, name e.g. rubylibs/webservice

        success = Dir.chdir( org_path ) do
                    if Dir.exist?( "#{repo.name}.git" )
                      GitMirror.open( "#{repo.name}.git" ) do |mirror|
                        do_with_retries { mirror.update }   ## note: defaults to two tries
                      end
                    else
                      do_with_retries { Git.mirror( repo.https_clone_url ) }
                    end
                  end

        ## todo/check:  fail if success still false after x retries? -- why? why not?

        count_repos += 1
      end
      count_orgs += 1
    end

    ## print stats
    puts "  #{count_repos} repo(s) @ #{count_orgs} org(s)"
  end  ## backup


  ######
  # private helpers

  def do_with_log( &blk )
    blk.call
    true  ## return true  ## success/ok
  rescue GitError => ex
    puts "!! ERROR: #{ex.message}"

    File.open( "#{@log_path}/errors.log", 'a' ) do |f|
      f.write "#{Time.now} -- #{ex.message}\n"
    end
    false ## return false  ## error/nok
  end


  def do_with_retries( retries: 2, sleep: 5, &blk )
    retries_count = 0
    success = false
    loop do
      success = do_with_log( &blk )
      retries_count += 1
      break if success || retries_count >= retries
      puts "retrying in #{sleep}secs... sleeping..."
      sleep( sleep )  ## sleep 5secs or such
    end
    success   ## return if success or not  (true/false)
  end

end ## class GitBackup
end ## module Gitti
