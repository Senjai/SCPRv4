class RootPathController < ApplicationController
  include FlatpageHandler
  include CategoryHandler
  include SectionHandler

  respond_to :html, :xml, :rss

  def handle_path
    path = URI.encode(params[:path].to_s.encode('UTF-8', invalid: :replace))

    if @flatpage = Flatpage.visible.find_by_url("/#{path.downcase}/")
      handle_flatpage and return
    else
      # No need to do this gsubbing if we don't need to.
      slug = path.gsub(/\A\/?(.+)\/?\z/, "\\1").downcase

      if @category = Category.find_by_slug(slug)
        handle_category and return
      elsif @section = Section.find_by_slug(slug)
        handle_section and return
      else
        render_error(404, ActionController::RoutingError.new("Not Found")) and return
      end
    end
  end
end
