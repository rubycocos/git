
module Gems



class GemDataset    ## rename to Gems or Gemset or such - why? why not?


  def initialize( gems )
     @gems = gems
  end

  def size() @gems.size; end



  ## todo/check:  add an write_csv( path ) alias / alternate method name - why? why not?
def export( path )
  recs = []

  @gems.each do |gem|

    if gem.yanked?
      puts "!! ERROR - includes yanked gem"
      pp gem
      exit 1
    end

    rec = [gem.name,
           gem.version,
           gem.version_created.strftime( '%Y-%m-%d' ),
           gem.version_downloads.to_s,
           gem.homepage,
           gem.runtime_dependencies.join( ' | ' ),
          ]
    recs << rec
  end
  headers = ['name',
             'version',
             'version_created',
             'version_downloads',
             'homepage',
             'dependencies',
            ]
  write_csv( path, [headers]+recs )
end # method export
end   ## class GemDataset




class Gem   ## todo/check: rename or use Gem::Meta or such - why? why not?

  attr_reader :name,
              :version, :version_created, :version_downloads,
              :homepage,
              :runtime


  def self.create( h )  ## todo/check: rename to  create_from_json or such - why? why not?
      ## optional keyword args
      kwargs = {
        version:           h['version'],
        ## only use year/month/day for now now hours etc. - why? why not
        version_created:   h['version_created_at'] ? Date.strptime( h['version_created_at'], '%Y-%m-%d' ) : nil,
        version_downloads: h['version_downloads'],
        ## note: (auto-)clean
        ##   for example - newline seen in "http://icanhasaudio.com/\n" !!!
        homepage: h['homepage_uri'] ? h['homepage_uri'].gsub( /[ \r\n]/, '')
        : nil,
        yanked:   h['yanked'],
        runtime:  h['dependencies']['runtime'].map { |dep| dep['name'] }
      }

      new( name: h['name'],
           **kwargs )
  end


  def initialize( name:,
                  version: nil,
                  version_created: nil,
                  version_downloads: nil,
                  homepage: nil,
                  yanked: nil,
                  runtime: [] )

     @name              = name
     @version           = version
     @version_created   = version_created
     @version_downloads = version_downloads
     @homepage          = homepage
     @yanked            = yanked
     @runtime           = runtime
  end

  alias_method :runtime_dependencies, :runtime

  ## always return false if not defined - why? why not?
  def yanked?()   @yanked.nil?  ? false : @yanked;  end
end  # class Gems


end   ## module Gems
