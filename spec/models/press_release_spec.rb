require "spec_helper"

describe PressRelease do
  describe '#generate_slug' do
    it "generates slug before validation if it's blank and headline is present" do
      press = build :press_release, short_title: "Hello Hello", slug: nil
      press.save!
      press.slug.should eq "hello-hello"
    end
    
    it "doesn't generate slug if it's present" do
      press = build :press_release, slug: "blah-blah-blah"
      press.save!
      press.slug.should eq "blah-blah-blah"
    end
  end
end
