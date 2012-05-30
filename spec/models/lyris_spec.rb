require "spec_helper"

describe Lyris do
  describe "#add_message" do
    before :each do
      @alert = create :breaking_news_alert, send_email: true
      @lyris = Lyris.new(@alert)
    end
    
    it "returns message id on success" do
      FakeWeb.register_uri(:post, Lyris::API_ENDPOINT, body: xml_response("success", "12345"))
      @msg_id = @lyris.add_message
      @msg_id.should eq "12345"
    end
    
    it "returns false on error" do
      FakeWeb.register_uri(:post, Lyris::API_ENDPOINT, body: xml_response("error", "missing something"))
      @msg_id = @lyris.add_message
      @msg_id.should eq false
    end
  end
end