require 'pp'
require 'time'
require 'date'    ## e.g. Date.today etc.
require 'yaml'
require 'json'
require 'uri'
require 'net/http'
require "net/https"
require 'open3'
require 'fileutils'    ## e.g. FileUtils.mkdir_p etc.

##########################
# more defaults ("prolog/prelude") always pre-loaded
require 'optparse'
require 'rbconfig'

#####################
# our own code
require 'computer/version'   # note: let version always go first
require 'computer/shell'




## add some system info from/via rbconfig - why? why not?
module Computer

OS = case RbConfig::CONFIG['host_os'].downcase
when /linux/
  "linux"
when /darwin/
  "darwin"
when /freebsd/
  "freebsd"
when /netbsd/
  "netbsd"
when /openbsd/
  "openbsd"
when /dragonfly/
  "dragonflybsd"
when /sunos|solaris/
  "solaris"
when /mingw|mswin/
  "windows"
else
  RbConfig::CONFIG['host_os'].downcase
end

CPU = RbConfig::CONFIG['host_cpu']   ## todo/check: always use downcase - why? why not?

ARCH = case CPU.downcase
when /amd64|x86_64|x64/
  "x86_64"
when /i?86|x86|i86pc/
  "i386"
when /ppc64|powerpc64/
  "powerpc64"
when /ppc|powerpc/
  "powerpc"
when /sparcv9|sparc64/
  "sparcv9"
when /arm64|aarch64/  # MacOS calls it "arm64", other operating systems "aarch64"
  "aarch64"
when /^arm/
  "arm"
else
  RbConfig::CONFIG['host_cpu']   ## todo/check: always use downcase - why? why not?
end

def self.os()   OS;   end
def self.cpu()  CPU;  end
def self.arch() ARCH; end


end  # module Computer


######################
# add convenience shortcuts - why? why not?
Compu = Computer


# say hello
puts Computer.banner
