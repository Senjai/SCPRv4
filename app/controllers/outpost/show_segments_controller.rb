class Outpost::ShowSegmentsController < Outpost::ResourceController
  #----------------
  # Outpost
  self.model = ShowSegment

  define_list do
    list_default_order "updated_at"
    list_default_sort_mode "desc"
    
    column :headline
    column :show
    column :byline
    column :audio
    column :published_at, sortable: true, default_sort_mode: "desc"
    column :status
    column :updated_at, sortable: true, default_sort_mode: "desc"
    
    filter :show_id, collection: -> { KpccProgram.select_collection }
    filter :bylines, collection: -> { Bio.select_collection }
    filter :status, collection: -> { ContentBase.status_text_collect }
  end

  #----------------

  def preview
    @segment = ContentBase.obj_by_key(params[:obj_key]) || ShowSegment.new
    
    with_rollback @segment do
      @segment.assign_attributes(params[:show_segment])

      if @segment.unconditionally_valid?
        @title = @segment.to_title
        render "/programs/_segment", layout: "admin/preview/application", locals: { segment: @segment }
      else
        render_preview_validation_errors(@segment)
      end
    end
  end
end
