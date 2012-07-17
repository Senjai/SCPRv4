class FeedsController < ApplicationController
  layout false
  
  def all_news
    response.headers["Content-Type"] = 'text/xml'    
    
    # check if we have a cached feed.  If so, short-circuit and return it
    if cache = Rails.cache.fetch("feeds:all_news")
      render :text => cache, :formats => :xml and return
    end
    
    @feed = {
      :title => "All News | 89.3 KPCC",
      :description => "All news from KPCC's reporters, bloggers and shows."
    }
    
    # Anything with a news category is eligible
    @content = ThinkingSphinx.search(
      '',
      :classes    => ContentBase.content_classes,
      :page       => 1,
      :per_page   => 15,
      :order      => :published_at,
      :sort_mode  => :desc,
      :with       => { :is_source_kpcc => true },
      :without    => { :category => '' }
    )[0..-1]
        
    xml = render_to_string(:action => "feed", :formats => :xml)
    Rails.cache.write_entry( "feeds:all_news", xml, :objects => (@content + ["contentbase:new"]) )
    render :text => xml, :format => :xml    
  end
end
