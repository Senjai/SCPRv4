class NewsController < ApplicationController
  def story
    @story = NewsStory.published.find(params[:id])
    
    if ( request.env['PATH_INFO'] =~ /\/$/ ? request.env['PATH_INFO'] : "#{request.env['PATH_INFO']}/" ) != @story.link_path
      redirect_to @story.link_path and return
    end
  end
  
  #----------
  
  # map old /news/YYYY/MM/DD/slug URLs to the correct one with ID
  def old_story
    date  = Date.new(params[:year].to_i,params[:month].to_i,params[:day].to_i)
    story = NewsStory.published.where("published_at > ? and published_at < ? and slug = ?",date,(date+1),params[:slug]).first!

    redirect_to story.link_path, permanent: true
  end
end
