###
#  to run use
#     ruby -I ./lib -I ./test test/test_stats_tmp.rb


require 'helper'


class TestStatsTmp < MiniTest::Test

  def setup
    @gh = Hubba::Github.new
  end

  def test_stats
    repos = [
      'poole/hyde',
      'jekyll/minima'
    ]


    repos.each do |repo|
      stats = Hubba::Stats.new( repo )

      Hubba.config.data_dir = "#{Hubba.root}/test/stats"
      stats.read()

      puts "stars before fetch: #{stats.stars}"
      puts "size  before fetch: #{stats.size} kb"

      ## note/todo: enable for "live" online testing
      ## @gh.update( stats )

      puts "stars after fetch: #{stats.stars}"
      puts "size  after fetch: #{stats.size} kb"

      Hubba.config.data_dir = './tmp'
      stats.write()
    end

    assert true    # for now everything ok if we get here
  end

end # class TestStatsTmp
