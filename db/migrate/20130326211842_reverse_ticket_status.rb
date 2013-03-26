class ReverseTicketStatus < ActiveRecord::Migration
  def up
    Ticket.all.each do |ticket|
      if ticket.status == 1
        ticket.status = 0
      elsif ticket.status == 0
        ticket.status = 5
      end

      ticket.save!
    end
  end

  def down
  end
end
