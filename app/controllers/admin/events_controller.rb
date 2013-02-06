class Admin::EventsController < Admin::ResourceController
  def preview
    @event = ContentBase.obj_by_key(params[:obj_key]) || Event.new
    
    with_rollback @event do
      @event.assign_attributes(params[:event])

      if @event.unconditionally_valid?
        @title = @event.to_title
        render "/events/_event", layout: "admin/preview/application", locals: { event: @event }
      else
        render_preview_validation_errors(@event)
      end
    end
  end
end
