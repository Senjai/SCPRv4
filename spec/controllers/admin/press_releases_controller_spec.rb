require "spec_helper"

describe Admin::PressReleasesController do
  it_behaves_like "resource controller" do
    let(:resource) { :press_release }
  end
end
