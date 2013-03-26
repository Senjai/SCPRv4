class Outpost::EventsController < Outpost::ResourceController
  #------------------
  # Outpost
  self.model = Event

  define_list do
    list_default_order "starts_at"
    list_default_sort_mode "desc"

    column :headline
    column :starts_at, sortable: true, default_sort_mode: "desc"
    column :location_name, header: "Location"
    column :event_type,         header: "Type", display: proc { Event::EVENT_TYPES[self.event_type] }
    column :is_kpcc_event,    header: "KPCC Event?"
    column :status
  
    filter :is_kpcc_event, title: "KPCC Event?", collection: :boolean
    filter :event_type, title: "Type", collection: -> { Event.event_types_select_collection }
    filter :status, title: "Status", collection: -> { Event.status_select_collection }
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
