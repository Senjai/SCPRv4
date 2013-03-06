class Outpost::TicketsController < Outpost::ResourceController
  #---------------
  # Outpost
  self.model = Ticket

  define_list do
    list_default_order "status"
    list_default_sort_mode "desc"
    
    column :user
    column :id, header: "#", sortable: true, default_sort_mode: "desc"
    column :summary
    column :created_at, sortable: true, default_sort_mode: "desc"
    column :status, display: :display_ticket_status, sortable: true, default_sort_mode: "desc"
    
    filter :status, collection: -> { Ticket.status_text_collection }
    filter :user_id, collection: -> { AdminUser.select_collection }
  end

  #---------------

  before_filter :authorize_resource, only: [:edit, :update, :destroy]
  
  #---------------
  # Override this method from Outpost::ResourceController
  # Users should always be able to update their
  # own tickets.
  def authorize_resource
    if admin_user == @record.user or admin_user.is_superuser?
      return true
    else
      redirect_to admin_tickets_path, alert: "You don't have permission to edit that Ticket."
      return false
    end
  end
  
  #----------------
  # Override Outpost default of edit redirect.
  # Show is actually useful for us here.
  def show
    @record = Ticket.find(params[:id])
    respond_with @record
  end
  
  #----------------
  # Override this method so that we can inject the user
  def create
    @ticket = Ticket.new(params[:ticket])
    @ticket.user = admin_user
    
    if @ticket.save
      # Need to set the @record var so that we can 
      # use the requested_location method
      @record = @ticket
      
      notice "Saved #{@ticket.simple_title}"
      respond_with do |format|
        format.html { redirect_to requested_location }
        format.js { render :create }
      end
    else
      breadcrumb "New"
      respond_with do |format|
        format.html { render :new }
        format.js   { render :create }
      end
    end
  end
end
