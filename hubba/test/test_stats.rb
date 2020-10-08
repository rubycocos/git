###
#  to run use
#     ruby -I ./lib -I ./test test/test_stats.rb


require 'helper'


class TestStats < MiniTest::Test


  def test_jekyll_minima

    stats = Hubba::Stats.new( 'jekyll/minima' )

    assert_equal 0, stats.size
    assert_equal 0, stats.stars
    assert_nil      stats.history

    Hubba.config.data_dir = "#{Hubba.root}/test/stats"
    stats.read

    assert_equal 321, stats.size
    assert_equal 717, stats.stars
    assert_equal 717, stats.history[0].stars
    assert_equal 1,   stats.history.size

    assert_equal Date.new(2018,  2,  12 ), stats.history[0].date

    assert_nil   stats.history[0].diff_days

    assert_equal Date.new(2018, 2, 21 ), stats.committed
    assert_equal Date.new(2016, 5, 20 ), stats.created
    assert_equal Date.new(2018, 2, 11 ), stats.updated
    assert_equal Date.new(2018, 2,  7 ), stats.pushed

    assert_equal DateTime.new(2018, 2, 21, 19, 35, 59 ), stats.committed_at
    assert_equal DateTime.new(2016, 5, 20, 23,  7, 56 ), stats.created_at
    assert_equal DateTime.new(2018, 2, 11, 16, 13, 33 ), stats.updated_at
    assert_equal DateTime.new(2018, 2,  7, 22, 14, 11 ), stats.pushed_at


    pp stats.last_commit
    pp stats.last_commit_message
    pp stats.history_str   ## pp history pretty printed to string (buffer)
  end



  def test_awesome_blockchains

    stats = Hubba::Stats.new( 'openblockchains/awesome-blockchains' )

    assert_equal 0, stats.size
    assert_equal 0, stats.stars
    assert_nil      stats.history

    Hubba.config.data_dir = "#{Hubba.root}/test/stats"
    stats.read

    assert_equal 1620, stats.size
    assert_equal 1526, stats.stars
    assert_equal 1526, stats.history[0].stars
    assert_equal 1411, stats.history[1].stars
    assert_equal 1084, stats.history[2].stars
    assert_equal 1084, stats.history[-1].stars
    assert_equal 3,    stats.history.size

    assert_equal Date.new(2018,  2,  8 ), stats.history[0].date
    assert_equal Date.new(2018,  1, 28 ), stats.history[1].date
    assert_equal Date.new(2017, 12, 10 ), stats.history[2].date

    assert_equal 11, stats.history[0].diff_days
    assert_equal 49, stats.history[1].diff_days
    assert_nil       stats.history[2].diff_days

    assert_equal 115, stats.history[0].diff_stars
    assert_equal 327, stats.history[1].diff_stars
    assert_nil        stats.history[2].diff_stars

    assert_equal 221.0,   stats.calc_diff_stars    ## defaults to samples: 3, days: 30
    assert_equal  51.566, stats.calc_diff_stars( samples: 5, days: 7 )

    pp stats.history_str   ## pp history pretty printed to string (buffer)
  end


  def test_factbook_json

    stats = Hubba::Stats.new( 'opendatajson/factbook.json' )

    assert_equal 0, stats.size
    assert_equal 0, stats.stars
    assert_nil      stats.history

    Hubba.config.data_dir = "#{Hubba.root}/test/stats"
    stats.read

    assert_equal 7355, stats.size
    assert_equal 539, stats.stars
    assert_equal 539, stats.history[0].stars
    assert_equal 536, stats.history[1].stars
    assert_equal 533, stats.history[2].stars
    assert_equal 457, stats.history[-1].stars
    assert_equal 7,   stats.history.size

    assert_equal Date.new(2018,  2,  8 ), stats.history[0].date
    assert_equal Date.new(2018,  1, 28 ), stats.history[1].date
    assert_equal Date.new(2017, 12, 10 ), stats.history[2].date

    assert_equal 11, stats.history[0].diff_days
    assert_equal 49, stats.history[1].diff_days
    assert_nil       stats.history[-1].diff_days

    assert_equal 3, stats.history[0].diff_stars
    assert_equal 3, stats.history[1].diff_stars
    assert_nil      stats.history[-1].diff_stars

    assert_equal 3.0,   stats.calc_diff_stars    ## defaults to samples: 3, days: 30
    assert_equal 1.012, stats.calc_diff_stars( samples: 5, days: 7 )

    pp stats.history_str   ## pp history pretty printed to string (buffer)
  end

end # class TestStats
