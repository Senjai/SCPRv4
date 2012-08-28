class CategoryController < ApplicationController
  respond_to :html, :xml, :rss
  
  def index
    @category = Category.find_by_slug(params[:category])
    @content = get_content_from(@category, limit: 15)
    respond_with @content
  end
  
  #----------
  
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
      params[:page] ||= 1
      
      # Reset to page 1 if the requested page is too high
      # Otherwise an error will occur
      # TODO: Fallback to SQL query instead of just cutting it off.
      if params[:page].to_i > (SPHINX_MAX_MATCHES / options[:limit].to_i)
        params[:page] = 1 
      end
      
      ThinkingSphinx.search('',
        :classes    => ContentBase.content_classes,
        :page       => params[:page],
        :per_page   => options[:limit],
        :order      => :published_at,
        :sort_mode  => :desc,
        :with => { :category => categories.map { |c| c.id } },
        retry_stale: true
      )
    end
  
    #------------------
  
    def generate_sections_for(categories,without)
      sections = []
    
      categories.each do |sec|
        # get stories in this section
        content = ThinkingSphinx.search('',
          :classes    => ContentBase.content_classes,
          :page       => 1,
          :per_page   => 5,
          :order      => :published_at,
          :sort_mode  => :desc,
          :with       => { :category => sec.id },
          :without_any => { :obj_key => without.obj_key.to_crc32 },
          retry_stale: true
        )
                
        top = nil
        more = []
        sorttime = nil
      
        content.each do |c|
          # get the content time as Time
          ctime = c.public_datetime
        
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
