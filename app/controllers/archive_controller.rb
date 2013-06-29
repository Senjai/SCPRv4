class ArchiveController < ApplicationController
  # Process the form values for Archive and redirect to canonical URL
  def process_form
    year  = params[:archive]["date(1i)"].to_i
    month = "%02d" % params[:archive]["date(2i)"].to_i
    day   = "%02d" % params[:archive]["date(3i)"].to_i

    redirect_to archive_path(year, month, day) and return
  end


  def show
    if params[:year] and params[:month] and params[:day]
      date = Time.new(params[:year].to_i, params[:month].to_i, params[:day].to_i)

      # Only fetch content if the requested date is before today's date
      if date < Time.now.to_date
        @date = date
      end
    end

    if @date
      condition = ["published_at between :today and :tomorrow", today: @date, tomorrow: @date.tomorrow]

      @news_stories   = NewsStory.published.where(condition)
      @show_segments  = ShowSegment.published.where(condition)
      @show_episodes  = ShowEpisode.published.where("air_date=?", @date)
      @blog_entries   = BlogEntry.published.where(condition).includes(:blog)
      @content_shells = ContentShell.published.where(condition)
    end

    render layout: 'application'
  end
end
