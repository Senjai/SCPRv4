require "spec_helper"

describe Concern::Callbacks::SetPublishedAtCallback do
  subject { build :test_class_story }

  #-----------------

  describe "#should_set_published_at_to_now?" do
    it "is true if the object is published but doesn't have a published_at date" do
      subject.status = ContentBase::STATUS_LIVE
      subject.published_at = nil
      subject.should_set_published_at_to_now?.should eq true
    end

    it "is false if not published" do
      subject.status = ContentBase::STATUS_DRAFT
      subject.should_set_published_at_to_now?.should eq false
    end

    it "is false if published_at is present" do
      subject.status = ContentBase::STATUS_LIVE
      subject.published_at = Time.now
      subject.should_set_published_at_to_now?.should eq false
    end
  end

  #-----------------

  describe "#set_published_at_to_now" do
    context "should_set_published_at_to_now is true" do
      before :each do
        subject.stub(:should_set_published_at_to_now?) { true }
      end

      it "sets published at to now" do
        t = Time.now
        Time.stub(:now) { t }

        subject.save!
        subject.published_at.should eq t
      end
    end

    context "should_set_published_at_to_now is false" do
      before :each do
        subject.stub(:should_set_published_at_to_now?) { false }
        subject.status = ContentBase::STATUS_DRAFT
      end

      it "does not set published at to now" do
        t = Time.now
        Time.stub(:now) { t }

        subject.save!
        subject.published_at.should be_nil
      end
    end
  end

  #-----------------

  describe "#should_set_published_at_to_nil?" do
    it "is true if the object is not published and the published_at date is set" do
      subject.status = ContentBase::STATUS_DRAFT
      subject.published_at = Time.now
      subject.should_set_published_at_to_nil?.should eq true
    end

    it "is false if object is published" do
      subject.published_at = Time.now
      subject.should_set_published_at_to_nil?.should eq false
    end
  end

  #-----------------

  describe "#set_published_at_to_nil" do
    context "should_set_published_at_to_nil? is true" do
      before :each do
        subject.published_at = Time.now - 1.hour
        subject.status = ContentBase::STATUS_DRAFT
        subject.stub(:should_set_published_at_to_nil?) { true }
        subject.published_at.should_not be_nil
        subject.save!
      end

      it "sets published_at to nil" do
        subject.published_at.should eq nil
      end
    end

    context "should_set_published_at_to_nil? is false" do
      before :each do
        subject.published_at = Time.now
        subject.stub(:should_set_published_at_to_nil?) { false }
        subject.published_at.should_not be_nil
        subject.save!
      end

      it "does not set published_at to nil" do
        subject.published_at.should_not be_nil
      end
    end
  end
end
