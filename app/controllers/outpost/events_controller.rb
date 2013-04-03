class Outpost::EventsController < Outpost::ResourceController
  outpost_controller
  
  define_list do |l|
    l.default_order = "starts_at"
    l.default_sort_mode = "desc"

    l.column :headline
    l.column :starts_at, sortable: true, default_sort_mode: "desc"
    l.column :location_name, header: "Location"
    l.column :event_type,         header: "Type", display: ->(r) { Event::EVENT_TYPES[r.event_type] }
    l.column :is_kpcc_event,    header: "KPCC?"
    l.column :status
  
    l.filter :is_kpcc_event, title: "KPCC Event?", collection: :boolean
    l.filter :event_type, title: "Type", collection: -> { Event.event_types_select_collection }
    l.filter :status, title: "Status", collection: -> { Event.status_select_collection }
  end

  #------------------

  def preview
    @event = ContentBase.obj_by_key(params[:obj_key]) || Event.new
    
    with_rollback @event do
      @event.assign_attributes(params[:event])

      if @event.unconditionally_valid?
        @title = @event.to_title
        render "/events/_event", layout: "outpost/preview/application", locals: { event: @event }
      else
        render_preview_validation_errors(@event)
      end
    end
  end
end
