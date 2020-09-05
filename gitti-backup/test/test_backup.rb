###
#  to run use
#     ruby -I ./lib -I ./test test/test_backup.rb


require 'helper'


class TestBackup < MiniTest::Test

  include Gitti

  def test_backup

    repos = GitRepoSet.from_file( "#{GittiBackup.root}/test/data/repos.yml" )
    pp repos

    backup = GitBackup.new
    backup.backup( repos )

    assert true
    ## assume everything ok if get here
  end

end # class TestBackup

