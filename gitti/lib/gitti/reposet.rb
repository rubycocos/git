
module Gitti


class GitRepoSet  ## todo: rename to Hash/Dict/List/Map  or use GitHubRepoSet ??

def self.read( path )
  txt  = File.open( path, 'r:utf-8') { |f| f.read }
  hash = YAML.load( txt )
  new( hash )
end


def initialize( hash )
  @hash = hash
end

def size
  ## sum up total number of repos
  @size ||=  @hash.reduce(0) {|sum,(_,names)| sum+= names.size; sum }
end

def each
  @hash.each do |org_with_counter,names|

    ## remove optional number from key e.g.
    ##   mrhydescripts (3)    =>  mrhydescripts
    ##   footballjs (4)       =>  footballjs
    ##   etc.

    org = org_with_counter.sub( /\([0-9]+\)/, '' ).strip

    ## puts "  -- #{key_with_counter} [#{key}] --"

    yield( org, names )
  end
end

end ## class GitRepoSet

end ## module Gitti

