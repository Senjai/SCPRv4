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
      options[:class] = "comment_link social_disq #{options[:class]}"
      options["data-objkey"] = object.obj_key
      link_to( "Add your comments", object.link_path(anchor: "comments"), options )
    end
  end
  
  #----------
  
  def comments_for(object, options={})
    if object.present? && object.respond_to?(:has_comments?) && object.has_comments?
      render('shared/cwidgets/comments', { content: object, cssClass: "", header: true }.merge!(options))
    end
  end
  
  #----------
  
  def content_widget(partial, object, options={})
    if object.present? and object.is_a?(ContentBase)
      partial = partial.chars.first == "/" ? partial : "shared/cwidgets/#{partial}"
      render(partial, { content: object, cssClass: "" }.merge!(options))
    end
  end
end
