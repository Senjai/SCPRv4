class FlatpagesController < ApplicationController
  TEMPLATE_MAP = {
    "full"    => "app_nosidebar",
    "forum"   => "forum",
    "none"    => false
  }

  def show
    # params[:flatpage_path] gets its slashes stripped by route globbing
    @flatpage = Flatpage.visible.find_by_url!("/#{params[:flatpage_path].downcase}/")
    
    # Is this a redirect? Send them on their way.
    if @flatpage.is_redirect?
      redirect_to @flatpage.redirect_url and return
    end
      
    render layout: layout_template
  end

  private

  def layout_template
    template = TEMPLATE_MAP[@flatpage.template]
    template.nil? ? "application" : template
  end
end
