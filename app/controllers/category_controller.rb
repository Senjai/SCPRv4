class CategoryController < ApplicationController  
  def index
    @category = Category.find_by_id(params[:id])
    
    @content = ThinkingSphinx.search '',
      :classes    => ContentBase.content_classes,
      :page       => params[:page],
      :per_page   => 10,
      :order      => :published_at,
      :sort_mode  => :desc,
      :with       => { :category => @category.id }
  end
  
  #----------
  
  def news
    secobjs = Category.where(:is_news => true).all
    
    # get a top story
    @top = ThinkingSphinx.search(
      '',
      :classes    => ContentBase.content_classes,
      :page       => params[:page] || 1,
      :per_page   => 1,
      :order      => :published_at,
      :sort_mode  => :desc,
      :with => { :category => secobjs.map { |c| c.id } }
    )[0]
    
    @sections = generate_sections_for(secobjs,@top)
    
    # sending @top and @sections to render
    
  end
  
  #----------
  
  def arts
    secobjs = Category.where(:is_news => false).all
    
    # get a top story
    @top = ThinkingSphinx.search(
      '',
      :classes    => ContentBase.content_classes,
      :page       => params[:page] || 1,
      :per_page   => 1,
      :order      => :published_at,
      :sort_mode  => :desc,
      :with => { :category => secobjs.map { |c| c.id } }
    )[0]
    
    @sections = generate_sections_for(secobjs,@top)
    
    # sending @top and @sections to render    
  end

  def carousel_content
    @content = params[:object_class].constantize.find(params[:id])
    @carousel_contents = @content.category.content(params[:page], 4, @content)
    render 'shared/cwidgets/content_carousel.js.erb'
  end
  
  protected
  def generate_sections_for(secobjs,without)
    
    sections = []
    
    secobjs.each do |sec|
      # get stories in this section
      content = ThinkingSphinx.search '',
        :classes    => ContentBase.content_classes,
        :page       => 1,
        :per_page   => 5,
        :order      => :published_at,
        :sort_mode  => :desc,
        :with       => { :category => sec.id },
        :without_any => { :obj_key => without.obj_key.to_crc32 }
        
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