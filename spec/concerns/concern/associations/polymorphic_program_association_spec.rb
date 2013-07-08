require 'spec_helper'

describe Concern::Associations::PolymorphicProgramAssociation do
  it 'sets the program based on the program_obj_key' do
    program = create :kpcc_program
    post = build :test_class_post
    post.program.should eq nil

    post.program_obj_key = program.obj_key
    post.program.should eq program
  end
end
