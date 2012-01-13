class BlogsController < ApplicationController
  require 'will_paginate/array'
  layout "blog"
  
  before_filter :load_blog, :except => [:index]
  
  def index
    @blogs = Blog.active
    render :layout => "application"
  end
  
  def show
    @entries = @blog.entries.published.paginate(
      :page => params[:page],
      :per_page => 5
    )

    render :layout => "bloglanding"
  end
  
  def entry
    @entry = @blog.entries.published.find(params[:id])
    @entries = @blog.entries.published.paginate(
      :page => params[:page],
      :per_page => 5
    )
  end
  
  protected
  def load_blog
    @blog = Blog.find_by_slug(params[:blog])
  rescue
    redirect_to blogs_path()
  end
end