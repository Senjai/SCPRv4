require "spec_helper"

describe Concern::Associations::BylinesAssociation do
  subject { TestClass::Story.new }

  describe 'adding bylines' do
    it 'makes the object dirty' do
      # create instead of build so changed? returns false
      # initially
      story  = create :test_class_story, :published
      byline = create :byline
      story.changed?.should eq false

      story.bylines << byline
      story.changed?.should eq true
    end
  end

  describe "sphinx index callback" do
    let(:story) { build :test_class_story, :published }
    let(:bio) { create :bio }
    let(:byline) { create :byline, user: bio }

    before :each do
      story.bylines << byline
    end

    it "should enqueue an index of ContentByline after save" do
      Indexer.should_receive(:enqueue).with("ContentByline")
      Indexer.should_receive(:enqueue).with("TestClass::Story")

      story.save!
    end

    it "should enqueue an index of ContentByline after save if destroying" do
      Indexer.should_receive(:enqueue).with("ContentByline")
      Indexer.should_receive(:enqueue).with("TestClass::Story")

      story.destroy
    end
  end

  #--------------------

  describe "#byline" do
    let(:elements) { { primary: "Bryan and John", secondary: "Danny", extra: "Cindy"} }

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
      @record = create :test_class_story, :published

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
      @record = create :test_class_story, :published

      create :byline, role: ContentByline::ROLE_PRIMARY, name: "Bryan", content: @record
      create :byline, role: ContentByline::ROLE_SECONDARY, name: "Danny", content: @record
      create :byline, role: ContentByline::ROLE_CONTRIBUTING, name: "Whitney", content: @record
      @record.stub(:byline_extras) { ["KPCC"] }

      @record.reload
    end

    context "without block" do
      it "Turns it into a sentence if there are multiple bylines" do
        @record.stub(:byline_extras) { ["KPCC", "SCPR"] }
        create :byline, role: ContentByline::ROLE_PRIMARY, name: "John", content: @record

        @record.joined_bylines.should eq Hash[
          primary: "Bryan and John",
          secondary: "Danny",
          contributing: "Whitney",
          extra: "KPCC | SCPR"
        ]
      end
    end

    context "with block" do
      it "sends primary, seconday, and contributing to the block" do
        elements = @record.joined_bylines do |bylines|
          bylines.map { |b| b.name << " Ricker" }
        end

        elements.should eq Hash[
          primary: "Bryan Ricker",
          secondary: "Danny Ricker",
          contributing: "Whitney Ricker",
          extra: "KPCC"
        ]
      end

      it "doesn't pass extra to the block" do
        elements = @record.joined_bylines do |bylines|
          bylines.map { |b| b.name << " Ricker" }
        end

        elements[:extra].should eq "KPCC"
      end
    end
  end
end
