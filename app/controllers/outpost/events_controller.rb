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
    column :etype,         header: "Type", display: proc { Event::EVENT_TYPES[self.etype] }
    column :kpcc_event,    header: "KPCC Event?"
    column :is_published,  header: "Published?"
  
    filter :kpcc_event, title: "KPCC Event?", collection: :boolean
    filter :etype, title: "Type", collection: -> { Event.event_types_select_collection }
    filter :is_published, title: "Published?", collection: :boolean
  end

  #------------------

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
