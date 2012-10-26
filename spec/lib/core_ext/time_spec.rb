require 'spec_helper'

describe Time do
  describe "#time_since_epoch" do
    let(:t) { Time.now }
    
    context "seconds" do
      it "returns the seconds since the epoch" do
        t.time_since_epoch(:seconds).should eq t.to_i
      end
    end
    
    context "minutes" do
      it "returns the minutes since the epoch" do
        t.time_since_epoch(:minutes).should eq (t.to_i/60)
      end        
    end
    
    context "hours" do
      it "returns the hours since the epoch" do
        t.time_since_epoch(:hours).should eq (t.to_i/60/60)
      end
    end
    
    context "else" do
      it "raises an ArgumentError" do
        -> { t.time_since_epoch(:nonsense) }.should raise_error ArgumentError
      end
    end
  end
  
  #--------------
  
  describe "#time_since_beginning_of_week" do
    let(:t) { Chronic.parse("Tuesday 1am") } # 49 hours after Sunday 12am
    
    context "seconds" do
      it "returns the seconds since the beginning of the week" do
        seconds = 3600 * 49
        t.time_since_beginning_of_week(:seconds).should eq seconds
        t.second_of_week.should eq seconds
      end
    end
    
    context "minutes" do
      it "returns the minutes since the beginning of the week" do
        minutes = 60 * 49
        t.time_since_beginning_of_week(:minutes).should eq minutes
        t.minute_of_week.should eq minutes
      end
    end
    
    context "hours" do
      it "returns the hours since the beginning of the week" do
        hours = 1 * 49
        t.time_since_beginning_of_week(:hours).should eq hours
        t.hour_of_week.should eq hours
      end
    end
  end
end
