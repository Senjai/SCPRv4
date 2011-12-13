class BlogsController < ApplicationController
  layout "blog"
  
  def index
    @blogs = Blog.active
    render :layout => "application"
  end
  
  def show
    @blog = Blog.where(:slug => params[:blog]).first
    @entries = @blog.entries.published.all.last(5).reverse
  end
  
  def entry
    @blog = Blog.where(:slug => params[:blog]).first
    @entry = @blog.entries.published.find(params[:id])
    @entries = @blog.entries.published.all.last(5).reverse
  end
end