require 'spec_helper'

describe RecurringScheduleSlot do
  describe 'setting the program' do
    it 'sets the program based on the object key' do
      program = create :kpcc_program
      slot = build :recurring_schedule_slot, program: nil
      slot.program_obj_key = program.obj_key
      slot.save!

      slot.program.should eq program
    end
  end
end
