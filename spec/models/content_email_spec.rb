require "spec_helper"

describe ContentEmail do
  describe "attributes" do
    it { should respond_to :from_name }
    it { should respond_to :from_name= }
    it { should respond_to :from_email }
    it { should respond_to :from_email= }
    it { should respond_to :to_email }
    it { should respond_to :to_email= }
    it { should respond_to :subject }
    it { should respond_to :subject= }
    it { should respond_to :body }
    it { should respond_to :body= }
    it { should respond_to :lname }
    it { should respond_to :lname= }
    it { should respond_to :content }
    it { should respond_to :content= }
  end

  #-----------

  describe "validations" do
    it { should validate_presence_of :from_email }
    it { should validate_presence_of :to_email }
    it { should validate_presence_of :content }
    it { should allow_value("other-guy@gmail.com").for(:from_email).with_message(/Invalid/) }
    it { should allow_value("other-guy@gmail.com").for(:to_email).with_message(/Invalid/) }
    it { should_not allow_value("noway jose @ whatever").for(:to_email).with_message(/Invalid/) }
    it { should_not allow_value("nowayjose@whatever").for(:from_email).with_message(/Invalid/) }
    it { should ensure_length_of(:lname).is_at_most(0) }
  end

  #-----------

  describe "persisted?" do
    it "is false" do
      build(:content_email).persisted?.should be_false
    end
  end

  #-----------
  
  describe "initialize" do
    it "sets all attributes passed in" do
      content       = create :news_story
      content_email = build :content_email, 
                            from_name:  "Bricker", 
                            from_email: "bricker@bricker.com", 
                            to_email:   "bricker@scpr.org", 
                            content:    content
                        
      content_email.from_name.should  eq "Bricker"
      content_email.from_email.should eq "bricker@bricker.com"
      content_email.to_email.should   eq "bricker@scpr.org"
      content_email.content.should    eq content
    end
  end
  
  #-----------
  
  describe "save" do
    context "valid" do
      let(:content)       { create :news_story }
      let(:content_email) { build :content_email, 
                            from_email: "bricker@bricker.com", 
                            to_email:   "bricker@scpr.org",
                            content:    content
                          }
                          
      it "delivers the email" do
        ActionMailer::Base.deliveries.size.should eq 0
        content_email.save
        ActionMailer::Base.deliveries.size.should eq 1
      end
      
      it "returns self" do
        content_email.save.should eq content_email
      end
    end
    
    context "invalid" do
      let(:content_email) { build :content_email, to_email: "invalid" }

      it "returns false" do
        content_email.save.should eq false
      end
      
      it "does not deliver the e-mail" do
        ActionMailer::Base.deliveries.size.should eq 0
      end
    end
  end
  
  #-----------
  
  describe "from" do
    it "returns the from_name if it's available" do
      content_email = build :content_email, from_name: "Bryan"
      content_email.from.should eq content_email.from_name
    end
    
    it "returns the from_email if from_name isn't available" do
      content_email = build :content_email, from_name: nil
      content_email.from.should eq content_email.from_email
    end
  end
end
