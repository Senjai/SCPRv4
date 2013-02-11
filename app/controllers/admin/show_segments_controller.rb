class Admin::ShowSegmentsController < Admin::ResourceController
  #----------------
  # Outpost
  self.model = ShowSegment

  define_list do
    list_order "updated_at desc"
    
    column :headline
    column :show
    column :byline
    column :audio
    column :published_at
    column :status
    
    filter :show_id, collection: -> { KpccProgram.all.map { |program| [program.to_title, program.id] } }
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

  #----------------

  private
  
  def search_params
    @search_params ||= {
      :order       => :published_at,
      :sort_mode   => :desc
    }
  end 
end
