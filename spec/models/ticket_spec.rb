require "spec_helper"

describe Ticket do  
  describe "publishing to redis" do
    let(:ticket) { build :ticket, status: Ticket::STATUS_OPEN }
    
    it "publishes to redis if status changed" do
      $redis.should_receive(:publish).twice

      ticket.save!
      ticket.status = Ticket::STATUS_CLOSED
      ticket.save!
    end
    
    it "doesn't publish if status was not changed" do
      ticket.save!
      $redis.should_not_receive(:publish)
      
      ticket.summary = "A new summary"
      ticket.save!
    end
  end
end
