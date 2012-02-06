class FeedsController < ApplicationController
  layout nil
  
  def all_news
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
    
    render :action => "feed.xml"
  end
end