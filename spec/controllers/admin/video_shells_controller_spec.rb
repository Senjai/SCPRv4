require "spec_helper"

describe Outpost::VideoShellsController do
  it_behaves_like "resource controller" do
    let(:resource) { :video_shell }
  end
end
