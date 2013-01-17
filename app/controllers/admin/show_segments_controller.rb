class Admin::ShowSegmentsController < Admin::ResourceController
  def preview
    @segment = ContentBase.obj_by_key!(params[:obj_key])
    @segment.assign_attributes(params[:show_segment])
    @title = @segment.to_title
    
    render "/programs/_segment", layout: "/admin/preview", locals: { segment: @segment }
  end
end
