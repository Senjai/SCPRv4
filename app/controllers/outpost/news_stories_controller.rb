class Outpost::NewsStoriesController < Outpost::ResourceController
  outpost_controller
  
  define_list do |l|
    l.default_order = "updated_at"
    l.default_sort_mode = "desc"
    
    l.column :headline
    l.column :byline
    l.column :audio
    l.column :published_at, sortable: true, default_sort_mode: "desc"
    l.column :status
    l.column :updated_at, sortable: true, default_sort_mode: "desc"
    
    l.filter :status, collection: -> { ContentBase.status_text_collect }
    l.filter :bylines, collection: -> { Bio.select_collection }
  end

  #----------------

  def preview
    @story = Outpost.obj_by_key(params[:obj_key]) || NewsStory.new
    
    with_rollback @story do
      @story.assign_attributes(params[:news_story])

      if @story.unconditionally_valid?
        @title = @story.to_title
        render "/news/_story", layout: "outpost/preview/application", locals: { story: @story }
      else
        render_preview_validation_errors(@story)
      end
    end
  end
end
