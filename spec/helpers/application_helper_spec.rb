require 'spec_helper'

describe ApplicationHelper do
  describe "#pretty_date" do
    before :each do
      @date = Time.now
    end
    
    it "returns the default if a format isn't specified" do
      helper.pretty_date(@date).should eq @date.strftime("%b %e, %Y")
    end
    
    it "returns a `numbers` format" do
      helper.pretty_date(@date, format: :numbers).should eq @date.strftime("%m-%e-%y")
    end
    
    it "returns a `full` format" do
      helper.pretty_date(@date, format: :full).should eq @date.strftime("%B #{@date.day.ordinalize}, %Y")
    end
    
    it "accepts a custom format" do
      helper.pretty_date(@date, format: :custom, with: "%D").should eq @date.strftime("%D")
    end
  end
  
  describe "#any_to_list?" do
    it "returns the block if there are records" do
      records = (1..5)
      any_to_list?(records) { "Records list" }.should eq "Records list"
    end
    
    it "returns a default message if there are no records and no message is specified" do
      records = []
      any_to_list?(records) { "Records list" }.should eq "There are currently no Arrays" # fascinating list of arrays
    end
    
    it "returns a specified message if there are no records" do
      records = []
      any_to_list?(records, message: "None!") { "Records list" }.should eq "None!"
    end
    
    it "returns true if there are records and no block is given" do
      records = (1..5)
      any_to_list?(records).should be_true
    end
    
    it "returns false if there are no records and no block is given" do
      records = []
      any_to_list?(records).should be_false
    end
  end
  
  describe "#byline" do
    it "returns a comma-separated list of bylines if they exist" do
      pending
      # bylines = create_list :byline, 2
      # helper.byline(bylines).should eq "<a href=\"#\">Name 1</a>, <a href=\"#\">Name 2</a>"
    end
    
    it "returns `KPCC` if no bylines exist" do
      bylines = []
      helper.byline(bylines).should eq "KPCC"
    end
  end
end
