require "spec_helper"

describe Concern::Associations::AudioAssociation do
  subject { TestClass::Story.new }
  
  it { should have_many(:audio) }
  
  it "orders properly" do
    subject.audio.to_sql.should match /order by position/i
  end
  
  #------------------
  
  describe "#should_reject_audio?" do
    it "is true if all of the attributes are blank" do
      attributes = {
        'mp3'         => '',
        'enco_number' => '',
        'enco_date'   => '',
        'mp3_path'    => '',
        'description' => '',
        'byline'      => ''
      }
      
      subject.send(:should_reject_audio?, attributes).should eq true
    end
    
    it "is false if any of the attributes are present" do
      attributes = {
        'mp3'         => '',
        'enco_number' => '999',
        'enco_date'   => '',
        'mp3_path'    => '',
        'description' => 'Cool Audio',
        'byline'      => ''
      }
      
      subject.send(:should_reject_audio?, attributes).should eq false
    end
  end
end
