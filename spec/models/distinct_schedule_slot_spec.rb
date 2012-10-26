require 'spec_helper'

describe DistinctScheduleSlot do  
  describe "validations" do
    it { should validate_presence_of(:starts_at) }
    it { should validate_presence_of(:ends_at) }
    it { should validate_presence_of(:title) }
  end
end
