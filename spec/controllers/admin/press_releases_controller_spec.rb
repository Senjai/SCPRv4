require "spec_helper"

describe Outpost::PressReleasesController do
  it_behaves_like "resource controller" do
    let(:resource) { :press_release }
  end
end
