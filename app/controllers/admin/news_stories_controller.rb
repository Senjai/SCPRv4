class Admin::NewsStoriesController < Admin::ResourceController
  def preview
    @story = ContentBase.obj_by_key(params[:obj_key]) || NewsStory.new
    
    with_rollback @story do
      @story.assign_attributes(params[:news_story])

      if @story.unconditionally_valid?
        @title = @story.to_title
        render "/news/_story", layout: "/admin/preview/application", locals: { story: @story }
      else
        render_preview_validation_errors(@story)
      end
    end
  end
end
