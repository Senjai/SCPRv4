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

  describe '::find_by_slug!' do
    it 'finds program by slug if available' do
      program = create :kpcc_program
      Program.find_by_slug!(program.slug).should eq program.to_program
    end

    it 'raise AR::RNF if slug is not found' do
      expect { Program.find_by_slug!("lolnope") }.to raise_error ActiveRecord::RecordNotFound
    end
  end

  describe '#uses_segments_as_episodes?' do
    it 'is false if it shows episodes' do
      program = Program.new({
        :display_episodes => true,
        :display_segments => true
      })

      program.uses_segments_as_episodes?.should eq false
    end

    it 'is true if it does not show episodes, and shows segments' do
      program = Program.new({
        :display_episodes => false,
        :display_segments => true
      })

      program.uses_segments_as_episodes?.should eq true
    end
  end
end
