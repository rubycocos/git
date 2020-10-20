module Computer


## raised / thrown by Shell.run if exit status non-zero
##   todo/check: (re)use an already existing error - why? why not?
class ShellError < StandardError
end


###
#  use nested class for "base" for running commands - why? why not?
class Shell

  ## use call for the "to-the-metal" command execution
  def self.call( cmd )
    stdout, stderr, status = Open3.capture3( cmd )
    [stdout, stderr, status]
  end


  ## use run for "porcelain / high-level" command execution
  def self.run( cmd )
    ## add pwd (print working directory to output?) - why? why not?
    print "---> (shell run) >#{cmd}<..."
    stdout, stderr, status = Open3.capture3( cmd )

    ## todo: add colors (red, green) - why? why not?
    if status.success?
      print " OK"   ## todo/check: use OK (0) - why? why not?
      print "\n"
    else
      print " FAIL (#{status.exitstatus})"
      print "\n"
    end

    unless stdout.empty?
      puts stdout
    end

    unless stderr.empty?
      ## todo/check: or use >2: or &2: or such
      ##  stderr output not always an error (that is, exit status might be 0)
      STDERR.puts "2>"
      STDERR.puts stderr
    end

    if status.success?
      stdout   # return stdout string
    else
      STDERR.puts "!! ERROR: Shell.run >#{cmd}< failed with exit status #{status.exitstatus}:"
      STDERR.puts stderr

      raise ShellError, "Shell.run >#{cmd}< failed with exit status #{status.exitstatus}<: #{stderr}"
    end
  end
end  # class Shell
end  # module Computer
