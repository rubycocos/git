# encoding: utf-8

module Gitti


class GitRepoSet  ## todo: rename to Hash/Dict/List/Map  or use GitHubRepoSet ??

def self.from_file( path )
  hash = YAML.load_file( path )
  self.new( hash )
end


def initialize( hash )
  @hash = hash
end

def each
  @hash.each do |key_with_counter,values|

    ## remove optional number from key e.g.
    ##   mrhydescripts (3)    =>  mrhydescripts
    ##   footballjs (4)       =>  footballjs
    ##   etc.
  
    key = key_with_counter.sub( /\s+\([0-9]+\)/, '' )

    puts "  -- #{key_with_counter} [#{key}] --"

    yield( key, values )
  end
end
  
end ## class GitRepoSet

end ## module Gitti

