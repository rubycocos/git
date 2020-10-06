###
#  to run use
#     ruby -I ./lib -I ./test test/test_sportdb.rb

require 'helper'


### note: explicit require for sportdb (boot) setup required/needed!!!
require 'sportdb/setup'


class TestSportDb < MiniTest::Test

  def test_setup
    puts SportDb::Boot.root

    SportDb::Boot.setup
  end

end # class TestSportDb

