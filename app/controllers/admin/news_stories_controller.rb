class Admin::NewsStoriesController < Admin::ResourceController
  #----------------
  # Outpost
  self.model = NewsStory

  define_list do
    list_order "updated_at desc"
    
    column :headline
    column :slug
    column :byline
    column :audio
    column :published_at
    column :status
    
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

  #----------------

  private

  def search_params
    @search_params ||= {
      :order       => :published_at,
      :sort_mode   => :desc
    }
  end
end
