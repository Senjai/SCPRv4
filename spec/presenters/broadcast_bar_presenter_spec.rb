require "spec_helper"

describe BroadcastBarPresenter do
  describe '#show_modal?' do
    it 'is false if the slot is not recurring' do
      slot  = build :schedule_occurrence
      p     = presenter(slot)

      p.show_modal?.should eq false
    end

    it 'is false if programs display_episodes is false' do
      program   = build :kpcc_program, display_episodes: false
      slot      = build :schedule_occurrence, :recurring, program: program
      p         = presenter(slot)

      p.show_modal?.should eq false
    end

    it 'is true for recurring episodic kpcc programs' do
      program   = build :kpcc_program, display_episodes: true
      slot      = build :schedule_occurrence, :recurring, program: program
      p         = presenter(slot)

      p.show_modal?.should eq true
    end
  end

  describe '#is_for_featured_program?' do
    it 'is false if not recurring' do
      slot = build :schedule_occurrence
      p    = presenter(slot)

      p.is_for_featured_program?.should eq false
    end

    it 'is false if the program is not featured' do
      program = build :kpcc_program, is_featured: false
      slot    = build :schedule_occurrence, :recurring, program: program
      p       = presenter(slot)

      p.is_for_featured_program?.should eq false
    end

    it 'is true for recurring slots for featured programs' do
      program = build :kpcc_program, is_featured: true
      slot    = build :schedule_occurrence, :recurring, program: program
      p       = presenter(slot)

      p.is_for_featured_program?.should eq true
    end
  end

  describe '#modal_class' do
    it 'is a string if show_modal is true' do
      slot = build :schedule_occurrence, :recurring
      p    = presenter(slot)
      p.stub(:show_modal?) { true }

      p.modal_class.should be_a String
    end

    it 'is nil if not show_modal' do
      slot = build :schedule_occurrence, :recurring
      p    = presenter(slot)
      p.stub(:show_modal?) { false }

      p.modal_class.should eq nil
    end
  end

  describe '#toggler_id' do
    it 'is a string if show_modal is true' do
      slot = build :schedule_occurrence, :recurring
      p    = presenter(slot)
      p.stub(:show_modal?) { true }

      p.toggler_id.should be_a String
    end

    it 'is nil if not show_modal' do
      slot = build :schedule_occurrence, :recurring
      p    = presenter(slot)
      p.stub(:show_modal?) { false }

      p.toggler_id.should eq nil
    end
  end

  describe '#headshot_class' do
    it 'is a string if is_for_featured_program is true' do
      slot = build :schedule_occurrence, :recurring, :with_program
      p    = presenter(slot)
      p.stub(:is_for_featured_program?) { true }

      p.headshot_class.should be_a String
    end

    it 'is nil if not is_for_featured_program' do
      slot = build :schedule_occurrence, :recurring, :with_program
      p    = presenter(slot)
      p.stub(:is_for_featured_program?) { false }

      p.headshot_class.should eq nil
    end
  end
end
