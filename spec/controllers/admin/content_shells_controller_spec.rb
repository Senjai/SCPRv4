require "spec_helper"

describe Admin::ContentShellsController do
  it_behaves_like "resource controller" do
    let(:resource) { :content_shell }
  end
end
