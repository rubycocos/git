# encoding: utf-8

module Gitti


class GitSync

  def initialize( sync_dir = '.' )   ## e.g. use /auto or something
    @sync_dir = File.expand_path( sync_dir )
    pp @sync_dir
    ##  use/renmae to sync_root - why? why not??
  end

  def sync( repos )
    org_count   = 0
    repo_count  = 0

    repos.each do |key,values|
      dest_dir = "#{@sync_dir}/#{key}"
      FileUtils.mkdir_p( dest_dir )   ## make sure path exists

      values.each_with_index do |value,i|
        puts " \##{repo_count+1} [#{i+1}/#{values.size}] #{value}"

        puts "     #{key}/#{value}"

        repo    = GitHubRepo.new( key, value )  ## owner, name e.g. rubylibs/webservice
        success = repo.sync( dest_dir )

        repo_count += 1

        ###  exit if repo_count > 2
      end

      org_count += 1  
    end
  
    ## print stats

    puts "  #{org_count} orgs, #{repo_count} repos"
  end  ## sync

end  ## GitBackup

end ## module Gitti
