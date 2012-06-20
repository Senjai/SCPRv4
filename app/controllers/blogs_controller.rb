class BlogsController < ApplicationController
  require 'will_paginate/array'
  
  before_filter :load_blog, :except => :index
  
  def index
    @blogs = Blog.active.order("name")
    @news_blogs = @blogs.local.is_news
    @non_news_blogs = @blogs.local.is_not_news
    @remote_blogs = Blog.remote.order("name")
    render :layout => "application"
  end
  
  #----------
  
  def show
    @entries = @blog.entries.published.paginate(page: params[:page], per_page: 5)
  end
  
  #----------
  
  def entry
    @entry = @blog.entries.published.find(params[:id])
    rescue
      raise ActionController::RoutingError.new("Not Found")
  end
  
  #----------
  
  def blog_tags
    @recent = @blog.tags.order("blogs_entry.published_at desc")
  end
  
  #----------
  
  def blog_tagged
    @tag = Tag.where(:slug => params[:tag]).first
    
    if !@tag
      redirect_to blog_tags_path(@blog.slug) and return
    end
    
    # now we have to limit tagged content to only this blog
    @entries = @tag.tagged.where(:content_type => BlogEntry).joins(
      "left join blogs_entry on blogs_entry.id = rails_taggit_taggeditem.content_id"
    ).where("blogs_entry.blog_id = ? and blogs_entry.status = ?",@blog.id, BlogEntry::STATUS_LIVE).order("blogs_entry.published_at desc").paginate(:page => params[:page] || 1, :per_page => 5)
  end
  
  protected
    def load_blog
      if @blog = Blog.local.find_by_slug(params[:blog])
        @authors = @blog.authors
      else
        redirect_to blogs_path and return false
      end
    end    
end