module Yorobot


class Setup < Command

=begin
# check ssh
    if [ ! -d ~/.ssh ]; then mkdir ~/.ssh; fi
    echo "$SSH_KEY" > ~/.ssh/id_rsa
    chmod 600 ~/.ssh/id_rsa
    echo "ssh directory - ~/.ssh:"
    ls -la ~/.ssh
    #  ssh -vT git@github.com

# check git
     git --version
     git config --global user.name  "Yo Robot"
     git config --global user.email "gerald.bauer+yorobot@gmail.com"
     git config -l --show-origin
=end

  def call
    ##############
    ## setup ssh

    ssh_key  = ENV['SSH_KEY']

    if ssh_key.nil?
      STDERR.puts "!! ERROR - required SSH_KEY env(ironment) variable missing"
      exit 1
    end

    ssh_path = File.expand_path( '~/.ssh' )

    if File.exist?( "#{ssh_path}/id_rsa" )
      STDERR.puts "!! ERROR - ssh key >#{ssh_path}/id_rsa< already exists"
      exit 1
    end

    ## make sure path exists
    FileUtils.mkdir_p( ssh_path )   unless Dir.exist?( ssh_path )
    puts "--> writing ssh key to >#{ssh_path}/id_rsa<..."
    File.open( "#{ssh_path}/id_rsa", 'w:utf-8' ) do |f|
      f.write( ssh_key )
    end
    ## note: ssh key must be "private" only access by owner (otherwise) WILL NOT work
    ## res = File.chmod( 0600, "#{ssh_path}/id_rsa" )
    ## puts res  ## returns number of files processed; should be 1 - assert - why? why not?
    Computer::Shell.run( %Q{chmod 600 #{ssh_path}/id_rsa} )

    Computer::Shell.run( %Q{ls -la #{ssh_path}} )
    # ssh -vT git@github.com


    #####
    ## setup git
    ## git --version
    Git.version

    user_name  = ENV['YOROBOT_NAME']  || ENV['YO_NAME']
    user_email = ENV['YOROBOT_EMAIL'] || ENV['YO_EMAIL']

    Computer::Shell.run( %Q{git config --global user.name  "#{user_name}"} )
    Computer::Shell.run( %Q{git config --global user.email "#{user_email}"} )

    Computer::Shell.run( %Q{git config -l --show-origin} )
  end
end # class Setup



class Clone < Command     ## change to SshClone(r) or such - why? why not?
  option :depth, "--depth DEPTH", Integer, "shallow clone depth"

  def call( *repos )
    repos.each do |repo|
      if options[:depth]
        ### shallow "fast clone" - support libraries
        ###  use https:// instead of ssh - why? why not?
        Git.clone( "git@github.com:#{repo}.git", depth: options[:depth] )
      else
        ### "deep" standard/ regular clone
        Git.clone( "git@github.com:#{repo}.git" )
      end
    end
  end
end # class Clone



class Push < Command     ## change to SshPush(r) or such - why? why not?

  def call( *paths )  ## e.g. "./cache.github" etc.
     msg = "auto-update week #{Date.today.cweek}"

     paths.each do |path|
       GitProject.open( path ) do |proj|
         if proj.changes?
           proj.add( "." )
           proj.commit( msg )
           proj.push
         end
       end
     end
  end
end  # class Push


end # module Yorobot
