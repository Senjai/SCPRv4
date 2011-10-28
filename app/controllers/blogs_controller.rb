class BlogsController < ApplicationController
  layout "blog"
  
  def index
    @blogs = Blog.active
  end
  
  def show
    @blog = Blog.where(:slug => params[:blog]).first
    
  end
  
  def entry
    @blog = Blog.where(:slug => params[:blog]).first
    @entry = @blog.entries.published.find(params[:id])
  end
end