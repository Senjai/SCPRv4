class Admin::TicketsController < Admin::BaseController
  respond_to :html, :js
  before_filter :get_ticket, only: [:agree, :update, :destroy]
  
  #----------------
  
  def index
    @records = Ticket.all
    respond_with @records
  end
  
  #----------------
  
  def new
    @ticket  = Ticket.new
    @tickets = Ticket.open
    respond_with @ticket
  end

  #----------------
  
  def create
    @ticket = Ticket.new(params[:ticket])
    @ticket.user = admin_user
    @ticket.save
    respond_with @ticket
  end

  #----------------
  
  def agree
  end

  #----------------
  
  def update
    @ticket.update_attributes(params[:ticket])
    # do more things
  end

  #----------------
  
  def destroy
    @ticket.destroy
    # do more things
  end
  
  #----------------
  
  protected
  
  def get_ticket
    @ticket = Ticket.find(params[:id])
  end
end
