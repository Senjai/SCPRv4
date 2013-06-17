class CategoryController < ApplicationController
  respond_to :html, :xml, :rss
  
  def news
    @categories = Category.where(:is_news => true).all
    respond_by_format
  end
  
  #----------
  
  def arts
    @categories = Category.where(:is_news => false).all
    respond_by_format
  end
  
  #------------------

  def carousel_content
    @content = params[:object_class].constantize.find(params[:id])
    @carousel_contents = @content.category.content(params[:page], 4, @content)
    render 'shared/cwidgets/content_carousel.js.erb'
  end


  #------------------
  
  protected
  
  #------------------
  # Respond according to format requested
  def respond_by_format
    # Only need to setup the sections if we're going to
    # render them as HTML
    if request.format.html?
      @top      = get_content_from(@categories, limit: 1).first
      @sections = generate_sections_for(@categories,@top)

    # Otherwise just return the latest 15 news items
    else
      @content = get_content_from(@categories)
      respond_with @content
    end
  end
  
  #------------------
  # Get Content
  def get_content_from(categories, options={})
    # make sure categories is an array
    categories = [categories].flatten
    options[:limit] ||= 15
    enforce_page_limits(options[:limit])
    
    ContentBase.search({
      :classes     => [NewsStory, BlogEntry, ContentShell, ShowSegment],
      :page        => params[:page],
      :per_page    => options[:limit],
      :with        => { category: categories.map { |c| c.id } }
    })
  end

  #------------------

  def generate_sections_for(categories,without)
    sections = []
    
    # If without is nil, assume we had some problem with sphinx above
    # TODO Make this better
    return [] if without.nil?
    
    categories.each do |sec|
      # get stories in this section
      content = ContentBase.search({
        :classes     => [NewsStory, BlogEntry, ContentShell, ShowSegment],
        :limit       => 5,
        :with        => { :category => sec.id },
        :without_any => { :obj_key => without.obj_key.to_crc32 }
      })
      
      top = nil
      more = []
      sorttime = nil
    
      content.each do |c|
        # get the content time as Time
        ctime = c.published_at
      
        # if we're still here, weigh this content for sorting
        if !sorttime || ctime > sorttime
          sorttime = ctime
        end
      
        # does this content have an asset?
        if !top && c.assets.any?
          top = c
          next
        end
      
        # finally, just drop it in the more bucket
        more << c
      end
    
      # assemble section object
      obj = {
        :section  => sec,
        :content  => [top,more].flatten,
        :sorttime => sorttime
      }
    
      obj[:candidates] = sec.feature_candidates :exclude => [without,top]
      obj[:right] = obj[:candidates] ? obj[:candidates][0][:content] : nil
    
      # Add this to our section list
      sections << obj
    end
  
    # sort sections
    sections.sort_by! {|s| s[:sorttime] }.reverse!
  
    return sections
  end
end
