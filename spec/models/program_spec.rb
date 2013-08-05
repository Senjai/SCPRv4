require 'spec_helper'

describe Program do
  describe '::all' do
    it "mixes all KPCC and External programs" do
      kpcc      = create :kpcc_program
      external  = create :external_program

      Program.all.should eq [kpcc, external].map(&:to_program)
    end
  end

  describe '::find_by_slug' do
    it "returns a KPCC program if it's available" do
      kpcc      = create :kpcc_program
      external  = create :external_program

      Program.find_by_slug(kpcc.slug).should eq kpcc.to_program
    end

    it "looks at ExternalProgram if no KPCC program is available" do
      external  = create :external_program

      Program.find_by_slug(external.slug).should eq external.to_program
    end
  end
end
