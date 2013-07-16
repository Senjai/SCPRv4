require "spec_helper"

describe ExternalProgram do
  describe "scopes" do
    describe "active" do
      it "selects programs with online or onair status" do
        onair   = create :external_program, air_status: "onair"
        online  = create :external_program, air_status: "online"
        hidden  = create :external_program, air_status: "hidden"
        archive = create :external_program, air_status: "archive"
        ExternalProgram.active.sort.should eq [onair, online].sort
      end
    end
  end

  #-----------------

  describe "published?" do
    it "is true if air_status is not hidden" do
      onair   = build :external_program, air_status: "onair"
      online  = build :external_program, air_status: "online"
      archive = build :external_program, air_status: "archive"

      onair.published?.should eq true
      online.published?.should eq true
      archive.published?.should eq true
    end

    it "is false if air_status is hidden" do
      hidden = build :external_program, air_status: "hidden"
      hidden.published?.should eq false
    end
  end
end
