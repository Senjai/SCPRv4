class Admin::MultiAmericanController < Admin::BaseController
  require 'will_paginate/array'
  before_filter :load_doc
  
  def index    
    
    # @all_attachments = @all_posts.select { |item| item.post_type == "attachment" }
    # @attachments = @all_attachments.paginate(page: params[:attachments_page], per_page: 20)
    # 
    # 
    # @all_tags = @doc.parse_to_objects(:tag)
    # @tags = @all_tags.paginate(page: params[:tags_page], per_page: 100)
  end
  
  def posts
    breadcrumb "Posts"
    @posts = @doc.posts.paginate(page: params[:posts_page], per_page: 20)
  end
  
  def show_post
    breadcrumb "Posts", admin_multi_american_posts_path
    @post = @doc.posts.find { |p| p.post_id == params[:id] }
  end
  
  protected
    def load_doc
      @doc = WP::Document.new("#{Rails.root}/lib/multi_american/XML/full_dump.xml")
    end
end