class FeedsController < ApplicationController
  layout nil
  
  def all_news
    # check if we have a cached podcast.  If so, short-circuit and return it
    if cache = Rails.cache.fetch("feeds:all_news")
      render :text => cache, :formats => [:xml] and return
    end
    
    @feed = {
      :title => "All News || 89.3 KPCC",
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
    )
    
    xml = render_to_string :action => "feed", :formats => [:xml]    
    Rails.cache.write_entry("feeds:all_news",xml,:objects => [@content,"contentbase:new"].flatten)
    render :text => xml, :formats => [:xml]    
  end
end