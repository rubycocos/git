###
#  to run use
#     ruby -I ./lib -I ./test test/test_cache.rb


require 'helper'


class TestCache < MiniTest::Test

  def setup
    @cache = Hubba::Cache.new( "#{Hubba.root}/test/cache" )
  end

  def test_basename
    mappings = [['/users/geraldb',                    'users~geraldb'],
                ['/users/geraldb/repos',              'users~geraldb~repos'],
                ['/users/geraldb/repos?per_page=100', 'users~geraldb~repos'],
                ['/users/geraldb/orgs',               'users~geraldb~orgs'],
                ['/users/geraldb/orgs?per_page=100',  'users~geraldb~orgs'],
                ['/orgs/wikiscript/repos',            'orgs~wikiscript~repos'],
                ['/orgs/planetjekyll/repos',          'orgs~planetjekyll~repos'],
                ['/orgs/vienna-rb/repos',             'orgs~vienna-rb~repos']]

    mappings.each do |mapping|
      assert_equal mapping[1], @cache.request_uri_to_basename( mapping[0] )
    end
  end  # method test_basename

  def test_cache
     orgs  = @cache.get( '/users/geraldb/orgs' )
     assert_equal 4, orgs.size

     repos = @cache.get( '/users/geraldb/repos' )
     assert_equal 3, repos.size
  end  # method test_cache

  def test_cache_miss
     assert_nil @cache.get( '/test/hello' )
     assert_nil @cache.get( '/test/hola' )
  end  # method test_cache_miss

end # class TestCache
