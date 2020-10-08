###
#  to run use
#     ruby -I ./lib -I ./test test/test_config.rb


require 'helper'


class TestConfig < MiniTest::Test

  def test_config
     Hubba.configure do |config|
       config.user     = 'user1'
       config.password = 'password1'
       # -or-
       config.token    = 'token1'
     end

     assert_equal 'user1',     Hubba.configuration.user
     assert_equal 'password1', Hubba.configuration.password
     assert_equal 'token1',    Hubba.configuration.token
  end

end # class TestConfig
