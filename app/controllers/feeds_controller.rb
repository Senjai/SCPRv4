class FeedsController < ApplicationController
  layout false
  
  def all_news
    response.headers["Content-Type"] = 'text/xml'
    
    # check if we have a cached feed.  If so, short-circuit and return it
    if cache = Rails.cache.fetch("feeds:all_news")
      render :text => cache, :formats => :xml and return
    end
    
    @feed = {
      :title       => "All News | 89.3 KPCC",
      :description => "All news from KPCC's reporters, bloggers and shows."
    }
    
    # Anything with a news category is eligible
    @content = ContentBase.search({
      :classes => [NewsStory, ContentShell, BlogEntry, ShowSegment],
      :limit   => 15,
      :with    => { 
        :is_source_kpcc => true,
        :is_live        => true
      },
      :without => { category: '' }
    })

    xml = render_to_string(action: "feed", formats: :xml)
    Rails.cache.write_entry("feeds:all_news", xml, objects: (@content.push "contentbase:new"))
    render text: xml, format: :xml
  end
end
