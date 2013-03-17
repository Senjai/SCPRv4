require "spec_helper"

describe Outpost::ContentShellsController do
  it_behaves_like "resource controller" do
    let(:resource) { :content_shell }
  end
end
