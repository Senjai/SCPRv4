module WidgetsHelper

  def featured_comment(opts)
    opts = { :style => "default", :bucket => nil, :comment => nil }.merge(opts||{})
        
    comment = nil
    
    if opts[:comment]
      if opts[:comment].is_a?(FeaturedComment)
        comment = opts[:comment]
      else
        begin
          comment = FeaturedComment.find(opts[:comment])
        rescue
          return ''
        end
      end
    elsif opts[:bucket]
      bucket = FeaturedCommentBucket.find(opts[:bucket])
      comment = bucket.comments.published.first()
    else
      comment = FeaturedComment.published.first()
    end
    
    if comment && comment.content
      #begin
        return render(:partial => "shared/featured_comment/#{opts[:style]}", :object => comment, :as => :comment)
      #rescue
      #  return render(:partial => "shared/featured_comment/default", :object => comment, :as => :comment)          
      #end
    end
  end
  
  #----------
  
  def comment_widget_for(object, options={})
    if object.present? && object.respond_to?(:has_comments?) && object.has_comments?
      render('shared/cwidgets/comment_count', { content: object, cssClass: "" }.merge!(options))
    end
  end
  
  #----------
  
  def comment_count_for(object, options={})
    if object.present? && object.respond_to?(:has_comments?) && object.has_comments?
      options[:class] = "comment_link #{options[:class]}"
      link_to( (object.respond_to?(:comment_count) && object.comment_count > 0 ) ? "Comments (#{object.comment_count})" : "Add your comments", object.link_path(anchor: "comments"), options)
    end
  end
  
  #----------
  
  def comments_for(object, options={})
    if object.present? && object.respond_to?(:has_comments?) && object.has_comments?
      render('shared/cwidgets/comments', { content: object, cssClass: "" }.merge!(options))
    end
  end
  
  #----------
  
  def related_for(object, options={})
    if object.present? and object.is_a?(ContentBase)
      render "shared/cwidgets/related_content_and_links", content: object
    end
  end
  
  #----------
  
  def article_meta_for(object, options={})
    render('shared/cwidgets/article_meta', { content: object }.merge!(options)) if object.present?
  end
  
  def social_tools_for(object, options={})
    if object.present?
      options[:path] ||= object.link_path if object.respond_to?(:link_path)
      render "shared/cwidgets/social_tools", { :content => object, cssClass: "" }.merge!(options)
    end
	end
end