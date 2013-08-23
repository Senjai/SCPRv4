class RootPathController < ApplicationController
  include FlatpageHandler
  include CategoryHandler

  respond_to :html, :xml, :rss

  def handle_path
    begin
      # Rails strips out beginning and trailing slashes
      # http://scpr.org/support/members -> support/members
      path = URI.encode(params[:path].to_s)
    rescue ArgumentError
      # If you don't pass the URI.encode test, 
      # then you get NOTHING.
      # http://www.youtube.com/watch?v=xKG07305CBs
      render status: :bad_request and return
    end

    if @flatpage = Flatpage.visible.find_by_path(path.downcase)
      handle_flatpage and return
    else
      # Only do the gsubbing if necessary
      slug = path.gsub(/\A\/?(.+)\/?\z/, "\\1").downcase

      if @category = Category.find_by_slug(slug)
        handle_category and return
      else
        render_error(404, ActionController::RoutingError.new("Not Found")) and return false
      end
    end
  end
end
