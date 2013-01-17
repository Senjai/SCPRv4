class Admin::EventsController < Admin::ResourceController
  def preview
    @event = ContentBase.obj_by_key(params[:obj_key])
    @event.assign_attributes(params[:event])
    @title = @event.to_title
    
    render "/events/_event", layout: "/admin/preview", locals: { event: @event }
  end
end
