require "spec_helper"

describe Concern::Associations::BylinesAssociation do
  subject { TestClass::Story.new }
  
  describe "associations" do
    it { should have_many(:bylines).class_name("ContentByline").dependent(:destroy) }
  end
  
  #--------------------
  
  describe "#byline" do
    let(:elements) { ["Bryan and John", "Danny", "Cindy"] }
    
    before :each do
      subject.stub(:joined_bylines) { elements }
    end
    
    it "sends to #joined_bylines and ContentByline.digest" do
      ContentByline.should_receive(:digest).with(elements)
      subject.byline
    end
    
    it "returns the full byline" do
      subject.byline.should eq "Bryan and John with Danny | Cindy"
    end
  end
  
  #--------------------
  
  describe "#byline_extras" do
    it "is an array" do
      subject.byline_extras.should be_a Array
    end
  end
  
  #--------------------

  describe "#grouped_bylines" do
    before :each do
      @record = TestClass::Story.create!(headline: "Headline", body: "Body", slug: "slug1", published_at: Time.now, status: ContentBase::STATUS_LIVE)
    
      @primary      = create :byline, role: ContentByline::ROLE_PRIMARY, content: @record
      @secondary    = create :byline, role: ContentByline::ROLE_SECONDARY, content: @record
      @contributing = create :byline, role: ContentByline::ROLE_CONTRIBUTING, content: @record
      @record.stub(:byline_extras) { ["KPCC"] }
    
      @record.reload
    end
    
    it "is a hash of grouped bylines!" do
      @record.grouped_bylines[:primary].should eq [@primary]
      @record.grouped_bylines[:secondary].should eq [@secondary]
      @record.grouped_bylines[:contributing].should eq [@contributing]
      @record.grouped_bylines[:extra].should eq ["KPCC"]
    end
  end
  
  #--------------------
  
  describe "#joined_bylines" do
    before :each do
      @record = TestClass::Story.create!(headline: "Headline", body: "Body", slug: "slug1", published_at: Time.now, status: ContentBase::STATUS_LIVE)
    
      create :byline, role: ContentByline::ROLE_PRIMARY, name: "Bryan", content: @record
      create :byline, role: ContentByline::ROLE_SECONDARY, name: "Danny", content: @record
      create :byline, role: ContentByline::ROLE_CONTRIBUTING, name: "Whitney", content: @record
      @record.stub(:byline_extras) { ["KPCC"] }
    
      @record.reload
    end
    
    context "without block" do
      it "joins each role into a string and returns an array of those strings" do
        @record.joined_bylines(:primary).should eq ["Bryan"]
        @record.joined_bylines(:secondary).should eq ["Danny"]
        @record.joined_bylines(:contributing).should eq ["Whitney"]
        @record.joined_bylines(:extra).should eq ["KPCC"]
        @record.joined_bylines(:primary, :secondary, :contributing, :extra).should eq ["Bryan", "Danny", "Whitney", "KPCC"]
      end
      
      it "Turns it into a sentence if there are multiple bylines" do
        create :byline, role: ContentByline::ROLE_PRIMARY, name: "John", content: @record
        @record.stub(:byline_extras) { ["KPCC", "SCPR"] }
        
        bylines = @record.joined_bylines(:primary, :secondary, :contributing, :extra)
        bylines.should eq ["Bryan and John", "Danny", "Whitney", "KPCC | SCPR"]
      end
    end
    
    context "with block" do
      it "sends primary, seconday, and contributing to the block" do
        elements = @record.joined_bylines(:primary, :secondary, :contributing) do |bylines|
          bylines.map { |b| b.name << " Ricker" }
        end
        
        elements.should eq ["Bryan Ricker", "Danny Ricker", "Whitney Ricker"]
      end
      
      it "doesn't pass extra to the block" do
        elements = @record.joined_bylines(:extra) do |bylines|
          bylines.map { |b| b.name << " Ricker" }
        end
        
        elements.should eq ["KPCC"]
      end
    end
  end
end
