module CategoryHandler
  def handle_category
    @content = @category.content(params[:page].to_i, 15)
    respond_with @content, template: "category/show"
  end
end
