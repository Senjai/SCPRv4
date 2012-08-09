require "spec_helper"

describe ContentEmail do
  describe "attributes" do
    it { should respond_to :name }
    it { should respond_to :name= }
    it { should respond_to :email }
    it { should respond_to :email= }
    it { should respond_to :subject }
    it { should respond_to :subject= }
    it { should respond_to :body }
    it { should respond_to :body= }
    it { should respond_to :content }
    it { should respond_to :content= }
  end

  #-----------

  describe "validations" do
    it { should validate_presence_of :email }
    it { should validate_presence_of :name }
    it { should validate_format_of(:email).with(/.+@.+\..+/) }
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
                            name: "Bricker", 
                            email: "bricker@bricker.com", 
                            content: content
                        
      content_email.name.should     eq "Bricker"
      content_email.email.should    eq "bricker@bricker.com"
      content_email.content.should  eq content
    end
  end
  
  #-----------
  
  describe "save" do
    context "valid" do
      let(:content)       { create :news_story }
      let(:content_email) { build :content_email, 
                            name: "Bricker", 
                            email: "bricker@bricker.com", 
                            content: content
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
      let(:content_email) { build :content_email, email: "invalid" }

      it "returns false" do
        content_email.save.should eq false
      end
      
      it "does not deliver the e-mail" do
        ActionMailer::Base.deliveries.size.should eq 0
      end
    end
  end
end
