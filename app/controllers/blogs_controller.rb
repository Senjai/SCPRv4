class BlogsController < ApplicationController
  before_filter :load_blog, :except => :index

  caches_action :blog_tagged, if: proc { params[:blog] == "multiamerican" }
  caches_action :entry, if: proc { params[:blog] == "multiamerican" }
  
  respond_to :html, :xml, :rss

  #----------
  
  def index
    @blogs          = Blog.active.order("name")
    @news_blogs     = @blogs.local.is_news
    @non_news_blogs = @blogs.local.is_not_news
    @remote_blogs   = Blog.remote.order("name")
    render layout:    "application"
  end
  
  #----------
  
  def show
    # Only want to paginate for HTML response
    @scoped_entries = @blog.entries.published
    @entries = @scoped_entries.paginate(page: params[:page], per_page: 5)
    respond_with @scoped_entries
  end
  
  #----------
  
  def entry
    @entry = @blog.entries.published.find(params[:id])
  end
  
  # Map old paths from "other blogs"
  def legacy_path
    date = Date.new(params[:year].to_i, params[:month].to_i)
    slug = params[:slug][0,50]
    
    blog_entry = BlogEntry.published
      .where(
        "published_at > ? and published_at < ? and slug = ?", 
        date, date + 1.month, slug
      ).first!

    redirect_to blog_entry.link_path, permanent: true
  end
  
  #----------
  
  def blog_tags
    @recent = @blog.tags.order("blogs_entry.published_at desc")
  end
  
  #----------
  
  def blog_tagged
    @tag = Tag.where(:slug => params[:tag]).first
    
    # In this case we want to redirect, in case people just
    # start guessing random tags
    if !@tag
      redirect_to blog_tags_path(@blog.slug) and return
    end
    
    # now we have to limit tagged content to only this blog
    @entries = @tag.tagged.where(content_type: "BlogEntry")
                   .joins("left join blogs_entry on blogs_entry.id = taggit_taggeditem.content_id")
                   .where("blogs_entry.blog_id = ? and blogs_entry.status = ?",@blog.id, ContentBase::STATUS_LIVE)
                   .order("blogs_entry.published_at desc")
                   .paginate(:page => params[:page] || 1, :per_page => 5)
  end
  
  #----------
  
  def category
    @category = BlogCategory.where(slug: params[:category],
                                      blog_id: @blog.id).first!
                                    
    @entries = @category.blog_entries
                        .published
                        .order("blogs_entry.published_at desc")
                        .paginate(page: params[:page] || 1, per_page: 5)
    
    @BLOGTITLE_EXTRA = ": #{@category.title}"
    @MESSAGE = "There are no blog posts for <b>#{@blog.name}</b> " \
               "listed under <b>#{@category.title}</b>.".html_safe
               
    render 'show'
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
              ).paginate(page: params[:page] || 1, per_page: 5)
   
    datestr = "#{date.strftime("%B")}, #{date.year}"
    @BLOGTITLE_EXTRA = ": #{datestr}"
    @MESSAGE = "There are no blog posts for <b>#{@blog.name}</b> " \
              "for <b>#{datestr}</b>.".html_safe
  
    render 'show'
  end
  
  #----------
  
  protected
    def load_blog
      @blog = Blog.local.find_by_slug!(params[:blog])
      @authors = @blog.authors
    end    
end
