###
#  to run use
#     ruby -I ./lib -I ./test test/test_shell.rb

require 'helper'

class TestShell < MiniTest::Test

  Shell = Computer::Shell

  def test_run
    Shell.run( 'git config user.name' )
    Shell.run( 'git config --show-origin user.name' )
    # Shell.run( 'git config xxxx' )
    # Shell.run( 'xxxx' )
  end

  def test_call
    stdout1, stderr1, status1 = Shell.call( 'git config user.name' )
    stdout2, stderr2, status2 = Shell.call( 'git config --show-origin user.name' )
    # stdout3, stderr3, status3 = Shell.call( 'xxxx' )

    pp stdout1
    pp stderr1
    pp status1
    puts "---"
    pp stdout2
    pp stderr2
    pp status2
  end

end # class TestShell

