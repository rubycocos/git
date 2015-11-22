# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_backup.rb


require 'helper'


class TestBackup < MiniTest::Test


  def test_backup
 
    repos = Gitti::GitRepoSet.from_file( "#{GittiBackup.root}/test/data/repos.yml" )
    pp repos
 
    backup = Gitti::GitBackup.new
    backup.backup( repos )
    
    assert true
    ## assume everything ok if get here
  end

end # class TestBackup

