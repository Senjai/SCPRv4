require "spec_helper"

describe Lyris do
  describe "#generate_input" do
    before :each do
      @alert = create :breaking_news_alert, send_email: true
      @lyris = Lyris.new(@alert)
    end
    
    it "returns a string" do
      @lyris.generate_input.should be_a String
    end
      
    it "accepts a block and passes that into the XML" do
      @lyris.generate_input do |body|
        body.DATA "hello"
      end.should match /<DATA>hello<\/DATA>/
    end
    
    it "always includes the @site_id" do
      @lyris.generate_input.should match %r{#{Lyris::LYRIS_API["site_id"]}}
    end
    
    it "always includes the @mlid" do
      @lyris.generate_input.should match %r{#{Lyris::LYRIS_API["mlid"]}}
    end
    
    it "always includes the @password" do
      @lyris.generate_input.should match %r{#{Lyris::LYRIS_API["password"]}}
    end
  end
  
  describe "#add_message" do
    before :each do
      @alert = create :breaking_news_alert, send_email: true
      @lyris = Lyris.new(@alert)
    end
    
    it "sets @message_id to the message id on success" do
      FakeWeb.register_uri(:post, Lyris::API_ENDPOINT, body: xml_response("success", "12345"))
      @lyris.add_message
      @lyris.instance_variable_get(:@message_id).should eq "12345"
    end
    
    it "sets @message_id to the message id on success" do
      FakeWeb.register_uri(:post, Lyris::API_ENDPOINT, body: xml_response("error", "missing something"))
      @lyris.add_message
      @lyris.instance_variable_get(:@message_id).should be_false
    end
    
    it "returns the value of @message_id" do
      FakeWeb.register_uri(:post, Lyris::API_ENDPOINT, body: xml_response("success", "12345"))
      @lyris.add_message.should eq "12345"
    end
  end
  
  describe "#render_message" do
    before :each do
      @alert = create :breaking_news_alert, send_email: true
      @lyris = Lyris.new(@alert)
    end
    
    it "returns a string" do
      @lyris.render_message("html").should be_a String
    end
    
    it "raises an exception if the template is not found for that format" do
      lambda { @lyris.render_message("json") }.should raise_error
    end
    
    it "renders the correct template" do
      @lyris.render_message("html").should match /<html /
      @lyris.render_message("text").should_not match /<html /
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
    before :each do
      @alert = create :breaking_news_alert, send_email: true
      @lyris = Lyris.new(@alert)
      @input = @lyris.generate_input
    end
    
    it "returns the response data on success" do
      FakeWeb.register_uri(:post, Lyris::API_ENDPOINT, body: xml_response("success", "12345"))
      @lyris.send_request("message", "add", @input).should eq "12345"
    end
    
    it "returns false on error" do
      FakeWeb.register_uri(:post, Lyris::API_ENDPOINT, body: xml_response("error", "missing something"))
      @lyris.send_request("message", "wrong_action", @input).should be_false
    end
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