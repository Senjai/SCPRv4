class Admin::NewsStoriesController < Admin::ResourceController
  #----------------
  # Outpost
  self.model = NewsStory

  define_list do
    list_default_order "updated_at"
    list_default_sort_mode "desc"
    
    column :headline
    column :byline
    column :audio
    column :published_at, sortable: true, default_sort_mode: "desc"
    column :status
    column :updated_at, sortable: true, default_sort_mode: "desc"
    
    filter :status, collection: -> { ContentBase.status_text_collect }
    filter :bylines, collection: -> { Bio.select_collection }
  end

  #----------------

  def preview
    @story = ContentBase.obj_by_key(params[:obj_key]) || NewsStory.new
    
    with_rollback @story do
      @story.assign_attributes(params[:news_story])

      if @story.unconditionally_valid?
        @title = @story.to_title
        render "/news/_story", layout: "admin/preview/application", locals: { story: @story }
      else
        render_preview_validation_errors(@story)
      end
    end
  end
end
