class Admin::NewsStoriesController < Admin::ResourceController
  def preview
    @story = ContentBase.obj_by_key!(params[:obj_key])
    
    with_rollback @story do
      @story.assign_attributes(params[:news_story])
      @title = @story.to_title
      render "/news/_story", layout: "/admin/preview/application", locals: { story: @story }
    end
  end
end
