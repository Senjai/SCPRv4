require "spec_helper"

describe Lyris do
  describe "#add_message" do
    before :each do
      alert = create :breaking_news_alert, send_email: true
      @lyris = Lyris.new(API_KEYS["lyris"]["site_id"], API_KEYS["lyris"]["password"], API_KEYS["lyris"]["mlid"], alert)
    end
    
    it "Returns false if no alert is provided" do
      @lyris.add_message().should be_false
    end
  end
end