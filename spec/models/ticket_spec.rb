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

  describe "default status" do
    it "sets default status before save if it's blank" do
      ticket = build :ticket, status: nil
      ticket.save!
      ticket.status.should eq Ticket::STATUS_OPEN
    end

    it "doesn't set default status if it's already been set" do
      ticket = build :ticket, status: Ticket::STATUS_CLOSED
      ticket.save!
      ticket.status.should eq Ticket::STATUS_CLOSED
    end
  end
end
