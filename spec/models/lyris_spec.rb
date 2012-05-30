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
  
  describe "#render_message" do
    before :each do
      @alert = create :breaking_news_alert, send_email: true
      @lyris = Lyris.new(@alert)
    end
    
    it "sets @format_message for each format passed in" do
      @lyris.render_message("html", "text")
      @lyris.instance_variable_get(:@html_message).should be_present
      @lyris.instance_variable_get(:@text_message).should be_present
    end
    
    it "renders as a string" do
      @lyris.render_message("html")
      @lyris.instance_variable_get(:@html_message).class.should eq String
    end
    
    it "raises an exception if the template is not found for that format" do
      lambda { @lyris.render_message("json") }.should raise_error
    end
    
    it "renders the correct template" do
      @lyris.render_message("html", "text")
      @lyris.instance_variable_get(:@html_message).should match /<html /
      @lyris.instance_variable_get(:@text_message).should_not match /<html /
    end
  end
  
  describe "#send_message" do
    before :each do
      @alert = create :breaking_news_alert, send_email: true
      @lyris = Lyris.new(@alert)
    end
    
    it "returns false if an error is returned" do
      FakeWeb.register_uri(:post, Lyris::API_ENDPOINT, body: xml_response("error", "missing something"))
      @lyris.send_message.should be_false
    end
    
    it "returns the message status if success" do
      FakeWeb.register_uri(:post, Lyris::API_ENDPOINT, body: xml_response("success", "scheduled"))
      @lyris.send_message.should match /scheduled/
    end
  end
        
  describe "#send_request" do
    pending
  end
  
  describe "#connection" do
    before :each do
      @alert = create :breaking_news_alert, send_email: true
      @lyris = Lyris.new(@alert)
    end
    
    it "uses the connection if it already exists" do
      @lyris.instance_variable_set(:@connection, "hello")
      @lyris.connection.should eq "hello"
    end
    
    it "instantiates a new connection if one isn't set" do
      @lyris.connection.class.should eq Net::HTTP
    end
  end
end