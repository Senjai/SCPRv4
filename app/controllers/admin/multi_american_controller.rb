class Admin::MultiAmericanController < Admin::BaseController
  require 'will_paginate/array'
  before_filter :load_doc
  before_filter { |c| c.send(:breadcrumb, "Multi American Import", admin_multi_american_path) }  
  
  def index    
    
  end

  # ---------------
  
  def posts
    breadcrumb "Posts"
    @posts = @doc.posts.paginate(page: params[:page], per_page: 20)
    @total_posts = @doc.posts.size
  end
  
  def post
    breadcrumb "Posts", admin_multi_american_posts_path
    @post = @doc.posts.find { |p| p.post_id == params[:id] }
  end
  
  # ---------------
  
  def jiffy_posts
    breadcrumb "Jiffy Posts"
    @posts = @doc.jiffy_posts.paginate(page: params[:page], per_page: 20)
    @total_posts = @doc.jiffy_posts.size
    render 'posts'
  end
  
  def jiffy_post
    breadcrumb "Jiffy Posts", admin_multi_american_jiffy_posts_path
    @post = @doc.jiffy_posts.find { |p| p.post_id == params[:id] }
    render 'post'
  end
  
  # ---------------

  protected
    def load_doc
      @@doc ||= WP::Document.new("#{Rails.root}/lib/multi_american/XML/full_dump.xml")
      @doc = @@doc
    end
end