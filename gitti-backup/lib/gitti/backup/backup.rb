# encoding: utf-8


module Gitti


class GitBackup

  def initialize( backup_dir = '~/backup' )
    @backup_dir = File.expand_path( backup_dir )
    pp @backup_dir
    ##  use/renmae to backup_root - why? why not??
  end

  def backup( repos )
    ##  default to adding folder per day ## e.g. 2015-11-20
    backup_dir = "#{@backup_dir}/#{Date.today.strftime('%Y-%m-%d')}"
    pp backup_dir
    
    FileUtils.mkdir_p( backup_dir )   ## make sure path exists

    org_count   = 0
    repo_count  = 0

    repos.each do |key,values|
      dest_dir = "#{backup_dir}/#{key}"
      FileUtils.mkdir_p( dest_dir )   ## make sure path exists

      values.each_with_index do |value,i|
        puts " \##{repo_count+1} [#{i+1}/#{values.size}] #{value}"

        puts "     #{key}/#{value}"

        repo    = GitHubBareRepo.new( key, value )  ## owner, name e.g. rubylibs/webservice
        success = repo.backup_with_retries( dest_dir )   ## note: defaults to two tries   
        ## todo/check:  fail if success still false after x retries? -- why? why not?

        repo_count += 1

        ###  exit if repo_count > 2
      end

      org_count += 1  
    end
  
    ## print stats

    puts "  #{org_count} orgs, #{repo_count} repos"
  end  ## backup

end  ## GitBackup

