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
  
  def comment_count_for(object, options={})
    options[:class] = "comment_link #{options[:class]}"
    link_to "Comments (#{object.comment_count})", object.link_path(anchor: "comments"), options
  end
  
  def article_meta_for(object)
    render 'shared/cwidgets/article_meta', content: object
  end
  
  def recent_posts(entries)
    render "blogs/recent_posts", entries: entries
  end
  
end