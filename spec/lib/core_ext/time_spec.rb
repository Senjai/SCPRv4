require 'spec_helper'

describe Time do
  describe "#second_of_week" do
    let(:t) { Time.new(2012, 10, 30, 1, 0, 0) } # 49 hours after Sunday 12am
    
    context "seconds" do
      it "returns the seconds since the beginning of the week" do
        seconds = 3600 * 49
        t.second_of_week.should eq seconds
      end
    end
  end
end
