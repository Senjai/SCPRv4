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

  describe '#has_episodes?' do
    it 'is false if it does not use episodes' do
      program = Program.new({
        :display_segments => true,
        :display_episodes => false,
        :episodes => []
      })

      program.uses_episodes?.should eq false
    end

    it 'is true if it uses episodes' do
      program = Program.new({
        :display_segments => true,
        :display_episodes => true,
        :episodes => [1, 2, 3]
      })

      program.has_episodes?.should eq true
    end
  end
end
