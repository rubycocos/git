# encoding: utf-8

###
#  to run use
#     ruby -I ./lib -I ./test test/test_sync.rb


require 'helper'


class TestSync < MiniTest::Test


  def test_sync
 
    repos = Gitti::GitRepoSet.from_file( "#{GittiSync.root}/test/data/repos.yml" )
    pp repos
 
    sync = Gitti::GitSync.new( '/auto/test' )
    sync.sync( repos )
    
    assert true
    ## assume everything ok if get here
  end

end # class TestSync

