class BlogsController < ApplicationController
  before_filter :load_blog, :except => [:index, :entry]
  respond_to :html, :xml, :rss
  
  #----------
  
  def index
    @blogs          = Blog.active.order("name")
    @news_blogs     = @blogs.where(is_remote: false, is_news: true)
    @non_news_blogs = @blogs.where(is_remote: false, is_news: false)
    @remote_blogs   = Blog.where(is_remote: true).order("name")
    render layout:    "application"
  end
  
  #----------
  
  def show
    # Only want to paginate for HTML response
    @scoped_entries = @blog.entries.published
    @entries = @scoped_entries.page(params[:page]).per(5)
    respond_with @scoped_entries
  end
  
  #----------
  
  def entry
    @entry = BlogEntry.published.includes(:blog).find(params[:id])
    @blog  = @entry.blog
  end

  #----------
  
  def blog_tagged
    @tag = Tag.where(slug: params[:tag]).first!
    @entries = @blog.entries.published.joins(:tags).where(taggit_tag: { slug: @tag.slug }).page(params[:page]).per(5)
  end

  #----------
  
  # Process the form values for Archive and redirect to canonical URL
  def process_archive_select
    year = params[:archive]["date(1i)"].to_i
    month = "%02d" % params[:archive]["date(2i)"].to_i
    
    redirect_to blog_archive_path(@blog.slug, year, month) and return
  end
  
  def archive
    date = Date.new(params[:year].to_i, params[:month].to_i)
    @entries = @blog.entries.published.where(
                "published_at >= ? AND published_at < ?", date.beginning_of_month, date.end_of_month
              ).page(params[:page]).per(5)
   
    datestr = "#{date.strftime("%B")}, #{date.year}"
    @BLOGTITLE_EXTRA = ": #{datestr}"
    @MESSAGE = "There are no blog posts for <b>#{@blog.name}</b> " \
              "for <b>#{datestr}</b>.".html_safe
  
    render 'show'
  end
  
  #----------
  
  protected

  def load_blog
    @blog = Blog.where(is_remote: false).includes(:authors).find_by_slug!(params[:blog])
  end
end
