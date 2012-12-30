class TicketsController < AdminController::Base
  respond_to :html, :js
  
  before_filter :get_record, only: [:agree, :update, :destroy]
  
  #----------------
  
  def index
    @records = Ticket.all
    respond_with @records
  end
  
  #----------------
  
  def new
    @record  = Ticket.new
    @tickets = Ticket.open
    respond_with @ticket
  end

  #----------------
  
  def create
    @record = Ticket.new(params[:ticket])
    @record.save
    # do more things
  end

  #----------------
  
  def agree
  end

  #----------------
  
  def update
    @record.update_attributes(params[:ticket])
    # do more things
  end

  #----------------
  
  def destroy
    @record.destroy
    # do more things
  end
  
  #----------------
  
  protected
  
  def get_record
    @record = Ticket.find(params[:id])
  end
end
