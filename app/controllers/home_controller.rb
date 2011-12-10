class HomeController < ApplicationController
  layout "homepage"
  
  def index
    @homepage = Homepage.published.first
    
    # -- Section Rules -- #
    
    sechash = {}
    @sections = []
    
    # Grab 40 pieces of categorized content and pop them into buckets
    @content = ThinkingSphinx.search '',
      :classes    => [NewsStory],
      :page       => 1,
      :per_page   => 40,
      :order      => :published_at,
      :sort_mode  => :desc

    @content.each do |c|
      if c.category
        if sechash[ c.category.id ]
          sechash[ c.category.id ] << c
        else
          s = [c]
          sechash[ c.category.id ] = s
          @sections << s
        end
      end
    end
  end
end
