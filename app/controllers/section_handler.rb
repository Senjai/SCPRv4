module SectionHandler
  def handle_section
    @content = @section.content(page: params[:page].to_i)
    respond_with @content, template: 'sections/show'
  end
end
