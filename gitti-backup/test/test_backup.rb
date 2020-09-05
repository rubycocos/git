###
#  to run use
#     ruby -I ./lib -I ./test test/test_backup.rb


require 'helper'


class TestBackup < MiniTest::Test

  def test_backup_i
    repos = GitRepoSet.read( "#{GittiBackup.root}/test/data/repos.yml" )
    pp repos

    backup = GitBackup.new
    assert true    ## assume everything ok if get here
  end

  def test_backup_ii
    repos = GitRepoSet.read( "#{GittiBackup.root}/test/data/repos.yml" )
    pp repos

    backup = GitBackup.new
    backup.backup( repos )

    assert true    ## assume everything ok if get here
  end

end # class TestBackup

