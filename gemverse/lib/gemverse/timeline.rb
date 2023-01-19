
module Gems
class Timeline

  def initialize( versions )
    ## sort by version created and name
    @versions = versions.sort do |l,r|
                  res =  r['created'] <=> l['created']
                  res =  l['name']    <=> r['name']     if res == 0
                  res =  r['version'] <=> l['version']  if res == 0
                  res
                end
  end


  def save( path )
     buf = build
     write_text( path, buf )
  end


  def build
   ## step 1 - build document model - versions by year & week
   ##                  and split into new & update
   model = {}

   @versions.each do |rec|

     date = Date.strptime( rec['created'], '%Y-%m-%d' )
     year = date.year.to_s
     week = date.strftime('%V')  ## note: return zero-padded string e.g. 01, 02, etc.

     by_year = model[ year ] ||= {}
     by_week = by_year[ week ] ||= { 'new'     => [],
                                     'updated' => [] }

     if rec['count'].to_i == 1
        by_week[ 'new' ] << rec
     else
        by_week[ 'updated' ] << rec
     end
   end

   ## pp model

   ## step 2 - build document

   buf = String.new
   buf << "# Timeline \n\n"

   ## add breadcrumps for years
   buf << model.keys.map do |year|
                 "[#{year}](##{year})"
          end.join( ' · ' )
   buf << "\n\n"

   ## add new gems by year
   buf << "## New Gems By Year\n\n"

   model.each do |year, by_week|
    ## get totals for year
    gems_new = by_week.values.reduce( [] ) do |acc,gems|
      acc + gems['new']
    end

    buf << "**#{year}** - "

    buf <<   if gems_new.size > 0
                _build_gems_new( gems_new )
             else
               "Ø \n\n"
             end
   end


   model.each do |year, by_week|
    buf << "## #{year}\n\n"

    by_week.each do |week, gems|
      buf << "**Week #{week}**\n\n"

      buf << _build_gems_new( gems['new'] )
      buf << _build_gems_updated( gems['updated'] )
    end
   end

   buf
  end  # method build


def _build_gem( gem )
  date =  Date.strptime( gem['created'], '%Y-%m-%d' )

  buf = String.new
  buf << "[**"
  buf << gem['name']
  buf << "**]"
  buf << "("
  buf << "https://rubygems.org/gems/#{gem['name']}/versions/#{gem['version']}"
  buf << " "
  buf << %Q{"update no.#{gem['count']} @ #{date.strftime('%a %d %b %Y')}"}
  buf << ") "
  buf << gem['version']
  buf
end


def _build_gems_new( gems )
  buf = String.new
  if gems.size > 0
    buf << "**NEW!** - #{gems.size} Gem(s) - "
    buf <<  gems.map do |gem| _build_gem( gem )
                     end.join( ', ' )
    buf << "\n\n"
  end
  buf
end

def _build_gems_updated( gems )
  buf = String.new
  if gems.size > 0
    buf << "#{gems.size} Update(s)  - "
    buf <<  gems.map do |gem| _build_gem( gem )
                     end.join( ', ' )
   buf << "\n\n"
  end
  buf
end





  def export( path )

    headers = ['week',
           'name',
           'version',
           'count',
           'created',
           'downloads']
   recs = []
   @versions.each_with_index do |h,i|

     date = Date.strptime( h['created'], '%Y-%m-%d' )

     rec = [
        date.strftime('%Y/%V'),
        h['name'],
        h['version'],
        h['count'],
        date.strftime( '%Y-%m-%d' ),  # add (%a) for (Sun), (Mon) or such - why? why not?
        h['downloads'],
      ]
      recs << rec
    end

    write_csv( path, [headers]+recs )
  end
end  ## class Timeline
end  ## module Gems
