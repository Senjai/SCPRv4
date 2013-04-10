class Outpost::ShowSegmentsController < Outpost::ResourceController
  outpost_controller
  
  define_list do |l|
    l.default_order = "updated_at"
    l.default_sort_mode = "desc"
    
    l.column :headline
    l.column :show
    l.column :byline
    l.column :audio
    l.column :published_at, sortable: true, default_sort_mode: "desc"
    l.column :status
    l.column :updated_at, sortable: true, default_sort_mode: "desc"
    
    l.filter :show_id, collection: -> { KpccProgram.select_collection }
    l.filter :bylines, collection: -> { Bio.select_collection }
    l.filter :status, collection: -> { ContentBase.status_text_collect }
  end

  #----------------

  def preview
    @segment = Outpost.obj_by_key(params[:obj_key]) || ShowSegment.new
    
    with_rollback @segment do
      @segment.assign_attributes(params[:show_segment])

      if @segment.unconditionally_valid?
        @title = @segment.to_title
        render "/programs/_segment", layout: "outpost/preview/application", locals: { segment: @segment }
      else
        render_preview_validation_errors(@segment)
      end
    end
  end
end
