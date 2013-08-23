require "spec_helper"

describe Flatpage do
  describe "scopes" do
    describe "visible" do
      it "only selects flatpages with is_public true" do
        is_public  = create :flatpage, is_public: true
        not_public = create :flatpage, is_public: false
        Flatpage.visible.should eq [is_public]
      end
    end
  end

  describe 'path format validation' do
    it 'validates that there is a slash at the beginning and end' do
      flatpage = build :flatpage
      flatpage.path = "support/whatever/stuff"
      flatpage.should_not be_valid

      flatpage.path = "/support/whatever/stuff"
      flatpage.should_not be_valid

      flatpage.path = "support/whatever/stuff/"
      flatpage.should_not be_valid

      flatpage.path = "/support/whatever/stuff/"
      flatpage.should be_valid
    end
  end

  #--------------------
 
  describe "downcase_path" do
    it "runs before validation" do
      flatpage = build :flatpage, path: "/HELLO/"
      flatpage.save
      flatpage.path.should_not match /HELLO/
      flatpage.path.should match /hello/
    end
  end

  #--------------------

  describe '#is_redirect?' do
    it "is true if redirect_to is present" do
      flatpage = build :flatpage, redirect_to: "/bros/"
      flatpage.is_redirect?.should eq true
    end

    it "is false if redirect_to is blank" do
      flatpage = build :flatpage, redirect_to: ""
      flatpage.is_redirect?.should eq false
    end
  end
end
