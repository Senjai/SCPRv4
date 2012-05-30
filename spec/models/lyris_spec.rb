require "spec_helper"

describe Lyris do
  describe "#add_message" do
    before :each do
      @alert = create :breaking_news_alert, send_email: true
      @lyris = Lyris.new(@alert)
    end
    
    it "returns message id" do
      FakeWeb.register_uri(:post, Lyris::API_ENDPOINT, body: xml_response("success"))
      @msg_id = @lyris.add_message
      @msg_id.should eq "12345"
    end
  end
end