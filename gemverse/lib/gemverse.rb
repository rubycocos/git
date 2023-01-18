require 'cocos'



module Gems

def self.gems_by( handle )
  src = "#{BASE}/owners/#{handle}/gems.json"
  call( src )
end

def self.versions( name )

  ## note: will NOT include yanked versions
  ##   check if there's a query parameter ???


  src = "#{BASE}/versions/#{name}.json"
  call( src )
end



BASE = 'https://rubygems.org/api/v1'


def self.call( src )   ## get response as (parsed) json (hash table)

  headers = {
    # 'User-Agent' => "Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/100.0.4896.127 Safari/537.36",
    'User-Agent' => "ruby v#{RUBY_VERSION}",
   }

  response = Webclient.get( src, headers: headers )

  if response.status.ok?
    puts "#{response.status.code} #{response.status.message} -  content_type: #{response.content_type}, content_length: #{response.content_length}"

    response.json
  else
    puts "!! HTTP ERROR:"
    puts "#{response.status.code} #{response.status.message}"
    exit 1
  end
end


end  # module Gems
